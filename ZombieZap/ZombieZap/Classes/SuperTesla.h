//
//  SuperTesla.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Turret.h"


@interface SuperTesla : Turret {
    
	/** Stored idle animation (this is RepeatForever action) */
	CCAction *idleAnimation_;     
    
    NSMutableArray *targets_;
    
    NSUInteger maxTargets_;
    
}

+ (id) superTeslaWithPos:(Pair *)pos;

- (id) initSuperTeslaWithPos:(Pair *)pos;

- (void) initActions;

- (void) showIdle;

@end
