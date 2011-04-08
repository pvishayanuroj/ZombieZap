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
		
		sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Zombie Walking 05.png"] retain];
		[self addChild:sprite_];		
		
		unitID_ = countID++;
		
		[self initActions];
		
		[self schedule:@selector(update:) interval:1.0/60.0];			
		
		isLinedUp_ = NO;
		isFiring_ = NO;

		target_ = nil;
		attackTimer_ = 0;
		
		// Tower attributes
		range_ = 64;
		rotationSpeed_ = 20.0f;
		attackSpeed_ = 30;
		damage_ = 2.0f;
		HP_ = 5.0f;
		
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

// Returns values between -pi/2 and 3*pi/2
- (CGFloat) getAngleFrom:(CGPoint)a to:(CGPoint)b
{
	// Interesting note, floats can divide by zero
	CGFloat tempX = b.x - a.x;
	CGFloat tempY = b.y - a.y;
	
	CGFloat radians = atan(tempY/tempX);
	
	if (b.x < a.x)
		radians	+= M_PI;
	
	return radians;
}

- (void) update:(ccTime)dt
{
	[self targettingRoutine];
	[self trackingRoutine];
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
		//NSLog(@"%@ releasing %@", self, target_);
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
		//NSLog(@"%@ is retaining %@", self, target_);
	}
}

- (void) trackingRoutine
{
	// Make sure we have a target and that we aren't already shooting 
	// (while shooting is instantaneous, we want the turret to stay locked on while the damage animation plays)
	if (target_ && !isFiring_) {
		CGFloat theta = [self getAngleFrom:self.position to:target_.position];
		theta = CC_RADIANS_TO_DEGREES(theta);

		// Convert from one system to another - at this point, theta is between -pi and +pi
		theta = 90 - theta;
		
		// Determine which way we need to turn
		CGFloat delta = theta - self.rotation;
		CGFloat absDelta = delta; 
		
		// Figure out the absolute distance we need to rotate to get to the desired state
		// Three cases to consider: Crossing the -180/+180 boundary CCW, crossing it CW, and the non-boundary case
		if (self.rotation < -90 && theta > 90) { // Case 1: CCW over boundary
			absDelta = (360 - theta) + self.rotation;
		}
		else if (self.rotation > 90 && theta < -90) { // Case 2: CW over boundary
			absDelta = (360 + theta) - self.rotation;
		}
		
		// If the needed rotation is close enough, then just set to the desired angle		
		if (fabs(absDelta) < rotationSpeed_) {
			self.rotation = theta;
			isLinedUp_ = YES;
			return;
		}
		
		isLinedUp_ = NO;		
		
		// From -360 to +360, the direction to spin is expressed as CW, CCW, CW, CCW (in equal intervals of 180)
		if (delta < -180 || (delta > 0 && delta < 180)) { 
			// Rotate CW
			self.rotation += rotationSpeed_;
			if (self.rotation > 180) {
				self.rotation -= 360.0f;
			}
		}
		else {
			// Rotate CCW
			self.rotation -= rotationSpeed_;
			if (self.rotation < -180) {
				self.rotation += 360.0f;
			}
		}
		//NSLog(@"myrot: %3.0f\n", self.rotation);
	}
}

- (void) attackingRoutine
{
	if (attackTimer_ > 0) {
		attackTimer_--;
	}
	
	// Only attack if we have a target that's lined up, we aren't dead, and our attack timer has expired
	if (target_ && isLinedUp_ && !isDead_) {
		if (attackTimer_ == 0) {
			[self showAttacking];
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

// Override the description method to give us something more useful than a pointer address
- (NSString *) description
{
	return [NSString stringWithFormat:@"Turret %d", unitID_];
}

- (void) dealloc
{
	NSLog(@"%@ dealloc'd", self);	
	
	[sprite_ release];
	[gridPos_ release];
	
	[attackingAnimation_ release];
	[dyingAnimation_ release];
	
	[super dealloc];
}

@end
