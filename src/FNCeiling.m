//
//  FNCeiling.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Exedore/FNCeiling.h>
#import <Exedore/XPValue.h>
#import <Exedore/XPNumericValue.h>

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNCeiling

- (NSString *)name {
    return @"ceiling";
}


- (NSInteger)dataType {
    return XPDataTypeNumber;
}


- (XPExpression *)simplify {
    [self checkArgumentCountForMin:1 max:1];
    
    id arg0 = [[args objectAtIndex:0] simplify];
    [args replaceObjectAtIndex:0 withObject:arg0];
    
    if ([arg0 isValue]) {
        return [self evaluateInContext:nil];
    }
    
    return self;
}


- (double)evaluateAsNumberInContext:(XPContext *)ctx {
    return ceil([[args objectAtIndex:0] evaluateAsNumberInContext:ctx]);
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    double n = [self evaluateAsNumberInContext:ctx];
    return [XPNumericValue numericValueWithNumber:n];
}


- (NSUInteger)dependencies {
    return [(XPExpression *)[args objectAtIndex:0] dependencies];
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    FNCeiling *f = [[[FNCeiling alloc] init] autorelease];
    [f addArgument:[[args objectAtIndex:0] reduceDependencies:dep inContext:ctx]];
    [f setStaticContext:[self staticContext]];
    return [f simplify];
}

@end
