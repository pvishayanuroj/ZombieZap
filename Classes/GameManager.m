//
//  GameManager.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/5/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "GameManager.h"
#import "GameLayer.h"
#import "FogLayer.h"
#import "Zombie.h"
#import "Turret.h"
#import "Light.h"
#import "Spotlight.h"

// For singleton
static GameManager *_gameManager = nil;

@implementation GameManager

@synthesize gameLayer = gameLayer_;
@synthesize zombies = zombies_;
@synthesize spotlights = spotlights_;
@synthesize towerLocations = towerLocations_;

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
		spotlights_ = [[NSMutableSet setWithCapacity:24] retain];
		towerLocations_ = [[NSMutableSet setWithCapacity:24] retain];		
	}
	return self;
}

- (void) registerGameLayer:(GameLayer *)gameLayer
{
	gameLayer_ = gameLayer;
	[gameLayer_ retain];
}

- (void) registerFogLayer:(FogLayer *)fogLayer
{
	fogLayer_ = fogLayer;
	[fogLayer_ retain];
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
	
	[gameLayer_ addChild:turret];
}

- (Spotlight *) addLightWithPos:(Pair *)pos radius:(CGFloat)radius
{
	NSAssert(fogLayer_ != nil, @"Trying to add a Spotlight without a registered Fog Layer");	
	
	Light *light = [Light lightWithPos:pos];
	[gameLayer_ addChild:light];
	[towerLocations_ addObject:pos];
	
	CGPoint spotlightPos = CGPointMake(light.position.x, 1023 - light.position.y);
	Spotlight *spotlight = [fogLayer_ drawSpotlight:spotlightPos radius:radius];
	[spotlights_ addObject:spotlight];
	
	return spotlight;
}

- (Spotlight *) addLightWithPos:(Pair *)pos
{
	NSAssert(fogLayer_ != nil, @"Trying to add a Spotlight without a registered Fog Layer");	
	
	Light *light = [Light lightWithPos:pos];
	[gameLayer_ addChild:light];
	[towerLocations_ addObject:pos];	
	
	CGPoint spotlightPos = CGPointMake(light.position.x, 1023 - light.position.y);
	Spotlight *spotlight = [fogLayer_ drawSpotlight:spotlightPos];
	[spotlights_ addObject:spotlight];
	
	return spotlight;
}

- (void) removeSpotlight:(Spotlight *)spotlight
{
	// Make sure this happens first, since we assume the removal of the light in fogLayer's removeSpotlight() function
	[spotlights_ removeObject:spotlight];
	[fogLayer_ removeSpotlight:spotlight];
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
	[towerLocations_ addObject:pos];	
}

- (CGPoint) getLayerOffset
{
	return gameLayer_.position;
}

- (void) dealloc
{
	[zombies_ release];
	[spotlights_ release];
	[towerLocations_ release];
	[gameLayer_ release];
	[fogLayer_ release];
	
	[super dealloc];
}

@end
