//
//  XPDescendingComparer.h
//  XPath
//
//  Created by Todd Ditchendorf on 8/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XPath/XPComparer.h>

@class XPComparer;

@interface XPDescendingComparer : XPComparer
+ (XPDescendingComparer *)descendingComparerWithComparer:(XPComparer *)c;
@end
