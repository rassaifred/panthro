//
//  XPNumericValueTest.m
//  Panthro
//
//  Created by Todd Ditchendorf on 7/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "XPTestScaffold.h"

@interface XPNumericValueTest : XCTestCase
@property (nonatomic, retain) XPNumericValue *n1;
@property (nonatomic, retain) XPNumericValue *n2;
@property (nonatomic, retain) XPExpression *expr;
@property (nonatomic, assign) double res;
@end

@implementation XPNumericValueTest

- (void)dealloc {
    self.n1 = nil;
    self.n2 = nil;
    self.expr =nil;
    [super dealloc];
}


- (void)setUp {
    self.n1 = [XPNumericValue numericValueWithNumber:1];
    self.n2 = [XPNumericValue numericValueWithNumber:2];
}


- (void)testRelationalExpr {
    self.expr =[XPExpression expressionFromString:@"1 != 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"2 = 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"42.0 = 42" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"3.140 = 3.14" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"1 < 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"1 <= 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"2 > 1" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"2 >= 1" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"1 = '1'" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"'1' = 1" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"1 = --1" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"1 = ---1" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDFalse(_res);
}


- (void)testValueRelationalExpr {
    self.expr =[XPExpression expressionFromString:@"1 ne 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"2 eq 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"42.0 eq 42" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"3.140 eq 3.14" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"1 lt 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"1 le 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"2 gt 1" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"2 ge 1" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"1 eq '1'" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"'1' eq 1" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"1 eq --1" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDTrue(_res);
    
    self.expr =[XPExpression expressionFromString:@"1 eq ---1" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsBooleanInContext:nil];
    TDFalse(_res);
}


- (void)testArithmeticExpr {
    self.expr =[XPExpression expressionFromString:@"1 + 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(3.0, _res);
    
    self.expr =[XPExpression expressionFromString:@"1 - 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(-1.0, _res);
    
    self.expr =[XPExpression expressionFromString:@"3 * 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(6.0, _res);
    
    self.expr =[XPExpression expressionFromString:@"9 div 3" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(3.0, _res);
    
    self.expr =[XPExpression expressionFromString:@"10 mod 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(0.0, _res);
}


- (void)testArithmeticExpr2 {
    self.expr =[XPExpression expressionFromString:@"1- 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(-1.0, _res);
}


- (void)testArithmeticExpr3 {
    self.expr =[XPExpression expressionFromString:@"1 -2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(-1.0, _res);
}


- (void)testArithmeticExpr4 {
    self.expr =[XPExpression expressionFromString:@"1-0.0" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(1.0, _res);
}


- (void)testArithmeticExpr5 {
    self.expr =[XPExpression expressionFromString:@"1- 0" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(1.0, _res);
}


- (void)testArithmeticExpr6 {
    self.expr =[XPExpression expressionFromString:@"1 -0" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(1.0, _res);
}


- (void)testArithmeticExpr7 {
    self.expr =[XPExpression expressionFromString:@"1-0" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(1.0, _res);
}


- (void)testArithmeticExpr8 {
    self.expr =[XPExpression expressionFromString:@"1-(2)" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(-1.0, _res);
}


- (void)testArithmeticExpr9 {
    self.expr =[XPExpression expressionFromString:@"1--2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(3.0, _res);
}


- (void)testArithmeticExpr10 {
    self.expr =[XPExpression expressionFromString:@"1 --2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(3.0, _res);
}


- (void)testArithmeticExpr11 {
    self.expr =[XPExpression expressionFromString:@"1 -- 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(3.0, _res);
}


- (void)testArithmeticExpr12 {
    self.expr =[XPExpression expressionFromString:@"1 - - 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(3.0, _res);
}


- (void)testArithmeticExpr13 {
    self.expr =[XPExpression expressionFromString:@"1---2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(-1.0, _res);
}


- (void)testArithmeticExpr14 {
    self.expr =[XPExpression expressionFromString:@"1 ---2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(-1.0, _res);
}


- (void)testArithmeticExpr15 {
    self.expr =[XPExpression expressionFromString:@"1 --- 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(-1.0, _res);
}


- (void)testArithmeticExpr16 {
    self.expr =[XPExpression expressionFromString:@"1 - - - 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(-1.0, _res);
}


- (void)testArithmeticExpr17 {
    self.expr =[XPExpression expressionFromString:@"1++2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(3.0, _res);
}


- (void)testArithmeticExpr18 {
    self.expr =[XPExpression expressionFromString:@"1 ++2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(3.0, _res);
}


- (void)testArithmeticExpr19 {
    self.expr =[XPExpression expressionFromString:@"1 ++ 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(3.0, _res);
}


- (void)testArithmeticExpr20 {
    self.expr =[XPExpression expressionFromString:@"1 + + 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(3.0, _res);
}


- (void)testArithmeticExpr21 {
    self.expr =[XPExpression expressionFromString:@"1+++2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(3.0, _res);
}


- (void)testArithmeticExpr22 {
    self.expr =[XPExpression expressionFromString:@"1 +++2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(3.0, _res);
}


- (void)testArithmeticExpr23 {
    self.expr =[XPExpression expressionFromString:@"1 +++ 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(3.0, _res);
}


- (void)testArithmeticExpr24 {
    self.expr =[XPExpression expressionFromString:@"1 + + + 2" inContext:[XPStandaloneContext standaloneContext] error:nil];
    self.res = [_expr evaluateAsNumberInContext:nil];
    TDEquals(3.0, _res);
}

@end
