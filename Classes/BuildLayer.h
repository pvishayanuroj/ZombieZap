//
//  BuildLayer.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 1/23/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class Pair;
@class PButton;

@interface BuildLayer : CCLayer {

	NSUInteger rows;
	
	NSUInteger columns;
	
	NSUInteger buttonSize;
		
	NSMutableArray *buttons;
	
	CGPoint offset;
	
	NSMutableArray *greenGrid_;
	NSMutableArray *redGrid_;	
	
}

- (void) addButton:(PButton *)button;

- (BOOL) buildGridAtPos:(CGPoint)pos;

- (void) buildGridOff;

@end
