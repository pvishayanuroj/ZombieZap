//
//  Generator.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 1/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Generator.h"


@implementation Generator

+ (id) generator
{
	return [[[self alloc] initGenerator] autorelease];		
}

- (id) initGenerator
{
	if ((self = [super init])) {
				
		sprite = [[CCSprite spriteWithFile:@"generator_wheel.png"] retain];
		[self addChild:sprite];
		sprite.position = CGPointZero;
		
		outerRadius = 60;
		innerRadius = 30;
		maxDeltaR = 10;
		sampleSize = 60;
		dirLock = YES;
		touchTimer = -1;
		
		int i;
		for (i = 0; i < sampleSize; i++) {
			storedSpeeds[i] = 0;
		}
		
		counter = 0;
		
		[self schedule:@selector(update:) interval:1.0/60.0];				
	}
	return self;
}

- (void) rotateWheel: (CGFloat)degrees
{
	sprite.rotation += degrees;
}

- (void) update:(ccTime)dt
{
	if (touchTimer != -1) {
		touchTimer++;
	}
	
	// Calculates speed
	CGFloat dR = storedRotation - sprite.rotation;
	storedRotation = sprite.rotation;	
	
	for (int i = 0; i < sampleSize - 1; i++) {
		storedSpeeds[i] = storedSpeeds[i+1];
	}
	storedSpeeds[sampleSize - 1] = dR;
	
	avgSpeed = 0;
	for (int i = 0; i < sampleSize; i++) {
		avgSpeed += storedSpeeds[i];
	}
	avgSpeed /= sampleSize;
	
	counter++;
	if (counter == 5) {
		//NSLog(@"Speed: %4.2f", s);
		//NSLog(@"Speed: %4.2f, p=%4.2f, c=%4.2f", s, t, storedRotation);
		//NSLog(@"avg: %4.2f", avgSpeed);
		counter = 0;
	}

	if (angularMomentum != 0) {
		angularMomentum *= 0.98;
		if (fabs(angularMomentum) < 0.5) {
			angularMomentum = 0;
		}
		else {
			[self rotateWheel:angularMomentum];
		}
	}
}

- (ZGPoint) closestPoint: (CGPoint)p
{
	CGPoint d = CGPointMake(p.x - self.position.x, p.y - self.position.y);
	CGFloat dist = sqrt(d.x * d.x + d.y * d.y);
	CGFloat theta = acos(d.x/dist) * 180 / M_PI;
	ZGPoint r;
	
	if (d.y < 0) {
		theta = 360 - theta;
	}
	
	r.rot = theta;
	r.dist = dist;
	
	//NSLog(@"(%4.2f, %4.2f), r=%4.2f , d=%4.2f", p.x, p.y, r.rot, r.dist);
	
	return r;
}

- (void) onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}

- (void) onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

- (CGRect) rect
{
	CGRect r = sprite.textureRect;

	//NSLog(@"textureRect (%f, %f) - w: %f h: %f", r.origin.x, r.origin.y, r.size.width, r.size.height);

	return CGRectMake(sprite.position.x - r.size.width / 2, sprite.position.y - r.size.height / 2, r.size.width, r.size.height);
}

- (BOOL) containsTouchLocation:(UITouch *)touch
{

	//CGPoint point = [self convertTouchToNodeSpaceAR:touch];
	//NSLog(@"gen Touch location @(%4f, %4f)", point.x, point.y);

	return CGRectContainsPoint([self rect], [self convertTouchToNodeSpaceAR:touch]);
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if (![self containsTouchLocation:touch])
		return NO;

	NSLog(@"gen touch began");
	CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];	
	ZGPoint p = [self closestPoint:touchLocation];
	prevRotation = p.rot;
	
	NSLog(@"Touch @radius: %3.0f", p.dist);
	
	angularMomentum = 0;
	touchTimer = 0;
	startRotation = sprite.rotation;
	
	return YES;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];	
	ZGPoint p = [self closestPoint:touchLocation];
	
	// Radius check
	if (p.dist > innerRadius && p.dist < outerRadius) {

		angularMomentum = 0;
		if (touchTimer == -1) {
			NSLog(@"touch started again");
			touchTimer = 0;
			startRotation = sprite.rotation;
		}
		
		CGFloat dR = p.rot - prevRotation;
		//NSLog(@"dR: %4.2f = %4.2f - %4.2f", dR, p.rot, prevRotation);

		// Check if wheel is only allowed to spin one way
		if ((dR < 0 && dirLock) || !dirLock) {
			// Normal case
			if (fabs(dR) < maxDeltaR || dR + 360 < maxDeltaR) {
				[self rotateWheel:-dR];	
			}
			else {
				if (dR < 0) {
					[self rotateWheel:maxDeltaR];
				}
				else {
					[self rotateWheel:-maxDeltaR];
				}

			}
		}
	}
	else {
		// Player's touch has gone off the wheel
		if (touchTimer != -1) {
			// Calculate angular momentum to keep the wheel spinning
			CGFloat displacement = sprite.rotation - startRotation;
			CGFloat time = touchTimer + 1; // +1 so we don't divide by 0
			angularMomentum = displacement/time;
			touchTimer = -1;		
			
			// Reset the sprite's rotation field - we don't want an overflow
			CGFloat multiple = floor(sprite.rotation / 360);
			if (multiple < 0) {
				multiple++;
			}
			sprite.rotation = sprite.rotation - 360 * multiple;
			
			NSLog(@"off generator");
			//NSLog(@"disp: %4.2f time: %4.2f, a1: %4.2f", displacement, time, angularMomentum);
		}
	}
	
	prevRotation = p.rot;	
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{	
	if (touchTimer != -1) {
		CGFloat displacement = sprite.rotation - startRotation;
		CGFloat time = touchTimer + 1; // +1 so that we don't divide by 0
		angularMomentum = displacement/time;
		touchTimer = -1;
		
		// Reset the sprite's rotation field - we don't want an overflow
		CGFloat multiple = floor(sprite.rotation / 360);
		if (multiple < 0) {
			multiple++;
		}
		sprite.rotation = sprite.rotation - 360 * multiple;		
		//NSLog(@"rotation: %4.2f", sprite.rotation);
		
		NSLog(@"touch ended");
		//NSLog(@"disp: %4.2f time: %4.2f, a1: %4.2f", displacement, time, angularMomentum);

	}
}

- (void) dealloc
{
	[sprite release];
	
	[super dealloc];
}

@end
