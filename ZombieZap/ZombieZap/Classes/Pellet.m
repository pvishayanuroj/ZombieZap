//
//  Pellet.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Pellet.h"
#import "GameManager.h"
#import "Zombie.h"
#import "UtilFuncs.h"

@implementation Pellet

+ (id) pelletWithPos:(Pair *)pos
{
    return [[[self alloc] initPelletWithPos:pos] autorelease];
}

- (id) initPelletWithPos:(Pair *)pos
{
    if ((self = [super initTrackingTurretWithPos:pos filename:@"Gun Turret L1"])) {
        
        towerType_ = [[NSString stringWithString:@"Gun"] retain];        
        
		sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Gun Turret L1 01.png"] retain];	
		[self addChild:sprite_];		
		
		// Take care of any offset
		spriteDrawOffset_ = CGPointMake(0, 12);
		sprite_.position = ccpAdd(sprite_.position, spriteDrawOffset_);		        

        techLevel_ = 1;        
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
            
            /* placement test
            CGFloat degrees;
            NSInteger xOffset, yOffset;
            [self getPlacement:self.position b:target_.position deg:&degrees x:&xOffset y:&yOffset];
            CGPoint offset = CGPointMake(xOffset, yOffset);
            */
            
			[[GameManager gameManager] addGunDamageFromPos:self.position to:target_.position duration:0.03f];
			[target_ takeDamageNoAnimation:damage_ damageType:D_GUN];
			attackTimer_ = attackSpeed_;
		}
	}
}

- (void) getPlacement:(CGPoint)a b:(CGPoint)b deg:(CGFloat *)deg x:(NSInteger *)x y:(NSInteger *)y
{
	// Get the angle between the unit and the enemy
	CGFloat radians = [UtilFuncs getAngleFrom:a to:b];
	
	// Because + rotation goes CW for some reason	
	*deg = -CC_RADIANS_TO_DEGREES(radians);	
	*x = (NSInteger)(25 * cos(radians));
	*y = (NSInteger)(25 * sin(radians));		
}

@end
