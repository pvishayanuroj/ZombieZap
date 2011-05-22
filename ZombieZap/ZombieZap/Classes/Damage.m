//
//  Damage.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/16/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Damage.h"

@implementation Damage

+ (id) damageFrom:(CGPoint)from to:(CGPoint)to
{
	return [[[self alloc] initDamageFrom:from to:to] autorelease];
}

- (id) initDamageFrom:(CGPoint)from to:(CGPoint)to
{
	if ((self = [super init])) {
				

        
	}
	return self;
}

- (void) dealloc
{	
	[super dealloc];
}

- (void) finish
{		
	// Remove ourself from the game layer
	[self removeFromParentAndCleanup:YES];
	
	//NSLog(@"%@ RC: %d\n", self, [self retainCount]);	
}

// Returns values between -pi/2 and 3*pi/2
- (CGFloat) getAngleFrom:(CGPoint)a to:(CGPoint)b
{
	// Interesting note, floats can divide by zero
	CGFloat tempX = b.x - a.x;
	CGFloat tempY = b.y - a.y;
	
	CGFloat radians = atan(tempY/tempX);
	
	if (b.x < a.x)
		radians	+= M_PI;
	
	return radians;
}

@end
