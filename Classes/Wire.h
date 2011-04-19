//
//  Wire.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"
#import "WireDelegate.h"

@class Pair;

@interface Wire : CCNode {

	id <WireDelegate> delegate_;
	
	CCSprite *sprite_;
	
	NSInteger wireType_;
	
	Pair *gridPos_;
	
	BOOL hasPower_;
	
	Wire *wUp_;
	Wire *wDown_;
	Wire *wLeft_;
	Wire *wRight_;	

}

@property (nonatomic, assign) id <WireDelegate> delegate;
@property (nonatomic, readonly) Pair *gridPos;
@property (nonatomic, readonly) BOOL hasPower;

+ (id) wireWithPos:(Pair *)pos delegate:(id <WireDelegate>)d;

- (id) initWireWithPos:(Pair *)pos delegate:(id <WireDelegate>)d;

- (CCSprite *) updateSpriteOrientation;

- (void) updateWireOrientation;

- (void) updateNeighbors;

- (void) powerOn;

- (void) powerOff;

- (void) propagateOn;

- (void) propagateOff;

@end
