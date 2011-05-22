//
//  LightningDamage.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/21/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Damage.h"


@interface LightningDamage : Damage {
    
}

+ (id) lightningDamageFrom:(CGPoint)from to:(CGPoint)to;

- (id) initLightningDamageFrom:(CGPoint)from to:(CGPoint)to;

@end
