//
//  Zombie.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 2/13/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class Pair;

@interface Zombie : CCNode {

	CCSprite *sprite_;
	
	Pair *objective_;
	
	Pair *currentDest_;
	
}

+ (id) zombieWithPos:(Pair *)startPos;

+ (id) zombieWithObj:(Pair *)objective startPos:(Pair *)startPos;

- (id) initZombieWithPos:(Pair *)startPos;

- (id) initZombieWithObjective:(Pair *)objective startPos:(Pair *)startPos;

-(void)test;

@end
