//
//  BlueLaser.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "BlueLaser.h"


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

@end
