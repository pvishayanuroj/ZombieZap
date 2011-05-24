//
//  LaserBeamDamage.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/23/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Damage.h"

@class Turret;
@class Zombie;

@interface LaserBeamDamage : Damage {
    
    Turret *turret_;
    
    Zombie *target_;
    
    CGFloat rangeSquared_;
    
    CGFloat tickDamage_;
    
    NSUInteger timer_;
    
    NSUInteger maxTime_;    
    
}

+ (id) redLaserBeamDamageFrom:(Turret *)turret to:(Zombie *)target range:(CGFloat)rangeSquared maxTime:(NSUInteger)maxTime totalDamage:(CGFloat)damage;

+ (id) greenLaserBeamDamageFrom:(Turret *)turret to:(Zombie *)target range:(CGFloat)rangeSquared maxTime:(NSUInteger)maxTime totalDamage:(CGFloat)damage;

+ (id) blueLaserBeamDamageFrom:(Turret *)turret to:(Zombie *)target range:(CGFloat)rangeSquared maxTime:(NSUInteger)maxTime totalDamage:(CGFloat)damage;

- (id) initLaserBeamDamageFrom:(Turret *)turret to:(Zombie *)target range:(CGFloat)rangeSquared maxTime:(NSUInteger)maxTime totalDamage:(CGFloat)damage filename:(NSString *)filename;

- (void) positionBeam;

@end
