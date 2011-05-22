//
//  UtilFuncs.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "UtilFuncs.h"


@implementation UtilFuncs

// Returns values between -pi/2 and 3*pi/2
+ (CGFloat) getAngleFrom:(CGPoint)a to:(CGPoint)b
{
	// Interesting note, floats can divide by zero
	CGFloat tempX = b.x - a.x;
	CGFloat tempY = b.y - a.y;
	
	CGFloat radians = atan(tempY/tempX);
	
	if (b.x < a.x)
		radians	+= M_PI;
	
	return radians;
}

+ (CGFloat) euclideanDistance:(CGPoint)a b:(CGPoint)b
{
	CGFloat t1 = a.x - b.x;
	CGFloat t2 = a.y - b.y;
	return sqrt(t1*t1 + t2*t2);
}

+ (CGFloat) distanceNoRoot:(CGPoint)a b:(CGPoint)b
{
	CGFloat t1 = a.x - b.x;
	CGFloat t2 = a.y - b.y;
	return t1*t1 + t2*t2;
}

@end
