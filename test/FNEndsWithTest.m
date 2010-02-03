//
//  FNEndsWithTest.m
//  Exedore
//
//  Created by Todd Ditchendorf on 7/20/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNEndsWithTest.h"

@implementation FNEndsWithTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"ends-with('foo')" inContext:nil error:&err];
    TDNotNil(err);
    
    [XPExpression expressionFromString:@"ends-with()" inContext:nil error:&err];
    TDNotNil(err);
    
    [XPExpression expressionFromString:@"ends-with('1', '2', '3')" inContext:nil error:&err];
    TDNotNil(err);
}


- (void)testFoo {
    expr = [XPExpression expressionFromString:@"ends-with('foo', 'bar')" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);

    expr = [XPExpression expressionFromString:@"ends-with('bar', 'foobar')" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDFalse(res);

    expr = [XPExpression expressionFromString:@"ends-with('foobar', 'bar')" inContext:nil error:nil];
    res = [expr evaluateAsBooleanInContext:nil];
    TDTrue(res);
}

@end
