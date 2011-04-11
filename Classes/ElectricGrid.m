//
//  ElectricGrid.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/16/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "ElectricGrid.h"
#import "Pair.h"
#import "Wire.h"

// For singleton
static ElectricGrid *_electricGrid = nil;

@implementation ElectricGrid

+ (ElectricGrid *) electricGrid
{
	if (!_electricGrid)
		_electricGrid = [[self alloc] init];
	
	return _electricGrid;
}

+ (id) alloc
{
	NSAssert(_electricGrid == nil, @"Attempted to allocate a second instance of an Electric Grid singleton.");
	return [super alloc];
}

+ (void) purgeElectricGrid
{
	[_electricGrid release];
	_electricGrid = nil;
}

- (id) init
{
	if ((self = [super init]))
	{
		wires_ = [[NSMutableDictionary dictionaryWithCapacity:50] retain];
	}
	return self;
}

- (Wire *) addWireAtGrid:(Pair *)p
{
	return [self addWireAtGrid:p delegate:nil];
}

- (Wire *) addWireAtGrid:(Pair *)p delegate:(id <WireDelegate>)delegate
{
	if ([wires_ objectForKey:p] == nil) {
		
		Wire *w = [Wire wireWithPos:p delegate:delegate];
		
		// Important to add ourself to the grid, so that when our neighbors update their orientation, they see ourself
		// Make sure only one wire ever exists for a given grid		
		[wires_ setObject:w forKey:p];
		
		// Let neighbors know to update their own sprite orientation with respect to us
		[w updateNeighbors];
		
		// If an adjacent wire has power, then we have power
		// Hence must propagate power
		if ([self isAdjacentPowered:w]) {
			[self powerAdjcent:w];
		}
		return w;
	}
	return nil;
}

- (void) removeWireAtGrid:(Pair *)p
{
	Wire *wire = [wires_ objectForKey:p];
	if (wire) {
		[wires_ removeObjectForKey:p];
		
		// Update the neighbors' orientation to reflect this wire being gone
		[wire updateNeighbors];
		
		[wire removeFromParentAndCleanup:YES];
	}
}

- (BOOL) wireAtGrid:(Pair *)p
{
	if ([wires_ objectForKey:p] == nil) {
		return NO;
	}
	return YES;
}

- (void) updateWireAtGrid:(Pair *)p
{
	Wire *w = [wires_ objectForKey:p];
	if (w != nil) {
		[w updateWireOrientation];
	}
}

- (BOOL) isAdjacentPowered:(Wire *)wire
{
	Wire *w;
	
	Pair *top = [wire.gridPos topPair];
	w = [wires_ objectForKey:top];
	if (w && w.hasPower) {
		return YES;
	}
	
	Pair *bottom = [wire.gridPos bottomPair];	
	w = [wires_ objectForKey:bottom];
	if (w && w.hasPower) {
		return YES;
	}
	
	Pair *left = [wire.gridPos leftPair];		
	w = [wires_ objectForKey:left];
	if (w && w.hasPower) {
		return YES;
	}
	
	Pair *right = [wire.gridPos rightPair];			
	w = [wires_ objectForKey:right];
	if (w && w.hasPower) {
		return YES;
	}	
	
	return NO;
}

- (void) powerAdjcent:(Wire *)wire
{
	Pair *c;
	Wire *w;
	NSArray *sons;
	NSMutableArray *open = [NSMutableArray arrayWithCapacity:4];
	
	[open addObject:wire.gridPos];
	
	// Uses a BFS to propagate power to all connected wires
	while (YES) {
		
		// Check if open list is empty, in which case we stop
		if ([open count] == 0) {
			break;
		}
		
		// Remove the first object from the open list and use this as our current node
		c = [open objectAtIndex:0];
		[open removeObjectAtIndex:0];
		
		// Power this wire
		w = [wires_ objectForKey:c];
		[w powerOn];
		
		// Get all unpowered neighbor nodes and add to the end of the open list
		sons = [self getUnpoweredNeighbors:c];
		[open addObjectsFromArray:sons];
	}
}

- (NSArray *) getUnpoweredNeighbors:(Pair *)p
{
	NSMutableArray *n = [NSMutableArray arrayWithCapacity:4];
	Wire *w;
	
	Pair *top = [p topPair];
	w = [wires_ objectForKey:top];
	if (w && !w.hasPower) {
		[n addObject:top];
	}
	
	Pair *bottom = [p bottomPair];	
	w = [wires_ objectForKey:bottom];
	if (w && !w.hasPower) {
		[n addObject:bottom];
	}
	
	Pair *left = [p leftPair];		
	w = [wires_ objectForKey:left];
	if (w && !w.hasPower) {
		[n addObject:left];
	}
	
	Pair *right = [p rightPair];			
	w = [wires_ objectForKey:right];
	if (w && !w.hasPower) {
		[n addObject:right];
	}		
	
	return n;
}

- (BOOL) pathToPower:(Pair *)p
{
	// Uses a DFS to determine if there exists a path from the given node to a power source
	while (YES) {
	}
}

- (BOOL) isGridPowered:(Pair *)p
{
	Wire *w = [wires_ objectForKey:p];
	
	if (w) {
		return w.hasPower;
	}
	return NO;
}

- (void) dealloc
{
	[wires_ release];
	
	[super dealloc];
}

@end
