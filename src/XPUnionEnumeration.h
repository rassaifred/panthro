//
//  XPUnionEnumeration.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/9/14.
//
//

#import "XPAbstractNodeEnumeration.h"

@protocol XPNodeOrderComparer;

@interface XPUnionEnumeration : XPAbstractNodeEnumeration

- (instancetype)initWithLhs:(id <XPSequenceEnumeration>)lhs rhs:(id <XPSequenceEnumeration>)rhs comparer:(id <XPNodeOrderComparer>)comparer;
@end
