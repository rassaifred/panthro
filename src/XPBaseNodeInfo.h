//
//  XPBaseNodeInfo.h
//  Panthro
//
//  Created by Todd Ditchendorf on 5/12/14.
//
//

#import <Panthro/XPNodeInfo.h>

@interface XPBaseNodeInfo : NSObject <XPNodeInfo>

+ (void)incrementInstanceCount;
+ (NSUInteger)instanceCount;

@end
