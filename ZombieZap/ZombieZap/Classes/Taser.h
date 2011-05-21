//
//  Taser.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Turret.h"


@interface Taser : Turret {

	/** Stored idle animation (this is RepeatForever action) */
	CCAction *idleAnimation_;    
    
}

+ (id) taserWithPos:(Pair *)pos;

- (id) initTaserWithPos:(Pair *)pos;

- (void) initActions;

- (void) showIdle;

@end
