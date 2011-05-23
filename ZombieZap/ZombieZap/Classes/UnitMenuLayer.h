//
//  UnitMenuLayer.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 4/20/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"
#import "UnitMenuLayerDelegate.h"

@class UnitMenu;
@class Pair;

@interface UnitMenuLayer : CCLayer {

	id <UnitMenuLayerDelegate> delegate_;
	
	CCSprite *rangeSprite_;
	
	UnitMenu *unitMenu_;

}

@property (nonatomic, assign) id <UnitMenuLayerDelegate> delegate;

- (void) rangeOn:(Pair *)pos;

- (void) rangeOff;

- (void) toggleOn:(Pair *)pos withRange:(BOOL)range withUpgrade:(BOOL)upgrade withDelegate:(id <UnitMenuLayerDelegate>)d;

- (void) toggleOff;

- (void) forceToggleOff;

@end
