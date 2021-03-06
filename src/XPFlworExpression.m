//
//  XPForExpression.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import "XPFlworExpression.h"
#import "XPContext.h"
#import "XPSequenceEnumeration.h"
#import "XPSequenceExtent.h"
#import "XPForClause.h"
#import "XPLetClause.h"
#import "XPGroupClause.h"
#import "XPOrderClause.h"
#import "XPTuple.h"
#import "XPGroupSpec.h"
#import "XPOrderSpec.h"
#import "XPEGParser.h"
#import "XPNumericValue.h"

@interface XPFlworExpression ()
@property (nonatomic, retain) NSArray *forClauses;
@property (nonatomic, retain) XPExpression *whereExpression;
@property (nonatomic, retain) NSArray *groupClauses;
@property (nonatomic, retain) NSArray *orderClauses;
@property (nonatomic, retain) XPExpression *bodyExpression;
@end

@implementation XPFlworExpression

- (instancetype)initWithForClauses:(NSArray *)forClauses where:(XPExpression *)whereExpr groupClauses:(NSArray *)groupClauses orderClauses:(NSArray *)orderClauses body:(XPExpression *)bodyExpr {
    self = [super init];
    if (self) {
        self.forClauses = forClauses;
        self.whereExpression = whereExpr;
        self.groupClauses = groupClauses;
        self.orderClauses = orderClauses;
        self.bodyExpression = bodyExpr;
    }
    return self;
}


- (void)dealloc {
    self.forClauses = nil;
    self.whereExpression = nil;
    self.groupClauses = nil;
    self.orderClauses = nil;
    self.bodyExpression = nil;
    [super dealloc];
}


- (id)copyWithZone:(NSZone *)zone {
    XPFlworExpression *expr = [super copyWithZone:zone];
    expr.forClauses = [[_forClauses copy] autorelease];
    expr.whereExpression = [[_whereExpression copy] autorelease];
    expr.groupClauses = [[_groupClauses copy] autorelease];
    expr.orderClauses = [[_orderClauses copy] autorelease];
    expr.bodyExpression = [[_bodyExpression copy] autorelease];
    return expr;
}


- (XPDependencies)dependencies {
    NSUInteger dep = 0;
    for (XPForClause *forClause in _forClauses) {
        dep |= [forClause.expression dependencies];
    }
    
    dep |= [_whereExpression dependencies];

    for (XPOrderClause *orderClause in _orderClauses) {
        dep |= [orderClause.expression dependencies];
    }

    dep |= [_bodyExpression dependencies];

    return dep;
}


- (XPExpression *)reduceDependencies:(XPDependencies)dep inContext:(XPContext *)ctx {
    return self; // TODO
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return [self evaluateAsSequenceInContext:ctx];
}


- (XPSequenceValue *)evaluateAsSequenceInContext:(XPContext *)ctx {
    XPAssert([_forClauses count]);
    XPAssert(_bodyExpression);
    
    NSMutableArray *tuples = [NSMutableArray array];
    [self loopInContext:ctx forClauses:_forClauses tuples:tuples];
    
    // group by
//    NSUInteger groupClauseCount = [_groupClauses count];
//    if (groupClauseCount > 0) {
//        NSMutableArray *newGroupedTuples = [NSMutableArray array];
//        
//        for (XPTuple *t in tuples) {
//            
//        }
//        
//        tuples = newGroupedTuples;
//    }
    
    // order by
    NSUInteger orderClauseCount = [_orderClauses count];
    if (orderClauseCount > 0) {
        [tuples sortUsingComparator:^NSComparisonResult(XPTuple *t1, XPTuple *t2) {
            NSComparisonResult res = NSOrderedSame;
            NSUInteger orderSpecIdx = 0;

            do {
                XPAssert(orderSpecIdx < [t1.orderSpecs count]);
                XPAssert(orderSpecIdx < [t2.orderSpecs count]);
                
                XPOrderSpec *spec1 = t1.orderSpecs[orderSpecIdx];
                XPOrderSpec *spec2 = t2.orderSpecs[orderSpecIdx];
                XPAssert(spec1.modifier == spec2.modifier);
                
                XPValue *val1 = spec1.value;
                XPValue *val2 = spec2.value;
                
                XPAssert([val1 isKindOfClass:[XPValue class]]);
                XPAssert([val2 isKindOfClass:[XPValue class]]);
                
                NSComparisonResult mod = spec1.modifier;
                XPAssert(NSOrderedSame != mod);
                
                if (NSOrderedAscending == mod) {
                    res = [val1 compareToValue:val2];
                } else {
                    res = [val2 compareToValue:val1];
                }
                
                ++orderSpecIdx;
            } while (NSOrderedSame == res && orderSpecIdx < orderClauseCount);
                
            return res;
        }];
    }
    
    NSMutableArray *result = [NSMutableArray array];
    for (XPTuple *t in tuples) {
        [result addObjectsFromArray:t.resultItems];
    }
    
    XPAssert(result);
    XPSequenceValue *seq = [[[XPSequenceExtent alloc] initWithContent:result] autorelease];
    return seq;
}


- (void)loopInContext:(XPContext *)ctx forClauses:(NSArray *)forClauses tuples:(NSMutableArray *)inTuples {
    XPAssert([forClauses count]);
    XPAssert(_bodyExpression);
    
    XPForClause *curForClause = forClauses[0];
    NSArray *forClausesTail = [forClauses subarrayWithRange:NSMakeRange(1, [forClauses count]-1)];
    
    id <XPSequenceEnumeration>seqEnm = [curForClause.expression enumerateInContext:ctx sorted:NO];

    NSUInteger idx = 1;
    while ([seqEnm hasMoreItems]) {
        id <XPItem>forItem = [seqEnm nextItem];
        [ctx setItem:forItem forVariable:curForClause.variableName];
        if (curForClause.positionName) {
            [ctx setItem:[XPNumericValue numericValueWithNumber:idx++] forVariable:curForClause.positionName];
        }

        for (XPLetClause *letClause in curForClause.letClauses) {
            id <XPItem>letItem = [letClause.expression evaluateInContext:ctx];
            [ctx setItem:letItem forVariable:letClause.variableName];
        }
        
        if ([forClausesTail count]) {
            [self loopInContext:[[ctx copy] autorelease] forClauses:forClausesTail tuples:inTuples];
        } else {
            
            // where test
            BOOL whereTest = YES;
            if (_whereExpression) {
                whereTest = [_whereExpression evaluateAsBooleanInContext:ctx];
            }
            
            if (whereTest) {
                id <XPSequenceEnumeration>bodyEnm = [_bodyExpression enumerateInContext:ctx sorted:NO];
                
                NSMutableArray *tupleResItems = [NSMutableArray array];
                NSMutableArray *tupleGroupSpecs = [NSMutableArray array];
                NSMutableArray *tupleOrderSpecs = [NSMutableArray array];
                
                while ([bodyEnm hasMoreItems]) {
                    // YIKES. This call to -head is for XPSingletonNodeSet-wrapped NodeInfos
                    id <XPItem>bodyItem = [[bodyEnm nextItem] head];
                    
                    [tupleResItems addObject:bodyItem];
                    
                    for (XPGroupClause *groupClause in _groupClauses) {
                        // calling -head here for force a single atomic value. but supposed to throw and exception if it's a sequence with more than 1 item
                        XPValue *specVal = (id)[XPAtomize([groupClause.expression evaluateInContext:ctx]) head];
                        XPGroupSpec *spec = [XPGroupSpec groupSpecWithValue:specVal];
                        [tupleGroupSpecs addObject:spec];
                    }
                    
                    for (XPOrderClause *orderClause in _orderClauses) {
                        // calling -head here for force a single atomic value. but supposed to throw and exception if it's a sequence with more than 1 item
                        XPValue *specVal = (id)[XPAtomize([orderClause.expression evaluateInContext:ctx]) head];
                        XPOrderSpec *spec = [XPOrderSpec orderSpecWithValue:specVal modifier:orderClause.modifier];
                        [tupleOrderSpecs addObject:spec];
                    }
                }

                if ([tupleResItems count]) {
                    XPTuple *t = [XPTuple tupeWithResultItems:tupleResItems groupSpecs:tupleGroupSpecs orderSpecs:tupleOrderSpecs];
                    XPAssert(inTuples);
                    [inTuples addObject:t];
                }
            }
        }
    }
}


- (XPDataType)dataType {
    return XPDataTypeSequence;
}

@end
