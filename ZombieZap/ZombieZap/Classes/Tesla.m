//
//  Tesla.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Tesla.h"
#import "Pair.h"

@implementation Tesla

+ (id) teslaWithPos:(Pair *)pos
{
    return [[[self alloc] initTeslaWithPos:pos] autorelease];
}

- (id) initTeslaWithPos:(Pair *)pos
{
    if ((self = [super initTurretWithPos:pos])) {
        
		sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Tesla Turret L2 01.png"] retain];	
		[self addChild:sprite_];		
		
		// Take care of any offset
		spriteDrawOffset_ = CGPointMake(0, 12);
		sprite_.position = ccpAdd(sprite_.position, spriteDrawOffset_);		        
        
        idleAnimation_ = nil;
        
        [self initActions];
        
        [self showIdle];
    }
    return self;
}

- (void) dealloc
{
	[sprite_ release];    
    [idleAnimation_ release];
    
    [super dealloc];
}

- (void) initActions
{
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Tesla Turret L2"];
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	idleAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];		
}

- (void) showIdle
{
	[sprite_ stopAllActions];
	[sprite_ runAction:idleAnimation_];	
}

@end
