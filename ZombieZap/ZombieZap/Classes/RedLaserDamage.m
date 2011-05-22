//
//  RedLaserDamage.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/21/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "RedLaserDamage.h"


@implementation RedLaserDamage

+ (id) redLaserDamageFrom:(CGPoint)from to:(CGPoint)to
{
	return [[[self alloc] initRedLaserDamageFrom:from to:to] autorelease];
}

- (id) initRedLaserDamageFrom:(CGPoint)from to:(CGPoint)to
{
	if ((self = [super initDamageFrom:from to:to])) {
		
		sprite_ = [[CCSprite spriteWithFile:@"red_laser.png"] retain];
		[self addChild:sprite_];
        
		CGFloat theta = [self getAngleFrom:from to:to];
		theta = CC_RADIANS_TO_DEGREES(theta);
		theta = 180 - theta;
		
		CGFloat dist = ccpDistance(from, to);
		self.position = ccpMidpoint(from, to);
		self.rotation = theta;
		self.scaleX = dist/sprite_.contentSize.width;        
        
    }
    return self;
}

- (void) dealloc
{
	[sprite_ release];    
    
    [super dealloc];
}

@end
