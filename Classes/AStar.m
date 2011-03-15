//
//  AStar.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 2/27/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "AStar.h"
#import "ASNode.h"
#import "AStarHeap.h"
#import "Grid.h"

@implementation AStar

+ (id) aStar
{
	return [[[self alloc] init] autorelease];
}

- (id) init
{
	if ((self = [super init])) {
		
		open = [[AStarHeap AStarHeapWithCapacity:24] retain];
		membership = [[NSMutableDictionary dictionaryWithCapacity:24] retain];
		closed = [[NSMutableArray arrayWithCapacity:24] retain];
		
	}
	return self;
}

- (NSArray *) findPathFrom:(Pair *)start to:(Pair *)dest
{	
	ASNodeGroup category;
	ASNode *n;
	NSArray *successors;
	
	// Add the initial node to the open list
	n = [ASNode ASNodeWithPair:start];
	[self addToOpen:n];
	
	// Main loop
	while (YES) {
		
		// Stop if open list is empty
		if ([open isEmpty]) {
			break;
		}
		
		// Pop the lowest F cost node off the open list
		n = [open removeFirst];
		
		// Add it to the closed list
		[self addToClosed:n];
		
		// If the goal has been found
		if ([n coordinatesEqual:dest]) {
			break;
		}
			
		// Get successors
		successors = [self generateSuccessors:n];
		
		for (ASNode *son in successors) {
			
			category = [self checkMembership:son];
			
			if (category == ON_NONE) {
				[son setH:[son manhattanDistance:dest]];
				[self addToOpen:son];
			}
			else if (category == ON_OPEN_ADJUST) {
				[self adjustCost:son parent:n];
			}
		}
	}
	
	return [self getPath:n];
}
				
- (NSArray *) generateSuccessors:(ASNode *)n
{
	NSMutableArray *sons = [NSMutableArray arrayWithCapacity:4];
	
	ASNode *up = [ASNode ASNodeWithValues:n.x yVal:n.y-1 g:n.g+1 parent:n];
	if ([[Grid grid] terrainAtGrid:up] != TERR_IMPASS) {
		[sons addObject:up];
	}

	ASNode *down = [ASNode ASNodeWithValues:n.x yVal:n.y+1 g:n.g+1 parent:n];
	if ([[Grid grid] terrainAtGrid:down] != TERR_IMPASS) {
		[sons addObject:down];
	}
	
	ASNode *left = [ASNode ASNodeWithValues:n.x-1 yVal:n.y g:n.g+1 parent:n];
	if ([[Grid grid] terrainAtGrid:left] != TERR_IMPASS) {
		[sons addObject:left];
	}
	
	ASNode *right = [ASNode ASNodeWithValues:n.x+1 yVal:n.y g:n.g+1 parent:n];
	if ([[Grid grid] terrainAtGrid:right] != TERR_IMPASS) {
		[sons addObject:right];
	}	
	
	return sons;
}

- (NSArray *) getPath:(ASNode *)finalNode
{
	NSMutableArray *path = [NSMutableArray arrayWithCapacity:10];
	ASNode *n = finalNode;
	
	// Add to the front of the array
	while (n) {
		[path insertObject:[Pair pairWithPair:n] atIndex:0];
		n = n.parent;
	}
	
	return path;
}

- (ASNodeGroup) checkMembership:(ASNode *)n
{
	Pair *key = [Pair pair:n.x second:n.y];
	
	NSNumber *value = [membership objectForKey:key];
	
	if (value) {
		NSInteger cost = [value intValue];
		if (cost < 0) {
			return ON_CLOSED;
		}
		if (n.g < cost) {
			return ON_OPEN_ADJUST;
		}
		return ON_OPEN_NOADJUST;
	}
	return ON_NONE;
	
}

- (void) addToClosed:(ASNode *)n
{
	[closed addObject:n];
	Pair *key = [Pair pair:n.x second:n.y];
	NSNumber *value = [NSNumber numberWithInt:-n.g];
	// Remove the old open entry, and change the value to negative to indicate that it is closed
	[membership removeObjectForKey:key];
	[membership setObject:value forKey:key];
}

- (void) addToOpen:(ASNode *)n
{
	[open addObject:n];
	//NSLog(@"Adding %@ to open list", n);
	
	// Add entry to membership dictionary
	Pair *key = [Pair pair:n.x second:n.y];
	NSNumber *value = [NSNumber numberWithInt:n.g];
	[membership setObject:value forKey:key];
}

- (void) adjustCost:(ASNode *)n parent:(ASNode *)parent
{
	// Update it on the open list
	[open changeAndResort:n.g x:n.x y:n.y parent:parent];
	
	// Update the membership entry
	Pair *key = [Pair pair:n.x second:n.y];
	NSNumber *value = [NSNumber numberWithInt:n.g];
	// Remove the old one and add the new G cost
	[membership removeObjectForKey:key];
	[membership setObject:value forKey:key];	
}

- (void) dealloc
{	
	[open release];
	[membership release];
	[closed release];
	
	[super dealloc];
}
		
@end
