//
//  GunDamage.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Damage.h"


@interface GunDamage : Damage {
    
}

+ (id) gunDamageFrom:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration;

- (id) initGunDamageFrom:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration;

@end
