//
//  LightningDamage.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/21/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "LightningDamage.h"
#import "TargetedAction.h"
#import "UtilFuncs.h"

@implementation LightningDamage

+ (id) lightningDamageFrom:(CGPoint)from to:(CGPoint)to
{
	return [[[self alloc] initLightningDamageFrom:from to:to] autorelease];
}

- (id) initLightningDamageFrom:(CGPoint)from to:(CGPoint)to
{
	if ((self = [super init])) {
		
		sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Lightning B1 01.png"] retain];
		[self addChild:sprite_];
        
		CGFloat theta = [UtilFuncs getAngleFrom:from to:to];
		theta = CC_RADIANS_TO_DEGREES(theta);
		theta = 90 - theta;
		
		CGFloat dist = ccpDistance(from, to);
		self.position = ccpMidpoint(from, to);
		self.rotation = theta;
		self.scale = dist/sprite_.contentSize.width;        
        
		CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Lightning B1"];		
		CCAction *damageAnimation = [CCAnimate actionWithAnimation:animation];
		
		TargetedAction *damage = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)damageAnimation];
		CCFiniteTimeAction *done = [CCCallFunc actionWithTarget:self selector:@selector(finish)];
		
		[self runAction:[CCSequence actions:damage, done, nil]];	        
        
    }
    return self;
}

- (void) dealloc
{
	[sprite_ release];    
    
    [super dealloc];
}

@end
