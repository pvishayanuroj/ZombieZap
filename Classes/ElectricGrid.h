//
//  ElectricGrid.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/16/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "WireDelegate.h"

@class Pair;
@class Wire;

@interface ElectricGrid : NSObject {

	/** Dictionary mapping positions on the map to wire objects */
	NSMutableDictionary *wires_;
	
}

/** Returns the ElectricGrid singleton */
+ (ElectricGrid *) electricGrid;

/**  */
- (Wire *) addWireAtGrid:(Pair *)p;

/**  */
- (Wire *) addWireAtGrid:(Pair *)p delegate:(id <WireDelegate>)delegate;

/**  */
- (void) removeWireAtGrid:(Pair *)p;

/**  */
- (BOOL) wireAtGrid:(Pair *)p;

/**  */
- (void) updateWireAtGrid:(Pair *)p;

/** Returns whether or not any adjacent wire tile has power */
- (BOOL) isAdjacentPowered:(Wire *)wire;

/** Method that powers this wire and propagates power to all connected unpowered wires */
- (void) powerAdjcent:(Wire *)wire;

/** Method to return an array of unpowered neighbors */
- (NSArray *) getUnpoweredNeighbors:(Pair *)p;

/** Returns whether or not this grid has power (and has a wire) */
- (BOOL) isGridPowered:(Pair *)p;

@end
