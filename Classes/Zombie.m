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
#import "GameManager.h"
#import "TargetedAction.h"

@implementation Zombie

@synthesize isDead = isDead_;

static NSUInteger countID = 0;

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
		
		unitID_ = countID++;
		
		// Zombie attributes
		moveRate_ = 32.0f;
		HP_ = 10.0f;
		
		adjMoveTime_ = grid.gridSize/moveRate_;
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
	currentDest_ = nil;
	
	[self moveTo:next];	
}

- (void) moveTo:(Pair *)dest
{
	CGPoint pos = [[Grid grid] mapCoordinateAtGridCoordinate:dest];	

	CCFiniteTimeAction *move = [CCMoveTo actionWithDuration:adjMoveTime_ position:pos];
	CCFiniteTimeAction *done = [CCCallFunc actionWithTarget:self selector:@selector(reachedNext)];
	currentDest_ = [dest retain];	
	
	[self runAction:[CCSequence actions:move, done, nil]];
	
}

- (CGFloat) euclideanDistance:(CGPoint)a b:(CGPoint)b
{
	CGFloat t1 = a.x - b.x;
	CGFloat t2 = a.y - b.y;
	return sqrt(t1*t1 + t2*t2);
}

- (void) resumeWalking
{
	NSAssert(currentDest_ != nil, @"Current destination should never be null");
	
	CGPoint pos = [[Grid grid] mapCoordinateAtGridCoordinate:currentDest_];	
	CGFloat dist = [self euclideanDistance:self.position b:pos];
	
	CCFiniteTimeAction *move = [CCMoveTo actionWithDuration:dist/moveRate_ position:pos];
	CCFiniteTimeAction *done = [CCCallFunc actionWithTarget:self selector:@selector(reachedNext)];	
	
	[self runAction:[CCSequence actions:move, done, nil]];	
}

- (void) takeDamage:(CGFloat)damage
{
	NSAssert(HP_ >= 0, @"Zombie is dead, should not be taking damage");

	TargetedAction *animation;
	CCFiniteTimeAction *method;
	
	// Subtract health points
	HP_ -= damage;
	
	// Stop walking
	[self stopAllActions];	
	
	// Zombie dies from hit
	if (HP_ <= 0) {
		// Set ourselves to dead
		isDead_ = YES;
		
		// Show the death animation, then deal with death
		animation = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)dyingAnimation_];
		method = [CCCallFunc actionWithTarget:self selector:@selector(zombieDeath)];
	}
	// Zombie just takes damage
	else {
		// Show the taking damage animation, then resume walking
		animation = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)takingDmgAnimation_];
		method = [CCCallFunc actionWithTarget:self selector:@selector(resumeWalking)];	
	}
	
	[self runAction:[CCSequence actions:animation, method, nil]];	
}

- (void) zombieDeath
{		
	// Remove ourself from the list
	[[GameManager gameManager] removeZombie:self];
	
	// Remove ourself from the game layer
	[self removeFromParentAndCleanup:YES];
	
	NSLog(@"%@ RC: %d\n", self, [self retainCount]);	
}

// Override the description method to give us something more useful than a pointer address
- (NSString *) description
{
	return [NSString stringWithFormat:@"Zombie %d", unitID_];
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
