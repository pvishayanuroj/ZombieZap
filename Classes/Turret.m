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
#import "TargetedAction.h"

@implementation Turret

static NSUInteger countID = 0;

+ (id) turretWithPos:(Pair *)startPos
{
	return [[[self alloc] initTurretWithPos:startPos] autorelease];
}

- (id) initTurretWithPos:(Pair *)startPos
{
	if ((self = [super initTowerWithPos:startPos])) {
		
		sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Laser Turret L1 02.png"] retain];	
		[self addChild:sprite_];		
		
		// Take care of any offset
		spriteDrawOffset_ = CGPointMake(0, 12);
		sprite_.position = ccpAdd(sprite_.position, spriteDrawOffset_);		
		
		unitID_ = countID++;
		
		// Tower attributes
		range_ = 64;
		attackSpeed_ = 30;
		damage_ = 4.0f;
		HP_ = 5.0f;
		
		// Setup tower variables
		isFiring_ = NO;
		target_ = nil;
		attackTimer_ = 0;		
		rangeSquared_ = range_*range_;

		[self initActions];		
		
		[self schedule:@selector(update:) interval:1.0/60.0];	
		
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
	isFiring_ = YES;
	TargetedAction *animation = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)attackingAnimation_];
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(doneFiring)];	
	[self runAction:[CCSequence actions:animation, method, nil]];
}

- (void) showDying
{
	[sprite_ stopAllActions];
	[sprite_ runAction:dyingAnimation_];	
}

- (void) doneFiring
{
	isFiring_ = NO;
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

		// Zombies that are dying are not taken out of the manager array yet, so we need to double check
		if (!z.isDead) {
			distance = [self distanceNoRoot:z.position b:self.position];
			//NSLog(@"(%2.0f, %2.0f) to (%2.0f, %2.0f) - - Rdist: %6.2f\n", z.position.x, z.position.y, self.position.x, self.position.y, sqrt(distance));		
			if (distance < rangeSquared_ && distance < shortestDistance) {
				shortestDistance = distance;
				closestZombie = z;
			}			
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
	
	// Only attack if we have a target, we aren't dead, and our attack timer has expired
	if (target_ && !isDead_) {
		if (attackTimer_ == 0) {
			//[self showAttacking];
			[[GameManager gameManager] addDamageFromPos:self.position to:target_.position];
			[target_ takeDamage:damage_];
			attackTimer_ = attackSpeed_;
		}
	}
}

- (void) takeDamage:(CGFloat)damage
{
	NSAssert(HP_ >= 0, @"Turret is dead, should not be taking damage");
	
	CCFiniteTimeAction *method;
	CCFiniteTimeAction *delay;
	
	// Subtract health points
	HP_ -= damage;
	
	// Turret dies from hit
	if (HP_ <= 0) {
		// Set ourselves to dead
		isDead_ = YES;
		
		sprite_.visible = NO;
		[[GameManager gameManager] removeWireWithPos:gridPos_];
		
		// Call death function only after a delay
		delay = [CCDelayTime actionWithDuration:1.0f];
		method = [CCCallFunc actionWithTarget:self selector:@selector(turretDeath)];
		[self runAction:[CCSequence actions:delay, method, nil]];			
	}
	// Turret just takes damage
	else {

	}
}

- (void) turretDeath
{		
	// Remove ourself from the list
	[[GameManager gameManager] removeTurret:self];
	
	// Remove ourself from the game layer
	[self removeFromParentAndCleanup:YES];
}

- (void) powerOn
{
	hasPower_ = YES;
}

- (void) powerOff
{
	hasPower_ = NO;
}

// Override the description method to give us something more useful than a pointer address
- (NSString *) description
{
	return [NSString stringWithFormat:@"Turret %d", unitID_];
}

- (void) dealloc
{
	//NSLog(@"%@ dealloc'd", self);	
	
	[sprite_ release];
	[gridPos_ release];
	
	[attackingAnimation_ release];
	[dyingAnimation_ release];
	
	[super dealloc];
}

@end
