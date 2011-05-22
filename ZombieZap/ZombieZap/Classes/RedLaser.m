//
//  RedLaser.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "RedLaser.h"
#import "GameManager.h"
#import "Zombie.h"

@implementation RedLaser

+ (id) redLaserWithPos:(Pair *)pos
{
    return [[[self alloc] initRedLaserWithPos:pos] autorelease];
}

- (id) initRedLaserWithPos:(Pair *)pos
{
    if ((self = [super initTrackingTurretWithPos:pos filename:@"Laser Turret L1"])) {
        
		sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Laser Turret L1 01.png"] retain];	
		[self addChild:sprite_];		
		
		// Take care of any offset
		spriteDrawOffset_ = CGPointMake(0, 12);
		sprite_.position = ccpAdd(sprite_.position, spriteDrawOffset_);		        
        
    }
    return self;
}

- (void) dealloc
{
	[sprite_ release];    
    
    [super dealloc];
}


- (void) attackingRoutine
{
	if (attackTimer_ > 0) {
		attackTimer_--;
	}
	
	// Only attack if we have a target that's lined up, we have power, we aren't dead, and our attack timer has expired
	if (target_ && hasPower_ && isLinedUp_ && !isDead_) {
		if (attackTimer_ == 0) {
			[[GameManager gameManager] addRedLaserDamageFromPos:self.position to:target_.position];
			[target_ takeDamage:damage_];
			attackTimer_ = attackSpeed_;
		}
	}
}

@end
