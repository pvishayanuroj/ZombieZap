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
#import "UtilFuncs.h"

@implementation Turret

static NSUInteger countID = 0;

+ (id) turretWithPos:(Pair *)startPos
{
	return [[[self alloc] initTurretWithPos:startPos] autorelease];
}

- (id) initTurretWithPos:(Pair *)startPos
{
	if ((self = [super initTowerWithPos:startPos])) {
		
		unitID_ = countID++;
		
		// Tower attributes
		range_ = 64;
		attackSpeed_ = 30;
		damage_ = 2.0f;
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

- (void) update:(ccTime)dt
{
	[self targettingRoutine];
	[self attackingRoutine];
}

- (void) targettingRoutine
{
	NSSet *zombies = [[GameManager gameManager] zombies];
	CGFloat distance;

    // If turret currently has a target that isn't dead
	if (target_) {
		if (!target_.isDead) {
			distance = [UtilFuncs distanceNoRoot:target_.position b:self.position];
            // If target is still within range
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
	
    // Look for a new target
	for (Zombie *z in zombies) {

		// Zombies that are dying are not taken out of the manager array yet, so we need to double check
		if (!z.isDead) {
			distance = [UtilFuncs distanceNoRoot:z.position b:self.position];
			if (distance < rangeSquared_ && distance < shortestDistance) {
				shortestDistance = distance;
				closestZombie = z;
			}			
		}
	}
		
    // If we found a target (there may be none in range)
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
	
	// Only attack if we have a target, we have power, we aren't dead, and our attack timer has expired
	if (target_ && hasPower_ && !isDead_) {
		if (attackTimer_ == 0) {
			[[GameManager gameManager] addLightningDamageFromPos:self.position to:target_.position];
			[target_ takeDamage:damage_ damageType:D_TESLA];
			attackTimer_ = attackSpeed_;
		}
	}
}

- (void) towerDeath
{			
	// Remove ourself from the list
	[[GameManager gameManager] removeTurret:self];
	
	[super towerDeath];
}

- (void) powerOn
{
	hasPower_ = YES;
}

- (void) powerOff
{
	hasPower_ = NO;
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{	
	if (![self containsTouchLocation:touch])
		return NO;
	
	//NSLog(@"Turret %@ got a touch", self);
	return YES;
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	if ([self containsTouchLocation:touch])	{
		if (!isToggled_) {
			[[GameManager gameManager] toggleUnitOn:gridPos_ withRange:YES withUpgrade:YES withDelegate:self];	
			isToggled_ = YES;
		}
		else {
			[[GameManager gameManager] toggleUnitOff];				
			isToggled_ = NO;
		}
	}
}

// Override the description method to give us something more useful than a pointer address
- (NSString *) description
{
	return [NSString stringWithFormat:@"Turret %d", unitID_];
}

- (void) dealloc
{
	NSLog(@"%@ dealloc'd", self);	
	
	[attackingAnimation_ release];
	[dyingAnimation_ release];
	
	[target_ release];
	
	[super dealloc];
}

@end
