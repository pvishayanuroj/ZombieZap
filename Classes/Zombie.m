//
//  Zombie.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 2/13/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Zombie.h"
#import "Pair.h"
#import "Grid.h"

@implementation Zombie

@synthesize isDead = isDead_;

+ (id) zombieWithPos:(Pair *)startPos
{
	return [[[self alloc] initZombieWithPos:startPos] autorelease];
}

+ (id) zombieWithObj:(Pair *)objective startPos:(Pair *)startPos
{
	return [[[self alloc] initZombieWithObjective:objective startPos:startPos] autorelease];
}			 

- (id) initZombieWithPos:(Pair *)startPos
{
	if ((self = [super init])) {
		
		sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Zombie Walking 01.png"] retain];
		[self addChild:sprite_];		
		
		Grid *grid = [Grid grid];
		CGPoint startCoord = [grid mapCoordinateAtGridCoordinate:startPos];
		self.position = startCoord;
		
		isDead_ = NO;
		
		[self initActions];
		
		currentDest_ = [startPos retain];
		[self reachedNext];		
		
		[self showWalking];
		
	}
	return self;
}

- (id) initZombieWithObjective:(Pair *)objective startPos:(Pair *)startPos
{
	if ((self = [self initZombieWithPos:startPos])) {
		objective_ = [[Pair pairWithPair:objective] retain];
	}
	return self;
}

- (void) initActions
{
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Zombie Walking"];
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	walkingAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];		

	animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Zombie Attacking"];
	attackingAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];
	
	animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Zombie Damaged"];
	takingDmgAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];
	
	animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Zombie Death"];
	dyingAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];
}

- (void) showWalking
{
	[sprite_ stopAllActions];
	[sprite_ runAction:walkingAnimation_];	
}

- (void) showAttacking
{
	[sprite_ stopAllActions];	
	[sprite_ runAction:attackingAnimation_];
}

- (void) showTakingDamage
{
	[sprite_ stopAllActions];	
	[sprite_ runAction:takingDmgAnimation_];
}

- (void) showDying
{
	[sprite_ stopAllActions];	
	[sprite_ runAction:dyingAnimation_];
}

- (void) reachedNext
{
	// Determine the next place tile to move to
	Pair *next = [[[Grid grid] objectiveMap] objectForKey:currentDest_];
	
	if (!next) {
		next = [Pair pair];
	}
	
	[currentDest_ release];
	
	[self moveTo:next];	
}

- (void) moveTo:(Pair *)dest
{
	CGPoint pos = [[Grid grid] mapCoordinateAtGridCoordinate:dest];	
	CCFiniteTimeAction *move = [CCMoveTo actionWithDuration:1 position:pos];
	CCFiniteTimeAction *done = [CCCallFunc actionWithTarget:self selector:@selector(reachedNext)];
	currentDest_ = [dest retain];	
	
	[self runAction:[CCSequence actions:move, done, nil]];
}

- (void) dealloc 
{
	[sprite_ release];
	[objective_ release];
	
	[walkingAnimation_ release];
	[attackingAnimation_ release];
	[dyingAnimation_ release];
	[takingDmgAnimation_ release];
	
	[super dealloc];
}
			 
@end
