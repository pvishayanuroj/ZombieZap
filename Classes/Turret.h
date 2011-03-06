//
//  Turret.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/3/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class Pair;
@class Zombie;

@interface Turret : CCNode {

	CCSprite *sprite_;
	
	CCAction *attackingAnimation_;
	
	CCAction *dyingAnimation_;
	
	NSUInteger range_;
	
	CGFloat rangeSquared_;
	
	CGFloat rotationSpeed_;
	
	Zombie *target_;
	
	NSUInteger attackTimer_;
	
	NSUInteger attackSpeed_;
	
	BOOL isLinedUp_;
}

+ (id) turretWithPos:(Pair *)startPos;

- (id) initTurretWithPos:(Pair *)startPos;

- (void) initActions;

- (void) showAttacking;

- (void) showDying;

- (void) targettingRoutine;

- (void) trackingRoutine;

- (void) attackingRoutine;

@end
