//
//  Gatling.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Gatling.h"
#import "GameManager.h"
#import "Zombie.h"

@implementation Gatling

+ (id) gatlingWithPos:(Pair *)pos
{
    return [[[self alloc] initGatlingWithPos:pos] autorelease];
}

- (id) initGatlingWithPos:(Pair *)pos
{
    if ((self = [super initTrackingTurretWithPos:pos filename:@"Gun Turret L2"])) {
        
        towerType_ = [[NSString stringWithString:@"Gun"] retain];        
        
		sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Gun Turret L2 01.png"] retain];	
		[self addChild:sprite_];		
		
		// Take care of any offset
		spriteDrawOffset_ = CGPointMake(0, 12);
		sprite_.position = ccpAdd(sprite_.position, spriteDrawOffset_);		        
        
        techLevel_ = 2;        
        
        numSubAttacks_ = 7;
        subAttackSpeed_ = 6;
        subAttackTimer_ = 0;
        subAttackNum_ = 0;
        
        tickDamage_ = damage_/numSubAttacks_;
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
    if (subAttackTimer_ > 0) {
        subAttackTimer_--;
    }
	
	// Only attack if we have a target that's lined up, we have power, we aren't dead, and our attack timer has expired
	if (target_ && hasPower_ && isLinedUp_ && !isDead_) {
		if (attackTimer_ == 0) {
            if (subAttackTimer_ == 0) {
                // If there are still subattacks to make
                if (subAttackNum_ < numSubAttacks_) {
                    subAttackNum_++;                    
                    [[GameManager gameManager] addGunDamageFromPos:self.position to:target_.position duration:0.02f];
                    [target_ takeDamageNoAnimation:tickDamage_ damageType:D_GUN];
                    subAttackTimer_ = subAttackSpeed_;
                }
                // Finished with subattacks, reset the main timer and reset subattack variables
                else {
                    attackTimer_ = attackSpeed_;                
                    subAttackTimer_ = 0;
                    subAttackNum_ = 0;
                }                
            }
		}
	}
}


@end
