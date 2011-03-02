//
//  AStar.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 2/27/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Enums.h"

@class Pair;
@class ASNode;
@class AStarHeap;

@interface AStar : NSObject {

	AStarHeap *open;
	NSMutableDictionary *membership;
	NSMutableArray *closed;
	
}

+ (id) aStar;

- (id) init;

- (NSArray *) findPathFrom:(Pair *)start to:(Pair *)dest;

- (NSArray *) generateSuccessors:(ASNode *)node;

- (void) addToClosed:(ASNode *)n;

- (void) addToOpen:(ASNode *)n;

- (void) adjustCost:(ASNode *)n parent:(ASNode *)parent;

- (NSArray *) getPath:(ASNode *)finalNode;

- (ASNodeGroup) checkMembership:(ASNode *)n;

@end
