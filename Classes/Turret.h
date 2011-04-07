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
	
	Pair *gridPos_;
	
	CCAction *attackingAnimation_;
	
	CCAction *dyingAnimation_;
	
	NSUInteger range_;
	
	CGFloat rangeSquared_;
	
	CGFloat rotationSpeed_;
	
	Zombie *target_;
	
	NSUInteger attackTimer_;
	
	NSUInteger attackSpeed_;
	
	BOOL isLinedUp_;
	
	BOOL isFiring_;
	
	BOOL isDead_;
	
	CGFloat damage_;
	
	CGFloat HP_;
	
	NSUInteger unitID_;
}

@property (nonatomic, readonly) BOOL isDead;
@property (nonatomic, readonly) Pair *gridPos;

+ (id) turretWithPos:(Pair *)startPos;

- (id) initTurretWithPos:(Pair *)startPos;

- (void) initActions;

- (void) showAttacking;

- (void) showDying;

- (void) targettingRoutine;

- (void) trackingRoutine;

- (void) attackingRoutine;

- (void) takeDamage:(CGFloat)damage;

- (void) turretDeath;

@end
