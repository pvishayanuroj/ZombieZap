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

@synthesize wires = wires_;

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
		powerNodes_ = [[NSMutableSet setWithCapacity:5] retain];
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
			[w propagateOn];
			//[self propagate:w power:YES];
		}
		return w;
	}
	return nil;
}

- (void) addDelegateToWireAtPos:(Pair *)p delegate:(id <WireDelegate>)delegate
{
	Wire *w = [wires_ objectForKey:p];
	if (w) {
		w.delegate = delegate;
	}
}

- (void) setPowerNode:(Wire *)w
{
	
	// Make sure they have power to propagate when new wires are connected to this
	[w powerOn];
	
	// Store the position of this power node
	[powerNodes_ addObject:w.gridPos];
}

- (void) removeWireAtGrid:(Pair *)p
{
	NSDate *ref = [NSDate date];
	Wire *wire = [wires_ objectForKey:p];
	if (wire) {
		[wires_ removeObjectForKey:p];
		
		// Update the neighbors' orientation to reflect this wire being gone
		[wire updateNeighbors];
		
		[wire removeFromParentAndCleanup:YES];
		
		// Check if each adjacent wire (if any) have a route to a power source
		// Get all neighbors and see if each has a route to power source
		NSArray *neighbors = [self getNeighbors:p];
		//NSLog(@"%@'s neighbors: %@", p, neighbors);
		for (Pair *n in neighbors) {
			// If no route to power, then unpower all nodes connected to this wire
			if (![self pathToPower:n powerNodes:powerNodes_]) {
				//NSLog(@"propagating unpower from %@", n);
				//[self propagate:[wires_ objectForKey:n] power:NO];
				Wire *w = [wires_ objectForKey:n];
				[w propagateOff];
			}
		}		
	}
	
	NSLog(@"Removed wire in %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);
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

- (void) propagate:(Wire *)wire power:(BOOL)power
{
	NSDate *ref = [NSDate date];
	//Pair *c;
	Wire *w;
	NSArray *sons;
	NSMutableArray *open = [NSMutableArray arrayWithCapacity:4];
	
	//[open addObject:wire.gridPos];
	[open addObject:wire];
	
	// Uses a BFS to propagate power to all connected wires
	while (YES) {
		
		// Check if open list is empty, in which case we stop
		if ([open count] == 0) {
			NSLog(@"Propagate in %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);
			break;
		}
		
		// Remove the first object from the open list and use this as our current node
		w = [open lastObject];
		[open removeLastObject];
		//c = [open objectAtIndex:0];
		//[open removeObjectAtIndex:0];
		
		// Power or unpower this wire
		//w = [wires_ objectForKey:c];
		
		if (power) {
			[w powerOn];
		}
		else {
			// Cannot power off power nodes
			if (![powerNodes_ containsObject:w.gridPos]) {
				[w powerOff];
			}
		}
		
		// If propagating power, get all unpowered neighbor nodes
		// If propagating no power, get all powered neighbor nodes
		// Add these to the end of the open list
		//sons = [self getNeighbors:c powered:!power];
		sons = [self getNeighbors:w powered:!power];
		[open addObjectsFromArray:sons];
	}
}

- (NSArray *) getNeighbors:(Wire *)w powered:(BOOL)powered
{
	NSMutableArray *n = [NSMutableArray arrayWithCapacity:4];

	Wire *topWire = [wires_ objectForKey:[w.gridPos topPair]];
	if (topWire && (powered == topWire.hasPower)) {
		[n addObject:topWire];
	}
	
	Wire *bottomWire = [wires_ objectForKey:[w.gridPos bottomPair]];
	if (bottomWire && (powered == bottomWire.hasPower)) {
		[n addObject:bottomWire];
	}
	
	Wire *leftWire = [wires_ objectForKey:[w.gridPos leftPair]];
	if (leftWire && (powered == leftWire.hasPower)) {
		[n addObject:leftWire];
	}
	
	Wire *rightWire = [wires_ objectForKey:[w.gridPos rightPair]];
	if (rightWire && (powered == rightWire.hasPower)) {
		[n addObject:rightWire];
	}		
	
	return n;
}
/*
- (NSArray *) getNeighbors:(Pair *)p powered:(BOOL)powered
{
	NSMutableArray *n = [NSMutableArray arrayWithCapacity:4];
	Wire *w;
	
	Pair *top = [p topPair];
	w = [wires_ objectForKey:top];
	if (w && (powered == w.hasPower)) {
		[n addObject:top];
	}
	
	Pair *bottom = [p bottomPair];
	w = [wires_ objectForKey:bottom];
	if (w && (powered == w.hasPower)) {
		[n addObject:bottom];
	}
	
	Pair *left = [p leftPair];		
	w = [wires_ objectForKey:left];
	if (w && (powered == w.hasPower)) {
		[n addObject:left];
	}
	
	Pair *right = [p rightPair];	
	w = [wires_ objectForKey:right];
	if (w && (powered == w.hasPower)) {
		[n addObject:right];
	}		
	
	return n;
}*/

- (NSArray *) getNeighbors:(Pair *)p notInSet:(NSSet *)set
{
	NSMutableArray *n = [NSMutableArray arrayWithCapacity:4];
	
	Pair *top = [p topPair];
	if ([wires_ objectForKey:top] && ![set containsObject:top]) {
		[n addObject:top];
	}
	Pair *bottom = [p bottomPair];
	if ([wires_ objectForKey:bottom] && ![set containsObject:bottom]) {
		[n addObject:bottom];
	}
	Pair *right = [p rightPair];
	if ([wires_ objectForKey:right] && ![set containsObject:right]) {
		[n addObject:right];
	}
	Pair *left = [p leftPair];
	if ([wires_ objectForKey:left] && ![set containsObject:left]) {
		[n addObject:left];
	}	
	
	return n;
}

- (NSArray *) getNeighbors:(Pair *)p
{
	NSMutableSet *empty = [NSMutableSet set];
	return [self getNeighbors:p notInSet:empty];
}

- (BOOL) pathToPower:(Pair *)p powerNodes:(NSSet *)power
{
	NSDate *ref = [NSDate date];
	Pair *c;
	NSArray *sons;
	NSMutableSet *closed = [NSMutableSet setWithCapacity:24];
	NSMutableArray *open = [NSMutableArray arrayWithCapacity:12];
	
	// Add S0
	[open addObject:p];
	[closed addObject:p];
	
	// Uses a DFS to determine if there exists a path from the given node to a power source
	while (YES) {
		
		// No solution if open is empty
		if ([open count] == 0) {
			NSLog(@"Path to power in %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);			
			return NO;
		}
		
		// Remove the last state off open
		c = [open lastObject];
		[open removeLastObject];
		
		// See if solution has been found
		if ([power containsObject:c]) {
			NSLog(@"Path to power in %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);			
			return YES;
		}
		
		// No solution found yet, generate successors
		sons = [self getNeighbors:c notInSet:closed];
		//NSLog(@"%@'s sons: %@", c, sons);
		[open addObjectsFromArray:sons];
		[closed addObjectsFromArray:sons];
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
	NSLog(@"Wire dealloc'd");
	
	[wires_ release];
	[powerNodes_ release];
	
	[super dealloc];
}

@end
