//
//  Zombie.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 2/13/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class Pair;
@class Turret;

@interface Zombie : CCNode {

	/** Sprite representing the zombie */
	CCSprite *sprite_;

	/** Where the zombie will move to (not currently used) */
	Pair *objective_;

	/** The tile that the zombie is currently walking to */
	Pair *currentDest_;

	/** Stored walking animation (this is RepeatForever action) */
	CCAction *walkingAnimation_;

	/** Stored attacking animation */
	CCAction *attackingAnimation_;

	/** Stored animation of the zombie taking damage */
	CCAction *takingDmgAnimation_;

	/** Stored death animation */
	CCAction *dyingAnimation_;

	Turret *target_;
	
	Turret *storedTarget_;
	
	Pair *targetCell_;
	
	NSUInteger range_;
	
	CGFloat rangeSquared_;
	
	CGFloat damage_;
	
	NSUInteger attackTimer_;
	
	NSUInteger attackSpeed_;	
	
	/** How fast the zombie moves */
	CGFloat moveRate_;

	/** How long it takes the zombie to move one tile at its current move rate */
	CGFloat adjMoveTime_;

	BOOL isAttacking_;
	
	BOOL isWalking_;
	
	/** If the zombie is dead (philosophically speaking this should always be true) */
	BOOL isDead_;
	
	/** Zombie's health points */	
	CGFloat HP_;
	
	/** Zombie's ID number */		
	NSUInteger unitID_;
}

@property(nonatomic, readonly) BOOL isDead;

+ (id) zombieWithPos:(Pair *)startPos;

+ (id) zombieWithPos:(Pair *)startPos obj:(Pair *)obj;

- (id) initZombieWithPos:(Pair *)startPos;

- (id) initZombieWithPos:(Pair *)startPos obj:(Pair *)obj;

- (void) initActions;

- (void) showWalking;

- (void) showAttacking;

- (void) reachedNext;

- (CGFloat) euclideanDistance:(CGPoint)a b:(CGPoint)b;

- (void) moveTo:(Pair *)dest;

- (void) turnTowards:(CGPoint)pos;

- (void) resumeWalking;

- (void) targettingRoutine;

- (void) attackingRoutine;

- (void) doneAttacking;

- (void) takeDamage:(CGFloat)damage;

- (void) stopAllActions;

- (void) zombieDeath;

@end
