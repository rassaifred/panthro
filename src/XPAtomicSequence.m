//
//  XPAtomicSequence.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/5/14.
//
//

#import "XPAtomicSequence.h"
#import "XPAtomicSequenceEnumeration.h"

@interface XPAtomicSequence ()
@property (nonatomic, retain) NSArray *content;
@end

@implementation XPAtomicSequence

- (instancetype)initWithContent:(NSArray *)v {
    XPAssert(v);
    self = [super init];
    if (self) {
        self.content = v;
    }
    return self;
}


- (void)dealloc {
    self.content = nil;
    [super dealloc];
}


- (NSString *)description {
    NSMutableString *s = [NSMutableString stringWithString:@"("];

    NSUInteger c = [self count];
    NSString *sep = @", ";
    for (NSUInteger i = 0; i < c; ++i) {
        if (i == c - 1) {
            sep = @"";
        }
        [s appendFormat:@"%@%@", [self itemAt:i], sep];
    }
    
    [s appendString:@")"];
    return s;
}


#pragma mark -
#pragma mark XPExpression

//- (XPExpression *)simplify {
//    XPExpression *result = self;
//    
//    if (0 == [self count]) {
//        result = [XPEmptyAtomicSequence instance];
//        
//    }
//    
//    return result;
//}


- (id <XPSequenceEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)yn {
    if (yn) [self sort];
    return [self enumerate];
}


- (BOOL)isSorted {
    return YES;
}


- (BOOL)isReverseSorted {
    return NO;
}


- (void)setSorted:(BOOL)sorted {}
- (void)setReverseSorted:(BOOL)reverseSorted {}


- (NSString *)asString {
    return [[self head] stringValue];
}


- (BOOL)asBoolean {
    return [self count] > 0;
}


- (XPSequenceValue *)sort {
    return self;
}


#pragma mark -
#pragma mark XPSequence

- (id <XPItem>)head {
    return [self itemAt:0];
}


- (id <XPSequenceEnumeration>)enumerate {
    id <XPSequenceEnumeration>enm = [[[XPAtomicSequenceEnumeration alloc] initWithAtomicSequence:self] autorelease];
    return enm;
}


#pragma mark -
#pragma mark XPAtomicSequence

- (XPValue *)itemAt:(NSUInteger)i {
    XPAssert(_content);
    return [_content objectAtIndex:i];
}


- (NSUInteger)count {
    XPAssert(_content);
    return [_content count];
}

@end
