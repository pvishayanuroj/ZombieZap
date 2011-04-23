//
//  Light.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Light.h"
#import "Spotlight.h"
#import "Pair.h"
#import "Grid.h"
#import "GameManager.h"

@implementation Light

@synthesize spotlight = spotlight_;

static NSUInteger countID = 0;

+ (id) lightWithPos:(Pair *)startPos radius:(CGFloat)radius
{
	return [[[self alloc] initLightWithPos:startPos radius:radius] autorelease];
}

+ (id) lightWithPos:(Pair *)startPos radius:(CGFloat)radius spot:(Spotlight *)spot
{
	return [[[self alloc] initLightWithPos:startPos radius:radius spot:spot] autorelease];
}

- (id) initLightWithPos:(Pair *)startPos radius:(CGFloat)radius
{
	if ((self = [super initTowerWithPos:startPos])) {
		
		sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Zombie Death 01.png"] retain];
		[self addChild:sprite_];				
		
		spotlight_ = nil;
		radius_ = radius;
		
		// Light attributes
		HP_ = 5;
		
		unitID_ = countID++;		
	}
	return self;	
}

- (id) initLightWithPos:(Pair *)startPos radius:(CGFloat)radius spot:(Spotlight *)spot
{
	if ((self = [self initLightWithPos:startPos radius:radius])) {
		
		spotlight_ = spot;
		[spotlight_ retain];
		
	}
	return self;
}

- (void) takeDamage:(CGFloat)damage
{
	NSAssert(HP_ >= 0, @"Light is dead, should not be taking damage");
	
	CCFiniteTimeAction *method;
	CCFiniteTimeAction *delay;
	
	// Subtract health points
	HP_ -= damage;
	
	// Light dies from hit
	if (HP_ <= 0) {
		
		// Make sure the menu is closed
		if (isToggled_) {
			[[GameManager gameManager] toggleUnitOff];				
			isToggled_ = NO;
		}		
		
		// Set ourselves to dead
		isDead_ = YES;
		
		sprite_.visible = NO;
		
		// Remove the spotlight and the wire
		if (spotlight_) {
			[[GameManager gameManager] removeSpotlight:spotlight_];		
		}
		[[GameManager gameManager] removeWireWithPos:gridPos_];		
		
		// Call death function only after a delay
		delay = [CCDelayTime actionWithDuration:1.0f];
		method = [CCCallFunc actionWithTarget:self selector:@selector(lightDeath)];
		[self runAction:[CCSequence actions:delay, method, nil]];			
	}
	// Light just takes damage
	else {
		
	}
}

- (void) sell
{
	// Set ourselves to dead
	HP_ = 0;
	isDead_ = YES;
	
	sprite_.visible = NO;
	[[GameManager gameManager] removeWireWithPos:gridPos_];
	
	// Call death function only after a delay
	CCFiniteTimeAction *delay = [CCDelayTime actionWithDuration:1.0f];
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(lightDeath)];
	[self runAction:[CCSequence actions:delay, method, nil]];				
}

- (void) lightDeath
{		
	// Remove ourself from the list
	[[GameManager gameManager] removeLight:self];
	
	// Remove ourself from the game layer
	[self removeFromParentAndCleanup:YES];
}

- (void) powerOn
{
	NSAssert(spotlight_ == nil, ([NSString stringWithFormat:@"Trying to add a spotlight on top of another spotlight for %@", self]));
	
	CGPoint spotlightPos = [[Grid grid] gridToPixel:gridPos_];
	spotlightPos = CGPointMake(spotlightPos.x, 1023 - spotlightPos.y);	
	spotlight_ = [[GameManager gameManager] addSpotlight:spotlightPos radius:radius_];
	[spotlight_ retain];
}

- (void) powerOff
{
	NSAssert(spotlight_ != nil, ([NSString stringWithFormat:@"Trying to remove a spotlight on top of another spotlight for %@", self]));	
	
	[[GameManager gameManager] removeSpotlight:spotlight_];
	[spotlight_ release];
	spotlight_ = nil;
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if (![self containsTouchLocation:touch])
		return NO;
	
	return YES;
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	if ([self containsTouchLocation:touch])	{
		if (!isToggled_) {
			[[GameManager gameManager] toggleUnitOn:gridPos_ withRange:NO withDelegate:self];	
			isToggled_ = YES;
		}
		else {
			[[GameManager gameManager] toggleUnitOff];				
			isToggled_ = NO;
		}
	}	
}

// Override the description method to give us something more useful than a pointer address
- (NSString *) description
{
	return [NSString stringWithFormat:@"Light %d", unitID_];
}

- (void) dealloc
{
	NSLog(@"%@ dealloc'd", self);	
	
	[sprite_ release];
	[gridPos_ release];
	[spotlight_ release];
	
	[super dealloc];
}

@end
