//
//  BinaryHeap.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 2/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//


@interface BinaryHeap : NSObject {

	NSMutableArray *data_;
	
}

+ (id) bHeapWithCapacity:(NSUInteger)numItems;

- (id) initBHeap:(NSUInteger)numItems;

- (void) addObject:(NSInteger)value;

- (BOOL) checkAndSwap:(NSUInteger)parentIndex child:(NSUInteger) childIndex;

- (BOOL) isEmpty;

- (NSInteger) removeFirst;

- (NSInteger) checkChildrenAndSwap:(NSUInteger)parentIndex child1:(NSUInteger)child1 child2:(NSUInteger)child2;

@end
