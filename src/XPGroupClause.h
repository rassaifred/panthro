//
//  XPGroupClause.h
//  Panthro
//
//  Created by Todd Ditchendorf on 7/7/14.
//
//

#import <Foundation/Foundation.h>

@class XPExpression;

@interface XPGroupClause : NSObject

+ (instancetype)groupClauseWithVariableName:(NSString *)varName expression:(XPExpression *)expr;

@property (nonatomic, retain) NSString *variableName;
@property (nonatomic, retain) XPExpression *expression;
@end
