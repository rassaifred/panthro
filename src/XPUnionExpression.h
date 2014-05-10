//
//  XPUnionExpression.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/7/14.
//
//

#import "XPNodeSetExpression.h"

@interface XPUnionExpression : XPNodeSetExpression

- (instancetype)initWithLhs:(XPExpression *)lhs rhs:(XPExpression *)rhs;
@end
