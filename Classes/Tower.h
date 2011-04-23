//
//  Tower.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 4/8/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"
#import "UnitMenuLayerDelegate.h"

@class Pair;

/** Superclass for all towers */
@interface Tower : CCNode <CCTargetedTouchDelegate, UnitMenuLayerDelegate> {

	/** Sprite representing the tower */
	CCSprite *sprite_;

	/** An offset for when the sprite is drawn, since not all towers' bases are in the absolute center */	
	CGPoint spriteDrawOffset_;
	
	/** Where the tower is on the map in grid notation */
	Pair *gridPos_;	

	/** How many health points the tower has */	
	CGFloat HP_;	
	
	/** Whether or not the tower is dead */	
	BOOL isDead_;

	/** Whether or not the tower has power */	
	BOOL hasPower_;	

	/** Whether or not the tower has its menu up */		
	BOOL isToggled_;
	
	/** Tower's ID number */	
	NSUInteger unitID_;	
}

@property (nonatomic, readonly) BOOL isDead;
@property (nonatomic, readonly) Pair *gridPos;

- (id) initTowerWithPos:(Pair *)startPos;

- (void) takeDamage:(CGFloat)damage;

- (BOOL) containsTouchLocation:(UITouch *)touch;

@end
