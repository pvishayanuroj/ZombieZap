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
		
		isLinedUp_ = NO;
		target_ = nil;
		range_ = 64;
		rangeSquared_ = range_*range_;
		rotationSpeed_ = 8.0f;
		attackTimer_ = 0;
		attackSpeed_ = 60;
		
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

- (void) trackingRoutine
{
	if (target_) {
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
	
	if (target_ && isLinedUp_) {
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
