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
	
	CCAction *walkingAnimation_;
	
	CCAction *attackingAnimation_;
	
	CCAction *takingDmgAnimation_;
	
	CCAction *dyingAnimation_;
	
	BOOL isDead_;
}

@property(nonatomic, readonly) BOOL isDead;

+ (id) zombieWithPos:(Pair *)startPos;

+ (id) zombieWithObj:(Pair *)objective startPos:(Pair *)startPos;

- (id) initZombieWithPos:(Pair *)startPos;

- (id) initZombieWithObjective:(Pair *)objective startPos:(Pair *)startPos;

- (void) initActions;

- (void) showWalking;

- (void) showAttacking;

- (void) showTakingDamage;

- (void) showDying;

- (void) reachedNext;

- (void) moveTo:(Pair *)dest;

@end
