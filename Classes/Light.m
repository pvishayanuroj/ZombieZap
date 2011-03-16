//
//  Light.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Light.h"
#import "Pair.h"
#import "Grid.h"

@implementation Light

static NSUInteger countID = 0;

+ (id) lightWithPos:(Pair *)startPos
{
	return [[[self alloc] initLightWithPos:startPos] autorelease];
}

- (id) initLightWithPos:(Pair *)startPos
{
	if ((self = [super init])) {
		
		sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Zombie Death 01.png"] retain];
		[self addChild:sprite_];				
		
		Grid *grid = [Grid grid];
		CGPoint startCoord = [grid gridToPixel:startPos];
		self.position = startCoord;
		
		unitID_ = countID++;		
		
	}
	return self;
}

// Override the description method to give us something more useful than a pointer address
- (NSString *) description
{
	return [NSString stringWithFormat:@"Light %d", unitID_];
}

- (void) dealloc
{
	[sprite_ release];
	
	[super dealloc];
}

@end
