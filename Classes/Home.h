//
//  Home.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class Pair;

@interface Home : CCNode {

	CCSprite *sprite_;
	
}

+ (id) homeWithPos:(Pair *)pos;

- (id) initHomeWithPos:(Pair *)pos;

@end
