//
//  BuildLayer.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 1/23/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"
#import "Enums.h"

@class Pair;
@class PButton;

@interface BuildLayer : CCLayer <CCTargetedTouchDelegate> {

	NSUInteger rows;
	
	NSUInteger columns;
	
	NSUInteger buttonSize;
		
	NSMutableArray *buttons;
	
	CGPoint offset;
	
	NSMutableArray *greenGrid_;
	
	NSMutableArray *redGrid_;	
	
	BOOL wirePlacement_;
	
	Pair *wireStart_;
	
	Pair *wireEnd_;
	
	DirectionType dirPreference_;
	
	PButton *toggledButton_;
	
}

- (void) addButton:(PButton *)button;

- (BOOL) buildGridAtPos:(CGPoint)pos;

- (void) buildGridOff;

- (NSArray *) buildGridFrom:(Pair *)from to:(Pair *)to passable:(BOOL *)passable;

- (NSMutableArray *) getStraightPathFrom:(Pair *)from to:(Pair *)to passable:(BOOL *)passable;

- (void) toggleWirePlacement:(PButton *)b;

@end
