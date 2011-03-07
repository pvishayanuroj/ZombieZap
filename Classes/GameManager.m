//
//  GameManager.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/5/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "GameManager.h"
#import "GameLayer.h"
#import "Zombie.h"
#import "Turret.h"

// For singleton
static GameManager *_gameManager = nil;

@implementation GameManager

@synthesize gameLayer = gameLayer_;
@synthesize zombies = zombies_;

+ (GameManager *) gameManager
{
	if (!_gameManager)
		_gameManager = [[self alloc] init];
	
	return _gameManager;
}

+ (id) alloc
{
	NSAssert(_gameManager == nil, @"Attempted to allocate a second instance of a Game Manager singleton.");
	return [super alloc];
}

+ (void) purgeGameManager
{
	[_gameManager release];
	_gameManager = nil;
}

- (id) init
{
	if ((self = [super init]))
	{
		gameLayer_ = nil;
		zombies_ = [[NSMutableSet setWithCapacity:24] retain];
	}
	return self;
}

- (void) registerGameLayer:(GameLayer *)gameLayer
{
	gameLayer_ = gameLayer;
	[gameLayer_ retain];
}

- (void) addZombie:(Zombie *)zombie
{
	NSAssert(gameLayer_ != nil, @"Trying to add a Zombie without a registered Game Layer");
	
	// Add to the array that keeps track of all zombies, and add to the game layer
	[zombies_ addObject:zombie];
	[gameLayer_ addChild:zombie];
}

- (void) addTurret:(Turret *)turret
{
	NSAssert(gameLayer_ != nil, @"Trying to add a Turret without a registered Game Layer");
	
	// Add to the array that keeps track of all zombies, and add to the game layer
	[gameLayer_ addChild:turret];
}

- (void) addZombieWithPos:(Pair *)pos
{
	Zombie *zombie = [Zombie zombieWithPos:pos];
	[self addZombie:zombie];
}

- (void) removeZombie:(Zombie *)zombie
{
	[zombies_ removeObject:zombie];
}

- (void) addTurretWithPos:(Pair *)pos
{
	Turret *turret = [Turret turretWithPos:pos];
	[self addTurret:turret];
}

- (void) dealloc
{
	[zombies_ release];
	[gameLayer_ release];
	
	[super dealloc];
}

@end
