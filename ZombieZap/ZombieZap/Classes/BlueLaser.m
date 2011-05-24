//
//  BlueLaser.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "BlueLaser.h"
#import "GameManager.h"
#import "Zombie.h"
#import "Enums.h"

@implementation BlueLaser

+ (id) blueLaserWithPos:(Pair *)pos
{
    return [[[self alloc] initBlueLaserWithPos:pos] autorelease];
}

- (id) initBlueLaserWithPos:(Pair *)pos
{
    if ((self = [super initTrackingTurretWithPos:pos filename:@"Laser Turret L3"])) {
        
        towerType_ = [[NSString stringWithString:@"Laser"] retain];
        
		sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Laser Turret L3 01.png"] retain];	
		[self addChild:sprite_];		
		
		// Take care of any offset
		spriteDrawOffset_ = CGPointMake(0, 12);
		sprite_.position = ccpAdd(sprite_.position, spriteDrawOffset_);		        
        
        techLevel_ = 3;        
    }
    return self;
}

- (void) dealloc
{
	[sprite_ release];    
    [towerType_ release];
    
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
            [[GameManager gameManager] addLaserBeamDamageFromPos:self to:target_ range:rangeSquared_ maxTime:attackSpeed_*0.75 totalDamage:damage_ color:L_BLUE];
			attackTimer_ = attackSpeed_;
		}
	}
}

@end
