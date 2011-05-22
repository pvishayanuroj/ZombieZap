//
//  RedLaserDamage.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/21/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "RedLaserDamage.h"
#import "Turret.h"
#import "Zombie.h"
#import "UtilFuncs.h"

@implementation RedLaserDamage

+ (id) redLaserDamageFrom:(Turret *)turret to:(Zombie *)target range:(CGFloat)rangeSquared maxTime:(NSUInteger)maxTime
{
    return [[[self alloc] initRedLaserDamageFrom:turret to:target range:rangeSquared maxTime:maxTime] autorelease];
}

- (id) initRedLaserDamageFrom:(Turret *)turret to:(Zombie *)target range:(CGFloat)rangeSquared maxTime:(NSUInteger)maxTime
{
	if ((self = [super init])) {
		
        turret_ = [turret retain];
        target_ = [target retain];
        
		sprite_ = [[CCSprite spriteWithFile:@"red_laser.png"] retain];
		[self addChild:sprite_];
        
        self.scaleY = 1.5f;
        
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
