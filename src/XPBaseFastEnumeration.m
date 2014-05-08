//
//  XPBaseFastEnumeration.m
//  XPath
//
//  Created by Todd Ditchendorf on 5/8/14.
//
//

#import "XPBaseFastEnumeration.h"

@implementation XPBaseFastEnumeration

- (BOOL)isSorted {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (BOOL)isReverseSorted {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (BOOL)hasMoreObjects {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (id <XPNodeInfo>)nextObject {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (BOOL)isPeer {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NO;
}


- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id *)stackbuf count:(NSUInteger)len {
    NSUInteger count = 0;
    
    id <XPNodeInfo>node = nil;
    
    if (0 == state->state) {
        node = [self nextObject];
    } else {
        node = (id <XPNodeInfo>)state->state;
    }
    
    while (node && count < len) {
        stackbuf[count] = node;
        node = [self nextObject];
        count++;
    }
    
    state->state = (unsigned long)node;
    state->itemsPtr = stackbuf;
    state->mutationsPtr = (unsigned long *)self;
    
    return count;
}

@end