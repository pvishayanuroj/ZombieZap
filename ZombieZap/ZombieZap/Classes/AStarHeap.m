//
//  AStarHeap.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 2/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "AStarHeap.h"
#import "ASNode.h"


@implementation AStarHeap

+ (id) AStarHeapWithCapacity:(NSUInteger)numItems
{
	return [[[self alloc] initAStarHeap:numItems] autorelease];
}

- (id) initAStarHeap:(NSUInteger)numItems
{
	if ((self = [super initBHeap:numItems])) {
		
	}
	return self;
}

- (void) addObject:(ASNode *)node 
{
	// Add the object to end 
	[data_ addObject:node];
	
	int parentIndex;
	int childIndex = [data_ count];

	// As long as this isn't the first element added to the heap
	if (childIndex > 1) {
		
		// Keep checking if we need to swap until either of two conditions:
		// 1. We swapped with the root, 2. Child is greater than or equal to the parent
		do {
			// Calculate the parent index (note that we count from 1, not 0)
			parentIndex = childIndex/2;
			// Check to see if the child should be swapped with the parent
			if (![self checkAndSwap:parentIndex - 1 child:childIndex - 1]) {
				// If we don't need to swap, we are done 
				break;
			}
			// Parent becomes the child on the next iteration
			childIndex = parentIndex;
		}
		while (parentIndex > 1);
	}
}

- (BOOL) checkAndSwap:(NSUInteger)parentIndex child:(NSUInteger)childIndex
{
	// If child is less than the parent, swap them
	if ([[data_ objectAtIndex:childIndex] f] < [[data_ objectAtIndex:parentIndex] f]) {
		[data_ exchangeObjectAtIndex:parentIndex withObjectAtIndex:childIndex];
		return YES;
	}
	return NO;
}

- (void) changeAndResort:(NSInteger)newG x:(NSInteger)x y:(NSInteger)y parent:(ASNode *)parent
{
	int parentIndex;
	int childIndex = 0;	
	ASNode *n;
	
	// Find the correct node to change
	for (int i = 0; i < [data_ count]; i++) {
		n = [data_ objectAtIndex:i];
		if (n.x == x && n.y == y) {
			// Update its G value and recalculate the F score
			[n setG:newG];
			n.parent = parent;
			// Store the index where we found this, convert to one-indexing
			childIndex = i + 1;
			break;
		}
	}
	
	// Failsafe - this means no objects in our heap matched the node coordinates
	if (childIndex == 0) {
		return;
	}	
	
	// As long as this isn't the first element added to the heap
	if (childIndex > 1) {
		
		// Keep checking if we need to swap until either of two conditions:
		// 1. We swapped with the root, 2. Child is greater than or equal to the parent
		do {
			// Calculate the parent index (note that we count from 1, not 0)
			parentIndex = childIndex/2;
			// Check to see if the child should be swapped with the parent
			if (![self checkAndSwap:parentIndex - 1 child:childIndex - 1]) {
				// If we don't need to swap, we are done 
				break;
			}
			// Parent becomes the child on the next iteration
			childIndex = parentIndex;
		}
		while (parentIndex > 1);
	}	
}

- (ASNode *) removeFirst
{	
	// Get the first object and swap the last object in
	ASNode *first = [data_ objectAtIndex:0];
	[data_ replaceObjectAtIndex:0 withObject:[data_ lastObject]];
	[data_ removeLastObject];
	
	// Corner case with 1 element remaining
	if ([data_ count] < 2) {
		return first;
	}
	
	int c1, c2;
	int index = 1;
	
	// Keep checking if the parent needs to swap with the children as long as:
	// 1. Not at the bottom of the tree, 2. Parent is smaller than both the children
	while (YES) {
		
		// Get the indices of the children (note we are counting from 1)		
		c1 = index * 2;
		c2 = c1 + 1;				
		
		// See if we need to swap with any children. Add one to the result to convert from zero-indexing to one-indexing
		index = [self checkChildrenAndSwap:index - 1 child1:c1 - 1 child2:c2 - 1] + 1;
		// If nothing was swapped, stop looping
		if (index == 1) {
			break;
		}
	}
	
	return first;
}

// Compares the parent to children, swaps with the smaller child if the parent is larger than both
// If only larger than one child, swaps with that child
// If swapping occurred, returns the index of the child we swapped with, otherwise returns 0 if no swapping occurred (zero-indexed)
- (NSInteger) checkChildrenAndSwap:(NSUInteger)parentIndex child1:(NSUInteger)child1 child2:(NSUInteger)child2
{	
	// Parent has no children
	if (child1 >= [data_ count]) {
		return 0;
	}
	
	NSUInteger value = [[data_ objectAtIndex:parentIndex] f];	
	NSUInteger c1 = [[data_ objectAtIndex:child1] f];	
	
	// Case where parent only has one child
	if (child2 >= [data_ count]) {
		// Just compare the parent to the child
		if (value > c1) {
			[data_ exchangeObjectAtIndex:parentIndex withObjectAtIndex:child1];
			return child1;
		}
		else {
			return 0;
		}
	}
	
	int c2 = [[data_ objectAtIndex:child2] f];		
	
	// Check the smaller child first
	if (c1 < c2) {
		if (value > c1) {
			[data_ exchangeObjectAtIndex:parentIndex withObjectAtIndex:child1];
			return child1;
		}
		else if (value > c2) {
			[data_ exchangeObjectAtIndex:parentIndex withObjectAtIndex:child2];
			return child2;			
		}
	}
	else {
		if (value > c2) {
			[data_ exchangeObjectAtIndex:parentIndex withObjectAtIndex:child2];
			return child2;						
		}
		else if (value > c1) {
			[data_ exchangeObjectAtIndex:parentIndex withObjectAtIndex:child1];
			return child1;						
		}
	}
	return 0;
}

- (void) dealloc
{	
	[super dealloc];
}

@end
