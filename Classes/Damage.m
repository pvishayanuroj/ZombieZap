//
//  Damage.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/16/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Damage.h"
#import "TargetedAction.h"

@implementation Damage

+ (id) damageFrom:(CGPoint)from to:(CGPoint)to
{
	return [[[self alloc] initDamageFrom:from to:to] autorelease];
}

- (id) initDamageFrom:(CGPoint)from to:(CGPoint)to
{
	if ((self = [super init])) {
		
		sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Lightning B1 01.png"] retain];
		[self addChild:sprite_];		
		
		CGFloat theta = [self getAngleFrom:from to:to];
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

- (void) dealloc
{
	[sprite_ release];
	
	[super dealloc];
}

@end
