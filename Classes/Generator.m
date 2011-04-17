//
//  Generator.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 1/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Generator.h"

@implementation Generator

@synthesize currentSpeed = currentSpeed_;

+ (id) generator
{
	return [[[self alloc] initGenerator] autorelease];		
}

- (id) initGenerator
{
	if ((self = [super init])) {
				
		sprite_ = [[CCSprite spriteWithFile:@"generator_wheel.png"] retain];
		[self addChild:sprite_];
		sprite_.position = CGPointZero;
		
		// Generator attributes
		outerRadius_ = 60;
		innerRadius_ = 30;
		maxDeltaR_ = 10;
		
		dirLock_ = YES;
		touchTimer_ = -1;
		currentSpeed_ = 0;
		
		[self schedule:@selector(update:) interval:1.0/60.0];				
	}
	return self;
}

- (void) rotateWheel: (CGFloat)degrees
{
	// Keep track of the current speed
	currentSpeed_ = degrees;
	
	NSLog(@"Speed: %3.3f", currentSpeed_);
	
	if (degrees != 0) {
		sprite_.rotation += degrees;
	}
}

- (void) update:(ccTime)dt
{
	if (touchTimer_ != -1) {
		touchTimer_++;
	}

	// If touch timer is not used, then player is not actively spinning the wheel
	if (touchTimer_ == -1) {
		if (angularMomentum_ != 0) {
			angularMomentum_ *= 0.98;
			if (angularMomentum_ > maxDeltaR_) {
				angularMomentum_ = maxDeltaR_;
			}
			if (angularMomentum_ < 0.5) {
				angularMomentum_ = 0;
			}
		}
		[self rotateWheel:angularMomentum_];
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
	CGRect r = sprite_.textureRect;

	//NSLog(@"textureRect (%f, %f) - w: %f h: %f", r.origin.x, r.origin.y, r.size.width, r.size.height);

	return CGRectMake(sprite_.position.x - r.size.width / 2, sprite_.position.y - r.size.height / 2, r.size.width, r.size.height);
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

	//NSLog(@"gen touch began");
	CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];	
	ZGPoint p = [self closestPoint:touchLocation];
	prevRotation_ = p.rot;
	
	//NSLog(@"Touch @radius: %3.0f", p.dist);
	
	angularMomentum_ = 0;
	touchTimer_ = 0;
	// Store where the wheel was before it started spinning
	startRotation_ = sprite_.rotation;
	
	return YES;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint touchLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]]];	
	ZGPoint p = [self closestPoint:touchLocation];
	
	// If player is still on the wheel
	if (p.dist > innerRadius_ && p.dist < outerRadius_) {

		angularMomentum_ = 0;
		// If player's finger goes back onto the wheel after going off
		if (touchTimer_ == -1) {
			//NSLog(@"touch started again");
			touchTimer_ = 0;
			startRotation_ = sprite_.rotation;
		}
		
		CGFloat dR = p.rot - prevRotation_;
		//NSLog(@"dR: %4.2f = %4.2f - %4.2f", dR, p.rot, prevRotation);

		// Check if wheel is only allowed to spin one way
		if ((dR < 0 && dirLock_) || !dirLock_) {
			// Normal case
			if (fabs(dR) < maxDeltaR_ || dR + 360 < maxDeltaR_) {
				[self rotateWheel:-dR];	
			}
			else {
				if (dR < 0) {
					[self rotateWheel:maxDeltaR_];
				}
				else {
					[self rotateWheel:-maxDeltaR_];
				}

			}
		}
	}
	// Otherwise player's touch is not on the wheel
	else {
		// Only if the last touch was on the wheel
		if (touchTimer_ != -1) {
			// Calculate angular momentum to keep the wheel spinning
			CGFloat displacement = sprite_.rotation - startRotation_;
			CGFloat time = touchTimer_ + 1; // +1 so we don't divide by 0
			angularMomentum_ = displacement/time;
			
			touchTimer_ = -1;		
			
			// Reset the sprite's rotation field - we don't want an overflow
			CGFloat multiple = floor(sprite_.rotation / 360);
			if (multiple < 0) {
				multiple++;
			}
			sprite_.rotation = sprite_.rotation - 360 * multiple;
			
			//NSLog(@"finger off generator");
			//NSLog(@"disp: %4.2f time: %4.2f, a1: %4.2f", displacement, time, angularMomentum);
			//NSLog(@"angular M: %3.2f", angularMomentum);
		}
	}
	
	// Store the frame's current rotation in order to calculate delta R
	prevRotation_ = p.rot;	
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{	
	if (touchTimer_ != -1) {
		CGFloat displacement = sprite_.rotation - startRotation_;
		CGFloat time = touchTimer_ + 1; // +1 so that we don't divide by 0
		angularMomentum_ = displacement/time;
		touchTimer_ = -1;
		
		// Reset the sprite's rotation field - we don't want an overflow
		CGFloat multiple = floor(sprite_.rotation / 360);
		if (multiple < 0) {
			multiple++;
		}
		sprite_.rotation = sprite_.rotation - 360 * multiple;		
		//NSLog(@"rotation: %4.2f", sprite.rotation);
		
		//NSLog(@"touch ended");
		//NSLog(@"disp: %4.2f time: %4.2f, a1: %4.2f", displacement, time, angularMomentum);

	}
}

- (void) dealloc
{
	[sprite_ release];
	
	[super dealloc];
}

@end
