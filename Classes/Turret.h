//
//  Turret.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/3/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Tower.h"
#import "WireDelegate.h"
#import "UnitMenuLayerDelegate.h"

@class Pair;
@class Zombie;

@interface Turret : Tower <WireDelegate, UnitMenuLayerDelegate> {
	
	/**  */	
	CCAction *attackingAnimation_;
	
	/**  */	
	CCAction *dyingAnimation_;
	
	/** Turret's attack range */	
	NSUInteger range_;
	
	/** Attack range squared, used to simply distance calculation */	
	CGFloat rangeSquared_;
	
	/** Turret's current target */	
	Zombie *target_;
	
	/** Keeps track of when the turret attacks */	
	NSUInteger attackTimer_;
	
	/** How fast the turret attacks (the smaller the faster) */	
	NSUInteger attackSpeed_;
	
	/** True if turret is firing */	
	BOOL isFiring_;
	
	/** How much damage this turret does */	
	CGFloat damage_;
	
}

+ (id) turretWithPos:(Pair *)startPos;

- (id) initTurretWithPos:(Pair *)startPos;

- (void) initActions;

- (void) showAttacking;

- (void) showDying;

- (void) update:(ccTime)dt;

- (void) targettingRoutine;

- (void) attackingRoutine;

- (void) takeDamage:(CGFloat)damage;

- (void) turretDeath;

- (void) powerOn;

- (void) powerOff;

@end
