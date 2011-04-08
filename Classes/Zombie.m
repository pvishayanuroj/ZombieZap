//
//  Zombie.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 2/13/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Zombie.h"
#import "Tower.h"
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

+ (id) zombieWithPos:(Pair *)startPos obj:(Pair *)obj
{
	return [[[self alloc] initZombieWithPos:startPos obj:obj] autorelease];
}			 

- (id) initZombieWithPos:(Pair *)startPos
{
	if ((self = [super init])) {
		
		sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Zombie Walking 01.png"] retain];
		[self addChild:sprite_];		
		
		Grid *grid = [Grid grid];
		CGPoint startCoord = [grid gridToPixel:startPos];
		self.position = startCoord;
		
		unitID_ = countID++;
		
		// Zombie attributes
		moveRate_ = 20.0f;
		HP_ = 10.0f;
		attackSpeed_ = 30;
		range_ = 15;
		damage_ = 1;
		
		rangeSquared_ = range_ * range_;
		adjMoveTime_ = grid.gridSize/moveRate_;
		attackTimer_ = 0;		
		isWalking_ = YES;		
		isAttacking_ = NO;
		isTakingDamage_ = NO;		
		isDead_ = NO;
		
		[self initActions];
		
		currentDest_ = [startPos retain];
		targetCell_ = [[Pair pair:-1 second:-1] retain];
		[self reachedNext];		
		
		[self showWalking];
		
		[self schedule:@selector(update:) interval:1.0/60.0];					
	}
	return self;
}

- (id) initZombieWithPos:(Pair *)startPos obj:(Pair *)obj
{
	if ((self = [self initZombieWithPos:startPos])) {
		objective_ = [[Pair pairWithPair:obj] retain];
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

- (void) update:(ccTime)dt
{
	[self targettingRoutine];
	[self attackingRoutine];
}

- (void) showWalking
{
	[sprite_ stopAllActions];
	[sprite_ runAction:walkingAnimation_];	
}

- (void) showAttacking
{
	[sprite_ stopAllActions];	
	
	isAttacking_ = YES;
	TargetedAction *animation = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)attackingAnimation_];
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(doneAttacking)];	
	[self runAction:[CCSequence actions:animation, method, nil]];	
}

- (void) reachedNext
{
	// Check if the goal was reached
	if ([currentDest_ isEqual:objective_]) {
		[self stopAllActions];
		[self zombieDeath];
	}
	else {
		// Determine the next place tile to move to
		Pair *next = [[[Grid grid] objectiveMap] objectForKey:currentDest_];
		
		if (!next) {
			next = [Pair pair];
		}
		
		[currentDest_ release];
		currentDest_ = nil;
		
		[self moveTo:next];	
	}
}

- (void) moveTo:(Pair *)dest
{
	CGPoint pos = [[Grid grid] gridToPixel:dest];	

	[self turnTowards:pos];
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

- (CGFloat) distanceNoRoot:(CGPoint)a b:(CGPoint)b
{
	CGFloat t1 = a.x - b.x;
	CGFloat t2 = a.y - b.y;
	return t1*t1 + t2*t2;
}

- (void) turnTowards:(CGPoint)pos
{
	CGPoint res = ccpSub(pos, self.position);
	
	if (res.x > 0) { // Turn right
		sprite_.rotation = 90;
	}
	else if (res.x < 0) { // Turn left
		sprite_.rotation = -90;
	}
	else if (res.y > 0) { // Turn up
		sprite_.rotation = 0;
	}
	else { // Turn down
		sprite_.rotation = 180;
	}
}

- (void) targettingRoutine
{
	// Only check for a new target if we move to a new cell
	if (![targetCell_ isEqual:currentDest_]) {
		// Update the stored location
		[targetCell_ release];
		targetCell_ = [currentDest_ retain];
		
		// See if there's a tower where we're moving to
		NSDictionary *towerLocations = [[GameManager gameManager] towerLocations];
		Tower *t = [towerLocations objectForKey:targetCell_];
		// Some towers are not attackable, like static lights
		if (t) {
			storedTarget_ = t;
			[storedTarget_ retain];
		}		
	}

	if (storedTarget_) {
		// If tower has been destroyed before we get a chance to attack, just clear 
		if (storedTarget_.isDead) {
			[storedTarget_ release];
			storedTarget_ = nil;
		}
		// If there's a tower, see if it's in range. If it's in range, set target
		CGFloat dist = [self distanceNoRoot:self.position b:storedTarget_.position];		
		if (dist < rangeSquared_) {
			target_ = storedTarget_;
			[storedTarget_ release];
			storedTarget_ = nil;
			[target_ retain];
		}		
	}
	
	if (target_ && target_.isDead) {
		[target_ release];
		target_ = nil;
		[self resumeWalking];		
	}
	
	if (!target_ && !isAttacking_ && !isWalking_ && !isTakingDamage_) {
		[self resumeWalking];
	}
}

- (void) attackingRoutine
{
	if (attackTimer_ > 0) {
		attackTimer_--;
	}
	
	// Only attack if we have a target, we aren't dead, and our attack timer has expired
	if (target_ && !isDead_) {
		if (attackTimer_ == 0 && !isTakingDamage_) {
			[self stopAllActions];			
			[self showAttacking];
			[target_ takeDamage:damage_];
			attackTimer_ = attackSpeed_;
		}		
	}
}

- (void) doneAttacking
{
	isAttacking_ = NO;
}

- (void) resumeWalking
{
	NSAssert(currentDest_ != nil, @"Current destination should never be null");
	
	// This check ensures that resume walking is not called more than once on this zombie, otherwise its moves will be messed up
	if (isWalking_) {
		return;
	}
	isWalking_ = YES;
	isTakingDamage_ = NO;
	
	[self showWalking];
	
	CGPoint pos = [[Grid grid] gridToPixel:currentDest_];	
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
		isTakingDamage_ = YES;
		animation = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)takingDmgAnimation_];
		method = [CCCallFunc actionWithTarget:self selector:@selector(resumeWalking)];	
	}
	
	[self runAction:[CCSequence actions:animation, method, nil]];	
}

- (void) stopAllActions
{
	isWalking_ = NO;
	
	[super stopAllActions];
}

- (void) zombieDeath
{		
	// Remove ourself from the list
	[[GameManager gameManager] removeZombie:self];
	
	// Remove ourself from the game layer
	[self removeFromParentAndCleanup:YES];
}

// Override the description method to give us something more useful than a pointer address
- (NSString *) description
{
	return [NSString stringWithFormat:@"Zombie %d", unitID_];
}

- (void) dealloc 
{
	//NSLog(@"%@ dealloc'd", self);
	
	[sprite_ release];
	[objective_ release];
	
	[walkingAnimation_ release];
	[attackingAnimation_ release];
	[dyingAnimation_ release];
	[takingDmgAnimation_ release];
	
	[targetCell_ release];
	[currentDest_ release];	
	
	[super dealloc];
}
			 
@end
