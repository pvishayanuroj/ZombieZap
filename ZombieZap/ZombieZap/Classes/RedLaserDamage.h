//
//  RedLaserDamage.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/21/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Damage.h"

@class Turret;
@class Zombie;

@interface RedLaserDamage : Damage {
 
    Turret *turret_;
    
    Zombie *target_;
    
    CGFloat rangeSquared_;
    
    NSUInteger timer_;
    
    NSUInteger maxTime_;
    
}

+ (id) redLaserDamageFrom:(Turret *)turret to:(Zombie *)target range:(CGFloat)rangeSquared maxTime:(NSUInteger)maxTime;

- (id) initRedLaserDamageFrom:(Turret *)turret to:(Zombie *)target range:(CGFloat)rangeSquared maxTime:(NSUInteger)maxTime;

- (void) positionBeam;

@end
