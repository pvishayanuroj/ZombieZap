//
//  SuperTesla.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "SuperTesla.h"
#import "Pair.h"
#import "GameManager.h"
#import "Zombie.h"
#import "UtilFuncs.h"

@implementation SuperTesla

+ (id) superTeslaWithPos:(Pair *)pos
{
    return [[[self alloc] initSuperTeslaWithPos:pos] autorelease];
}

- (id) initSuperTeslaWithPos:(Pair *)pos
{
    if ((self = [super initTurretWithPos:pos])) {
        
        towerType_ = [[NSString stringWithString:@"Tesla"] retain];        
        
		sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Tesla Turret L3 01.png"] retain];	
		[self addChild:sprite_];		
		
		// Take care of any offset
        damageDrawOffset_ = CGPointMake(0, 24);
		spriteDrawOffset_ = CGPointMake(0, 12);
		sprite_.position = ccpAdd(sprite_.position, spriteDrawOffset_);		        
        
        techLevel_ = 3;        
        maxTargets_ = 3;
        
        targets_ = [[NSMutableArray arrayWithCapacity:maxTargets_] retain];
        
        idleAnimation_ = nil;
        
        [self initActions];
        
        [self showIdle];
    }
    return self;
}

- (void) dealloc
{
	[sprite_ release];    
    [towerType_ release];
    [targets_ release];
    [idleAnimation_ release];
    
    [super dealloc];
}

- (void) initActions
{
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Tesla Turret L3"];
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	idleAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];		
}

- (void) showIdle
{
	[sprite_ stopAllActions];
	[sprite_ runAction:idleAnimation_];	
}

- (void) targettingRoutine
{
	NSSet *zombies = [[GameManager gameManager] zombies];
	CGFloat distance;
    
    for (Zombie *t in targets_) {
        // If turret currently has a target that isn't dead
        if (!t.isDead) {
            distance = [UtilFuncs distanceNoRoot:t.position b:self.position];
            // If target is still within range
            if (distance < rangeSquared_) {
                continue;
            }
        }
        
        // Target is dead or out of range
        [targets_ removeObject:t];
    }
	
    // Find targets to fill the remaining open target slots
    for (int i = [targets_ count]; i < maxTargets_; i++) {

        Zombie *closestZombie = nil;
        CGFloat shortestDistance = rangeSquared_;        
        
        // Look for a new target
        for (Zombie *z in zombies) {
            
            // Zombies that are dying are not taken out of the manager array yet, so we need to double check
            if (!z.isDead) {
                distance = [UtilFuncs distanceNoRoot:z.position b:self.position];
                if (distance < rangeSquared_ && distance < shortestDistance && ![targets_ containsObject:z]) {
                    shortestDistance = distance;
                    closestZombie = z;
                }			
            }
        }
        
        // If we found a target (there may be none in range)
        if (closestZombie) {
            [targets_ addObject:closestZombie];
        }        
        // If we did not find a target on this loop, we will definitely not find anymore, so stop
        else {
            break;
        }
    }
}

- (void) attackingRoutine
{
	if (attackTimer_ > 0) {
		attackTimer_--;
	}
	
	// Only attack if we have targets, we have power, we aren't dead, and our attack timer has expired
	if ([targets_ count] > 0 && hasPower_ && !isDead_) {
		if (attackTimer_ == 0) {
            
            // Attack all targets
            for (Zombie *t in targets_) {
                [[GameManager gameManager] addLightningDamageFromPos:ccpAdd(self.position, damageDrawOffset_) to:t.position];
                [t takeDamage:damage_ damageType:D_TESLA];
            }
            
            // Reset
			attackTimer_ = attackSpeed_;
		}
	}
}


@end
