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

	NSMutableDictionary *wires_;
	
}

+ (ElectricGrid *) electricGrid;

//- (BOOL) addWireAtGrid:(Pair *)p wire:(Wire *)w;
- (Wire *) addWireAtGrid:(Pair *)p;

- (Wire *) addWireAtGrid:(Pair *)p delegate:(id <WireDelegate>)delegate;

- (void) removeWireAtGrid:(Pair *)p;

- (BOOL) wireAtGrid:(Pair *)p;

- (void) updateWireAtGrid:(Pair *)p;

- (BOOL) isAdjacentPowered:(Wire *)wire;

- (void) powerAdjcent:(Wire *)wire;

- (NSArray *) getUnpoweredNeighbors:(Pair *)p;

- (BOOL) isGridPowered:(Pair *)p;

@end
