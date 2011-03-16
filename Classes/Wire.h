//
//  Wire.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class Pair;

@interface Wire : CCNode {

	CCSprite *sprite_;
	
	NSInteger wireType_;
	
	Pair *gridPos_;
}

+ (id) wireWithPos:(Pair *)pos;

- (id) initWireWithPos:(Pair *)pos;

- (CCSprite *) updateSpriteOrientation;

- (void) updateWireOrientation;

@end
