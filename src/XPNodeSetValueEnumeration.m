//
//  XPNodeSetValueEnumeration.m
//  XPath
//
//  Created by Todd Ditchendorf on 5/7/14.
//
//

#import "XPNodeSetValueEnumeration.h"

@interface XPNodeSetValueEnumeration ()
@property (nonatomic, copy) NSArray *nodes;
@property (nonatomic, assign) BOOL isSorted;
@property (nonatomic, assign) NSUInteger idx;
@property (nonatomic, assign) NSUInteger lastPosition;
@end

@implementation XPNodeSetValueEnumeration

- (instancetype)initWithNodes:(NSArray *)nodes isSorted:(BOOL)sorted {
    self = [super init];
    if (self) {
        self.nodes = nodes;
        self.lastPosition = [_nodes count];
        self.idx = 0;
    }
    return self;
}


- (void)dealloc {
    self.nodes = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %lu>", [self class], self, [self.nodes count]];
}


- (BOOL)isReverseSorted {
    return !_isSorted;
}

/**
 * Determine whether there are more nodes to come. <BR>
 * (Note the term "Element" is used here in the sense of the standard Java Enumeration class,
 * it has nothing to do with XML elements).
 * @return true if there are more nodes
 */

- (BOOL)hasMoreObjects {
    XPAssert(NSNotFound != _idx);
    XPAssert(_nodes);
    
    return _idx < _lastPosition;
}

/**
 * Get the next node in sequence. <BR>
 * (Note the term "Element" is used here in the sense of the standard Java Enumeration class,
 * it has nothing to do with XML elements).
 * @return the next NodeInfo
 */

- (id <XPNodeInfo>)nextObject {
    id <XPNodeInfo>node = nil;
    
    if ([self hasMoreObjects]) {
        node = _nodes[_idx++];
    }
    
    return node;
}


- (BOOL)isPeer {
    return NO;
}

@end