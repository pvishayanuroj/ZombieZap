//
//  Tower.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 4/8/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class Pair;

/** Superclass for all towers */
@interface Tower : CCNode {

	/** Sprite representing the tower */
	CCSprite *sprite_;
	
	/** Where the tower is on the map in grid notation */
	Pair *gridPos_;	

	/** How many health points the tower has */	
	CGFloat HP_;	
	
	/** Whether or not the tower is dead */	
	BOOL isDead_;
	
	/** Tower's ID number */	
	NSUInteger unitID_;	
}

@property (nonatomic, readonly) BOOL isDead;
@property (nonatomic, readonly) Pair *gridPos;

- (id) initTowerWithPos:(Pair *)startPos;

- (void) takeDamage:(CGFloat)damage;

@end
