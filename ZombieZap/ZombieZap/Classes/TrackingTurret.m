//
//  TrackingTurret.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 4/20/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "TrackingTurret.h"
#import "GameManager.h"
#import "Zombie.h"

@implementation TrackingTurret

+ (id) trackingTurretWithPos:(Pair *)startPos filename:(NSString *)filename
{
	return [[[self alloc] initTrackingTurretWithPos:startPos filename:filename] autorelease];
}

- (id) initTrackingTurretWithPos:(Pair *)startPos filename:(NSString *)filename
{
	if ((self = [super initTurretWithPos:startPos])) {
		
		spriteFacing_ = 2;		
		
		turretRotation_ = self.rotation;
		turretRotation_ = 45;		
		isLinedUp_ = NO;
        spriteFileName_ = [filename retain];
		
		// Tower attributes
		rotationSpeed_ = 20.0f;
		spriteRotationInterval_ = 45;
	}
	return self;
}

- (void) update:(ccTime)dt
{
	[self targettingRoutine];
	[self trackingRoutine];
	[self spriteSelectionRoutine];
	[self attackingRoutine];
}

- (void) trackingRoutine
{
	// Make sure we have a target, we have power, we aren't dead, and that we aren't already shooting 
	// (while shooting is instantaneous, we want the turret to stay locked on while the damage animation plays)
	if (target_ && hasPower_ && !isDead_ && !isFiring_) {
		CGFloat theta = [self getAngleFrom:self.position to:target_.position];
		theta = CC_RADIANS_TO_DEGREES(theta);
		
		// Convert from one system to another - at this point, theta is between -pi and +pi
		theta = 90 - theta;
		
		// Determine which way we need to turn
		CGFloat delta = theta - turretRotation_;
		CGFloat absDelta = delta; 
		
		// Figure out the absolute distance we need to rotate to get to the desired state
		// Three cases to consider: Crossing the -180/+180 boundary CCW, crossing it CW, and the non-boundary case
		if (turretRotation_ < -90 && theta > 90) { // Case 1: CCW over boundary
			absDelta = (360 - theta) + turretRotation_;
		}
		else if (turretRotation_ > 90 && theta < -90) { // Case 2: CW over boundary
			absDelta = (360 + theta) - turretRotation_;
		}
		
		// If the needed rotation is close enough, then just set to the desired angle		
		if (fabs(absDelta) < rotationSpeed_) {
			turretRotation_ = theta;
			isLinedUp_ = YES;
			return;
		}
		
		isLinedUp_ = NO;		
		
		// From -360 to +360, the direction to spin is expressed as CW, CCW, CW, CCW (in equal intervals of 180)
		if (delta < -180 || (delta > 0 && delta < 180)) { 
			// Rotate CW
			turretRotation_ += rotationSpeed_;
			if (turretRotation_ > 180) {
				turretRotation_ -= 360.0f;
			}
		}
		else {
			// Rotate CCW
			turretRotation_ -= rotationSpeed_;
			if (turretRotation_ < -180) {
				turretRotation_ += 360.0f;
			}
		}
		//NSLog(@"myrot: %3.0f\n", turretRotation_);
	}
}

- (void) spriteSelectionRoutine 
{
	NSInteger index = round(turretRotation_ / spriteRotationInterval_);
	
	if (index != spriteFacing_ && !isDead_) {
		
		spriteFacing_ = index;		
		[self removeChild:sprite_ cleanup:YES];
		[sprite_ release];		
		
		NSString *spriteFrameName = [NSString stringWithFormat:@"%@ %02d.png", spriteFileName_, (abs(index) + 1)];
		sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteFrameName] retain];
		sprite_.flipX = (index < 0);
		sprite_.position = ccpAdd(sprite_.position, spriteDrawOffset_);
		
		[self addChild:sprite_];		
	}
}

- (void) attackingRoutine
{
	if (attackTimer_ > 0) {
		attackTimer_--;
	}
	
	// Only attack if we have a target that's lined up, we have power, we aren't dead, and our attack timer has expired
	if (target_ && hasPower_ && isLinedUp_ && !isDead_) {
		if (attackTimer_ == 0) {
			//[self showAttacking];
			[[GameManager gameManager] addDamageFromPos:self.position to:target_.position];
			[target_ takeDamage:damage_];
			attackTimer_ = attackSpeed_;
		}
	}
}

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

- (void) dealloc
{
    [spriteFileName_ release];
    
	[super dealloc];
}

@end
