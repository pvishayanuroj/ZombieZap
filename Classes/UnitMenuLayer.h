//
//  UnitMenuLayer.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 4/20/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class UnitMenu;
@class Pair;

@interface UnitMenuLayer : CCLayer {

	CCSprite *rangeSprite_;
	
	UnitMenu *unitMenu_;
	
	BOOL unitClicked_;	
	
}

- (void) rangeOn:(Pair *)pos;

- (void) rangeOff;

- (void) toggleUnit:(Pair *)pos withRange:(BOOL)range;

@end
