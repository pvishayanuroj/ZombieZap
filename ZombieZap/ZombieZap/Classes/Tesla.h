//
//  Tesla.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Turret.h"


@interface Tesla : Turret {

	/** Stored idle animation (this is RepeatForever action) */
	CCAction *idleAnimation_;        
    
}

+ (id) teslaWithPos:(Pair *)pos;

- (id) initTeslaWithPos:(Pair *)pos;

- (void) initActions;

- (void) showIdle;

@end
