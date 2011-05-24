//
//  Projectile.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/24/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Projectile.h"
#import "Zombie.h"
#import "UtilFuncs.h"

@implementation Projectile

+ (id) projectileFrom:(CGPoint)from to:(Zombie *)target totalDamage:(CGFloat)damageAmt
{
	return [[[self alloc] initProjectileFrom:from to:target totalDamage:damageAmt] autorelease];
}

- (id) initProjectileFrom:(CGPoint)from to:(Zombie *)target totalDamage:(CGFloat)damageAmt
{
	if ((self = [super init])) {
        
		sprite_ = [[CCSprite spriteWithFile:@"railgun_projectile.png"] retain];
		[self addChild:sprite_];
        
		CGFloat theta = [UtilFuncs getAngleFrom:from to:target.position];
		theta = CC_RADIANS_TO_DEGREES(theta);
		theta = -theta;
        
        self.position = from;        
        self.rotation = theta;
        
        target_ = [target retain];
        damage_ = damageAmt;
        
        CCFiniteTimeAction *move = [CCMoveTo actionWithDuration:0.1f position:target.position];
        CCFiniteTimeAction *done = [CCCallFunc actionWithTarget:self selector:@selector(impact)];	
        
        [self runAction:[CCSequence actions:move, done, nil]];	        
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    [target_ release];
    
    [super dealloc];
}

- (void) impact
{
    if (!target_.isDead) {
        [target_ takeDamageNoAnimation:damage_ damageType:D_GUN];
    }
    [super finish];
}

@end
