//
//  Pellet.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Pellet.h"


@implementation Pellet

+ (id) pelletWithPos:(Pair *)pos
{
    return [[[self alloc] initPelletWithPos:pos] autorelease];
}

- (id) initPelletWithPos:(Pair *)pos
{
    if ((self = [super initTrackingTurretWithPos:pos filename:@"Gun Turret L1"])) {
        
		sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Gun Turret L1 01.png"] retain];	
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
