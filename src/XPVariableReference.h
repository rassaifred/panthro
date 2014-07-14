//
//  XPVariableReference.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/10/14.
//
//

#import <Panthro/Panthro.h>

@interface XPVariableReference : XPExpression

- (instancetype)initWithName:(NSString *)name;

@property (nonatomic, copy) NSString *name;
@end
