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

+ (id) lightWithPos:(Pair *)startPos spot:(Spotlight *)spot
{
	return [[[self alloc] initLightWithPos:startPos spot:spot] autorelease];
}

- (id) initLightWithPos:(Pair *)startPos spot:(Spotlight *)spot
{
	if ((self = [super initTowerWithPos:startPos])) {
		
		sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Zombie Death 01.png"] retain];
		[self addChild:sprite_];				
		
		spotlight_ = spot;
		[spotlight_ retain];
		
		// Light attributes
		HP_ = 5;
		
		unitID_ = countID++;		
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
		// Set ourselves to dead
		isDead_ = YES;
		
		sprite_.visible = NO;
		
		// Remove ourself from the list
		[[GameManager gameManager] removeSpotlight:self];		
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

- (void) lightDeath
{		
	// Remove ourself from the list
	[[GameManager gameManager] removeLight:self];
	
	// Remove ourself from the game layer
	[self removeFromParentAndCleanup:YES];
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
