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

	/** Keeps track of where each power node is */
	NSMutableSet *powerNodes_;	
	
}

@property (nonatomic, readonly) NSMutableDictionary *wires;

/** Returns the ElectricGrid singleton */
+ (ElectricGrid *) electricGrid;

/**  */
- (Wire *) addWireAtGrid:(Pair *)p;

/**  */
- (Wire *) addWireAtGrid:(Pair *)p delegate:(id <WireDelegate>)delegate;

/**  */
- (void) addDelegateToWireAtPos:(Pair *)p delegate:(id <WireDelegate>)delegate;

/** Method to add a node that always has power */
- (void) setPowerNode:(Wire *)w;

/**  */
- (void) removeWireAtGrid:(Pair *)p;

/**  */
- (BOOL) wireAtGrid:(Pair *)p;

/**  */
- (void) updateWireAtGrid:(Pair *)p;

/** Returns whether or not any adjacent wire tile has power */
- (BOOL) isAdjacentPowered:(Wire *)wire;

/** Method to return an array of wire neighbors that do not appear in the given set */
- (NSArray *) getNeighbors:(Pair *)p notInSet:(NSSet *)set;

/** Method to return an array of wire neighbors */
- (NSArray *) getNeighbors:(Pair *)p;

/** Returns whether or not this grid has power (and has a wire) */
- (BOOL) isGridPowered:(Pair *)p;

/** Returns whether or not there is a wire path from position p to any of the power nodes */
- (BOOL) pathToPower:(Pair *)p powerNodes:(NSSet *)power;

@end
