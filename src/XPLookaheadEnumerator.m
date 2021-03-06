//
//  XPLookaheadNumerator.m
//  Panthro
//
//  Created by Todd Ditchendorf on 5/9/14.
//
//

#import "XPLookaheadEnumerator.h"
#import "XPSequenceEnumeration.h"

@interface XPLookaheadEnumerator ()
@property (nonatomic, retain) id <XPSequenceEnumeration>base;
@property (nonatomic, retain) NSMutableArray *reservoir;
@property (nonatomic, assign) NSUInteger reservoirPosition;
@property (nonatomic, assign) NSUInteger position;
@property (nonatomic, assign) NSUInteger last;
@end

@implementation XPLookaheadEnumerator

/**
 * Constructor
 * @param base An NodeEnumerator that delivers the nodes, but that cannot determine the
 * last position count.
 */

- (instancetype)initWithBase:(id <XPSequenceEnumeration>)base {
    XPAssert(![base conformsToProtocol:@protocol(XPLastPositionFinder)]);
    self = [super init];
    if (self) {
        self.base = base;
        self.reservoirPosition = NSNotFound;
    }
    return self;
}


- (void)dealloc {
    self.base = nil;
    self.reservoir = nil;
    [super dealloc];
}


/**
 * Determine whether there are any more nodes to hand to the client
 */

- (BOOL)hasMoreItems {
    if (!_reservoir) {
        return [_base hasMoreItems];
    } else {
        return _reservoirPosition < [_reservoir count];
    }
}

/**
 * Hand the next node to the client
 */

- (id <XPItem>)nextItem {
    if (!_reservoir) {
        self.position++;
        return [_base nextItem];
    } else {
        if (_reservoirPosition < [_reservoir count]) {
            self.position++;
            return _reservoir[_reservoirPosition++];
        } else {
            return nil;
        }
    }
}

/**
 * Do lookahead to find the last position, if required
 */

- (NSUInteger)lastPosition {
    if (_last > 0) {
        return _last;
    } else {
        // load the reservoir with all remaining input nodes
        self.reservoir = [NSMutableArray array];
        self.reservoirPosition = 0;
        self.last = _position;
        while ([_base hasMoreItems]) {
            [_reservoir addObject:[_base nextItem]];
            self.last++;
        }
        return _last;
    }
}


/**
 * Determine whether the nodes are guaranteed to be in document order
 */

- (BOOL)isSorted {
    return _base.isSorted;
}


- (BOOL)isReverseSorted {
    return _base.isReverseSorted;
}


/**
 * Determine whether the nodes are guaranteed to be peers
 */

- (BOOL)isPeer {
    return _base.isPeer;
}

@end
