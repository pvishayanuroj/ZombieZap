//
//  AStarHeap.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 2/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "BinaryHeap.h"

@class ASNode;

@interface AStarHeap : BinaryHeap {
	
}

+ (id) AStarHeapWithCapacity:(NSUInteger)numItems;

- (id) initAStarHeap:(NSUInteger)numItems;

- (void) addObject:(ASNode *)node;

- (BOOL) checkAndSwap:(NSUInteger)parentIndex child:(NSUInteger)childIndex;

- (ASNode *) removeFirst;

- (NSInteger) checkChildrenAndSwap:(NSUInteger)parentIndex child1:(NSUInteger)child1 child2:(NSUInteger)child2;

- (void) changeAndResort:(NSInteger)newG x:(NSInteger)x y:(NSInteger)y parent:(ASNode *)parent;

@end
