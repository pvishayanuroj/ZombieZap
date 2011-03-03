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

- (id) initZombieWithPos:(Pair *)startPos
{
	if ((self = [super init])) {
		
		sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Zombie Attacking 05.png"] retain];
		[self addChild:sprite_];		
		
		Grid *grid = [Grid grid];
		CGPoint startCoord = [grid mapCoordinateAtGridCoordinate:startPos];
		self.position = startCoord;


	
		currentDest_ = [startPos retain];
		[self reachedNext];		
		
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

- (void) test
{
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Zombie Attacking"];
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	//CCActionInterval *animate = [CCAnimate actionWithDuration:1 animation:animation restoreOriginalFrame:YES];
	[sprite_ runAction:[CCRepeatForever actionWithAction:animate]];	
	//[sprite_ runAction: [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
}

- (void) reachedNext
{
	// Determine the next place tile to move to
	Pair *next = [[[Grid grid] objectiveMap] objectForKey:currentDest_];
	
	if (!next) {
		next = [Pair pair];
	}
	
	[currentDest_ release];
	
	[self moveTo:next];
	
}

- (void) moveTo:(Pair *)dest
{
	CGPoint pos = [[Grid grid] mapCoordinateAtGridCoordinate:dest];	
	CCFiniteTimeAction *move = [CCMoveTo actionWithDuration:1 position:pos];
	CCFiniteTimeAction *done = [CCCallFunc actionWithTarget:self selector:@selector(reachedNext)];
	currentDest_ = [dest retain];	
	
	[self runAction:[CCSequence actions:move, done, nil]];
}

- (void) dealloc 
{
	[sprite_ release];
	[objective_ release];
	[super dealloc];
}
			 
@end
