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

- (BOOL) addWireAtGrid:(Pair *)p wire:(Wire *)w
{
	if ([wires_ objectForKey:p] == nil) {
		[wires_ setObject:w forKey:p];
		return YES;
	}
	return NO;
}

- (void) removeWireAtGrid:(Pair *)p
{
	Wire *wire = [wires_ objectForKey:p];
	if (wire) {
		[wires_ removeObjectForKey:p];
		
		// Update the neighbors' orientation to reflect this wire being gone
		[wire updateNeighbors:p];
		
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

- (void) dealloc
{
	[wires_ release];
	
	[super dealloc];
}

@end
