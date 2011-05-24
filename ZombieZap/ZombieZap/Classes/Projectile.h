//
//  Projectile.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/24/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Damage.h"

@class Zombie;

@interface Projectile : Damage {
 
    Zombie *target_;    
    
    CGFloat damage_;
    
}

+ (id) projectileFrom:(CGPoint)from to:(Zombie *)target totalDamage:(CGFloat)damageAmt;

- (id) initProjectileFrom:(CGPoint)from to:(Zombie *)target totalDamage:(CGFloat)damageAmt;

@end
