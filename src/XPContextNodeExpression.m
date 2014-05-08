//
//  XPContextNodeExpression.m
//  XPath
//
//  Created by Todd Ditchendorf on 5/7/14.
//
//

#import "XPContextNodeExpression.h"
#import "XPContext.h"
#import "XPNodeSetValue.h"
#import "XPNodeInfo.h"
#import "XPNodeTypeTest.h"
#import "XPAxis.h"
#import "XPAxisEnumeration.h"

@implementation XPContextNodeExpression

- (NSString *)description {
    return @"context-node()";
}


- (XPDependencies)dependencies {
    return XPDependenciesContextNode;
}


- (XPExpression *)reduceDependencies:(NSUInteger)dep inContext:(XPContext *)ctx {
    return self;
//    XPAssert(ctx);
//    
//    XPExpression *expr = self;
//    
//    if (0 != (XPDependenciesContextNode & dep)) {
//    }
//    
//    return expr;
}


- (id <XPNodeEnumeration>)enumerateInContext:(XPContext *)ctx sorted:(BOOL)sorted {
    XPNodeTest *nodeTest = [[[XPNodeTypeTest alloc] initWithNodeType:XPNodeTypeNode] autorelease];
    id <XPNodeEnumeration>enm = [ctx.contextNode enumerationForAxis:XPAxisSelf nodeTest:nodeTest];
    XPAssert(enm);
    return enm;
}

@end