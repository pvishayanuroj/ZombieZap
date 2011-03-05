//
//  Turret.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/3/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Turret.h"
#import "Zombie.h"
#import "Grid.h"
#import "GameManager.h"

@implementation Turret

+ (id) turretWithPos:(Pair *)startPos
{
	return [[[self alloc] initTurretWithPos:startPos] autorelease];
}

- (id) initTurretWithPos:(Pair *)startPos
{
	if ((self = [super init])) {
		
		sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Zombie Walking 05.png"] retain];
		[self addChild:sprite_];		
		
		Grid *grid = [Grid grid];
		CGPoint startCoord = [grid mapCoordinateAtGridCoordinate:startPos];
		self.position = startCoord;
		
		[self initActions];
		
		[self schedule:@selector(update:) interval:1.0/60.0];			
		
		target_ = nil;
		range_ = 128;
		attackTimer_ = 0;
		attackSpeed_ = 60;
		rangeSquared_ = range_*range_;
		
	}
	return self;
}

- (void) initActions
{
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Zombie Attacking"];
	attackingAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];
	
	animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Zombie Death"];
	dyingAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];
}

- (void) showAttacking
{
	[sprite_ stopAllActions];	
	[sprite_ runAction:attackingAnimation_];
}

- (void) showDying
{
	[sprite_ stopAllActions];
	[sprite_ runAction:dyingAnimation_];	
}

- (CGFloat) distanceNoRoot:(CGPoint)a b:(CGPoint)b
{
	CGFloat t1 = a.x - b.x;
	CGFloat t2 = a.y - b.y;
	return t1*t1 + t2*t2;
}

- (void) update:(ccTime)dt
{
	[self targettingRoutine];
	[self attackingRoutine];
}

- (void) targettingRoutine
{
	NSSet *zombies = [[GameManager gameManager] zombies];
	CGFloat distance;

	if (target_) {
		if (!target_.isDead) {
			distance = [self distanceNoRoot:target_.position b:self.position];
			if (distance < rangeSquared_) {
				return;
			}
		}
		// Target is dead or out of range
		[target_ release];
		target_ = nil;		
	}
	
	Zombie *closestZombie = nil;
	CGFloat shortestDistance = rangeSquared_;
	
	for (Zombie *z in zombies) {

		distance = [self distanceNoRoot:z.position b:self.position];
		//NSLog(@"(%2.0f, %2.0f) to (%2.0f, %2.0f) - - Rdist: %6.2f\n", z.position.x, z.position.y, self.position.x, self.position.y, sqrt(distance));		
		if (distance < rangeSquared_ && distance < shortestDistance) {
			shortestDistance = distance;
			closestZombie = z;
		}			
	}
		
	if (closestZombie) {
		target_ = closestZombie;
		[target_ retain];
	}
}

- (void) attackingRoutine
{
	if (attackTimer_ > 0) {
		attackTimer_--;
	}
	
	if (target_) {
		if (attackTimer_ == 0) {
			[self showAttacking];
			attackTimer_ = attackSpeed_;
		}
	}
}

- (void) dealloc
{
	[sprite_ release];
	
	[attackingAnimation_ release];
	[dyingAnimation_ release];
	
	[super dealloc];
}

@end
