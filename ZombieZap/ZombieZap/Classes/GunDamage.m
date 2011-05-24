//
//  GunDamage.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "GunDamage.h"
#import "UtilFuncs.h"

@implementation GunDamage

+ (id) gunDamageFrom:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration
{
	return [[[self alloc] initGunDamageFrom:from to:to duration:duration] autorelease];
}

- (id) initGunDamageFrom:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration
{
	if ((self = [super init])) {
		
        sprite_ = [[CCSprite spriteWithFile:@"muzzle_flash_1.png"] retain];
		[self addChild:sprite_];
        
		CGFloat theta = [UtilFuncs getAngleFrom:from to:to];
		theta = -CC_RADIANS_TO_DEGREES(theta);
		
        self.position = from;
		self.rotation = theta;
        self.scale = 0.6f;
        
        CCFiniteTimeAction *delay = [CCDelayTime actionWithDuration:duration];
        CCFiniteTimeAction *done = [CCCallFunc actionWithTarget:self selector:@selector(finish)];        
		
		[self runAction:[CCSequence actions:delay, done, nil]];	        
        
    }
    return self;
}

- (void) dealloc
{
	[sprite_ release];    
    
    [super dealloc];
}

@end
