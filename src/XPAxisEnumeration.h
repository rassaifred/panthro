//
//  XPAxisEnumeration.h
//  Panthro
//
//  Created by Todd Ditchendorf on 4/22/14.
//
//

#import "XPSequenceEnumeration.h"
#import "XPLastPositionFinder.h"

@protocol XPItem;

/**
 * A NodeEnumeration is used to iterate over a list of nodes. An AxisEnumeration
 * is a NodeEnumeration that throws no exceptions; it also supports the ability
 * to find the last() position, again with no exceptions.
 */
@protocol XPAxisEnumeration <XPSequenceEnumeration, XPLastPositionFinder>

/**
 * Get the last position
 */

- (NSUInteger)lastPosition;
@end
