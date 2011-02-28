//
//  Zombie.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 2/13/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Zombie.h"
#import "Pair.h"
#import "Grid.h"

@implementation Zombie

+ (id) zombieWithPos:(Pair *)startPos
{
	return [[[self alloc] initZombieWithPos:startPos] autorelease];
}

+ (id) zombieWithObj:(Pair *)objective startPos:(Pair *)startPos
{
	return [[[self alloc] initZombieWithObjective:objective startPos:startPos] autorelease];
}			 
			 
- (id) initZombie
{
	if ((self = [super init])) {
		
		sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Human Marine Standing 01.png"] retain];
		[self addChild:sprite_];
		
	}
	return self;
}

- (id) initZombieWithPos:(Pair *)startPos
{
	if ((self = [self initZombie])) {
		
		Grid *grid = [Grid grid];
		CGPoint startCoord = [grid mapCoordinateAtGridCoordinate:startPos];
		sprite_.position = startCoord;
		
	}
	return self;
}

- (id) initZombieWithObjective:(Pair *)objective startPos:(Pair *)startPos
{
	if ((self = [self initZombieWithPos:startPos])) {
		objective_ = [[Pair pairWithPair:objective] retain];
	}
	return self;
}

- (void) dealloc 
{
	[sprite_ release];
	[objective_ release];
	[super dealloc];
}
			 
@end
