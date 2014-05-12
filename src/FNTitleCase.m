//
//  FNTitleCase.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNTitleCase.h"
#import "XPValue.h"
#import "XPStringValue.h"

@interface XPExpression ()
@property (nonatomic, readwrite, retain) id <XPStaticContext>staticContext;
@property (nonatomic, retain) NSMutableArray *args;
@end

@interface XPFunction ()
- (NSUInteger)checkArgumentCountForMin:(NSUInteger)min max:(NSUInteger)max;
@end

@implementation FNTitleCase

- (NSString *)name {
    return @"title-case";
}


- (XPDataType)dataType {
    return XPDataTypeString;
}


- (XPExpression *)simplify {
    [self checkArgumentCountForMin:1 max:1];

    id arg0 = [self.args[0] simplify];
    self.args[0] = arg0;

    if ([arg0 isValue]) {
        return [self evaluateInContext:nil];
    }

    return self;
}


- (NSString *)evaluateAsStringInContext:(XPContext *)ctx {
    NSString *s = [self.args[0] evaluateAsStringInContext:ctx];
    if ([s length]) {
        unichar c = toupper([s characterAtIndex:0]);
        s = [NSString stringWithFormat:@"%C%@", c, [s substringFromIndex:1]];
    }
    return s;
}


- (XPValue *)evaluateInContext:(XPContext *)ctx {
    return [XPStringValue stringValueWithString:[self evaluateAsStringInContext:ctx]];
}


- (XPDependencies)dependencies {
    NSUInteger dep = 0;
    for (XPExpression *arg in self.args) {
        dep |= [arg dependencies];
    }
    return dep;
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    FNTitleCase *f = [[[FNTitleCase alloc] init] autorelease];
    [f addArgument:[self.args[0] reduceDependencies:dep inContext:ctx]];
    [f setStaticContext:[self staticContext]];
    return [f simplify];
}

@end
