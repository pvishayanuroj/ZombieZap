//
//  Turret.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/3/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Tower.h"

@class Pair;
@class Zombie;

@interface Turret : Tower {
	
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
	
	CGFloat damage_;
}

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
