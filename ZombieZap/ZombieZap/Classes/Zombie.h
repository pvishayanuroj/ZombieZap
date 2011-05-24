//
//  Zombie.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 2/13/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class Pair;
@class Tower;
@class ZombieEyes;

@interface Zombie : CCNode {

	/** Sprite representing the zombie */
	CCSprite *sprite_;

    /** Sprite showing how much HP the zombie has left (green part) */
    CCSprite *hpBar_;
    
    /** Sprite for the background of the HP bar (red part) */
    CCSprite *hpBarBack_;

    /** The fixed drawing offset for the HP bars relative to the zombie sprite */
    CGPoint hpDrawOffset_;
    
    /** Object representing the glowing eyes of the zombie */
	ZombieEyes *eyes_;
	
	/** Where the zombie will move to (not currently used) */
	Pair *objective_;

	/** The tile that the zombie is currently walking to */
	Pair *currentDest_;
    
    /** The tile that the zombie was previously on */
    Pair *prevDest_;

	/** Stored walking animation (this is RepeatForever action) */
	CCAction *walkingAnimation_;

	/** Stored attacking animation */
	CCAction *attackingAnimation_;

	/** Stored animation of the zombie taking damage */
	CCAction *takingDmgAnimation_;

	/** Stored death animation */
	CCAction *dyingAnimation_;

	Tower *target_;
	
	Tower *storedTarget_;
	
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

	BOOL isTakingDamage_;
	
	BOOL isAttacking_;
	
	BOOL isWalking_;
	
	/** If the zombie is dead (philosophically speaking this should always be true) */
	BOOL isDead_;
	
	/** Zombie's health points */	
	CGFloat HP_;

	/** Zombie's starting health points */	
	CGFloat maxHP_;	
    
	/** Zombie's ID number */		
	NSUInteger unitID_;
}

@property (nonatomic, readonly) ZombieEyes *eyes;
@property (nonatomic, readonly) BOOL isDead;

+ (id) zombieWithPos:(Pair *)startPos;

+ (id) zombieWithPos:(Pair *)startPos obj:(Pair *)obj;

- (id) initZombieWithPos:(Pair *)startPos;

- (id) initZombieWithPos:(Pair *)startPos obj:(Pair *)obj;

- (void) initActions;

- (void) showWalking;

- (void) showAttacking;

- (void) reachedNext;

- (void) moveTo:(Pair *)dest;

- (void) turnTowards:(CGPoint)pos;

- (void) resumeWalking;

- (void) targettingRoutine;

- (void) attackingRoutine;

- (void) doneAttacking;

- (void) takeDamage:(CGFloat)damage damageType:(DamageType)type;

- (void) takeDamageNoAnimation:(CGFloat)damage damageType:(DamageType)type;

- (void) takeDamage:(CGFloat)damage damageType:(DamageType)type animated:(BOOL)animated;

- (void) stopAllActions;

- (void) zombieDeath;

@end
