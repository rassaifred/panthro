//
//  FNStringLengthTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/21/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "FNStringLengthTest.h"

@implementation FNStringLengthTest

- (void)setUp {
    
}


- (void)testErrors {
    NSError *err = nil;
    [XPExpression expressionFromString:@"string-length(1, 2)" inContext:nil error:&err];
    TDNil(err);
}


- (void)testNumbers {
    self.expr = [XPExpression expressionFromString:@"string-length()" inContext:nil error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, _res);
    
    self.expr = [XPExpression expressionFromString:@"string-length(0)" inContext:nil error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(1.0, _res);
    
    self.expr = [XPExpression expressionFromString:@"string-length(-0)" inContext:nil error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(2.0, _res);
}


- (void)testStrings {
    self.expr = [XPExpression expressionFromString:@"string-length()" inContext:nil error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, _res);
    
    self.expr = [XPExpression expressionFromString:@"string-length('foo')" inContext:nil error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(3.0, _res);
    
    self.expr = [XPExpression expressionFromString:@"string-length('')" inContext:nil error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, _res);
}


- (void)testBooleans {
    self.expr = [XPExpression expressionFromString:@"string-length(true())" inContext:nil error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(4.0, _res);
    
    self.expr = [XPExpression expressionFromString:@"string-length(false())" inContext:nil error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(5.0, _res);
}

@end
