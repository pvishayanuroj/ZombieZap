//
//  LaserBeamDamage.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/23/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "LaserBeamDamage.h"
#import "Turret.h"
#import "Zombie.h"
#import "UtilFuncs.h"
#import "Enums.h"

@implementation LaserBeamDamage

+ (id) redLaserBeamDamageFrom:(Turret *)turret to:(Zombie *)target range:(CGFloat)rangeSquared maxTime:(NSUInteger)maxTime totalDamage:(CGFloat)damage
{
    return [[[self alloc] initLaserBeamDamageFrom:turret to:target range:rangeSquared maxTime:maxTime totalDamage:damage filename:@"red_laser.png"] autorelease];
}

+ (id) greenLaserBeamDamageFrom:(Turret *)turret to:(Zombie *)target range:(CGFloat)rangeSquared maxTime:(NSUInteger)maxTime totalDamage:(CGFloat)damage
{
    return [[[self alloc] initLaserBeamDamageFrom:turret to:target range:rangeSquared maxTime:maxTime totalDamage:damage filename:@"green_laser.png"] autorelease];
}

+ (id) blueLaserBeamDamageFrom:(Turret *)turret to:(Zombie *)target range:(CGFloat)rangeSquared maxTime:(NSUInteger)maxTime totalDamage:(CGFloat)damage
{
    return [[[self alloc] initLaserBeamDamageFrom:turret to:target range:rangeSquared maxTime:maxTime totalDamage:damage filename:@"blue_laser.png"] autorelease];
}

- (id) initLaserBeamDamageFrom:(Turret *)turret to:(Zombie *)target range:(CGFloat)rangeSquared maxTime:(NSUInteger)maxTime totalDamage:(CGFloat)damage filename:(NSString *)filename
{
	if ((self = [super init])) {
		
        turret_ = [turret retain];
        target_ = [target retain];
        
		sprite_ = [[CCSprite spriteWithFile:filename] retain];
		[self addChild:sprite_];
        
        self.scaleY = 1.5f;
        
        tickDamage_ = damage/maxTime;
        rangeSquared_ = rangeSquared;
        maxTime_ = maxTime;
        timer_ = 0;
        
        [self positionBeam];        
        
		[self schedule:@selector(update:) interval:1.0/60.0];					        
        
    }
    return self;
}

- (void) dealloc
{
	[sprite_ release];    
    [turret_ release];
    [target_ release];
    
    [super dealloc];
}

- (void) update:(ccTime)dt
{    
    if (turret_.isDead || target_.isDead || ++timer_ > maxTime_) {
        [super finish];
    }
    else {
        // Check target distance
        CGFloat distance = [UtilFuncs distanceNoRoot:target_.position b:turret_.position];
        // If target still in range, stay on target
        if (distance < rangeSquared_) {    
            [target_ takeDamageNoAnimation:tickDamage_ damageType:D_LASER];
            [self positionBeam];
        }
        else {
            [super finish];
        }
    }
}

- (void) positionBeam
{
    CGFloat theta = [UtilFuncs getAngleFrom:turret_.position to:target_.position];
    theta = CC_RADIANS_TO_DEGREES(theta);
    theta = 180 - theta;
    
    CGFloat dist = ccpDistance(turret_.position, target_.position);
    self.position = ccpMidpoint(turret_.position, target_.position);
    self.rotation = theta;
    self.scaleX = dist/sprite_.contentSize.width;         
}

@end
