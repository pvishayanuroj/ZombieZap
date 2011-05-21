//
//  Gatling.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Gatling.h"


@implementation Gatling

+ (id) gatlingWithPos:(Pair *)pos
{
    return [[[self alloc] initGatlingWithPos:pos] autorelease];
}

- (id) initGatlingWithPos:(Pair *)pos
{
    if ((self = [super initTrackingTurretWithPos:pos filename:@"Gun Turret L2"])) {
        
		sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Gun Turret L2 01.png"] retain];	
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

@end
