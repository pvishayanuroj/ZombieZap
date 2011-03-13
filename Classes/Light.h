//
//  Light.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class Pair;

@interface Light : CCNode {

	CCSprite *sprite_;	

	NSUInteger unitID_;	
	
}

+ (id) lightWithPos:(Pair *)startPos;

- (id) initLightWithPos:(Pair *)startPos;

@end
