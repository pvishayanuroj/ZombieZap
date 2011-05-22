//
//  RedLaserDamage.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/21/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Damage.h"


@interface RedLaserDamage : Damage {
    
}

+ (id) redLaserDamageFrom:(CGPoint)from to:(CGPoint)to;

- (id) initRedLaserDamageFrom:(CGPoint)from to:(CGPoint)to;

@end
