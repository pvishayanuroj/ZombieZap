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
#import "Home.h"
#import "Grid.h"

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

- (void) addStaticLightWithPos:(Pair *)pos
{
	NSAssert(fogLayer_ != nil, @"Trying to add a Spotlight without a registered Fog Layer");	
	
	CGPoint startCoord = [[Grid grid] gridToPixel:pos];	
	CGPoint spotlightPos = CGPointMake(startCoord.x, 1023 - startCoord.y);
	[fogLayer_ drawSpotlight:spotlightPos];
}

- (void) removeSpotlight:(Spotlight *)spotlight
{
	// Make sure this happens first, since we assume the removal of the light in fogLayer's removeSpotlight() function
	[spotlights_ removeObject:spotlight];
	[fogLayer_ removeSpotlight:spotlight];
}

- (void) addZombieWithPos:(Pair *)pos obj:(Pair *)obj
{
	NSAssert(gameLayer_ != nil, @"Trying to add a Zombie without a registered Game Layer");
	
	// Create the zombie
	Zombie *zombie = [Zombie zombieWithPos:pos obj:obj];
	
	// Add to the array that keeps track of all zombies, and add to the game layer
	[zombies_ addObject:zombie];
	[gameLayer_ addChild:zombie z:1];
}

- (void) removeZombie:(Zombie *)zombie
{
	[zombies_ removeObject:zombie];
}

- (void) addTurretWithPos:(Pair *)pos
{
	NSAssert(gameLayer_ != nil, @"Trying to add a Turret without a registered Game Layer");
	
	// Create the turret
	Turret *turret = [Turret turretWithPos:pos];
	
	[towerLocations_ addObject:pos];	
	[gameLayer_ addChild:turret];
}

- (void) addHomeWithPos:(Pair *)pos
{
	NSAssert(gameLayer_ != nil, @"Trying to add a Home without a registered Game Layer");
	
	Home *home = [Home homeWithPos:pos];
	[gameLayer_ addChild:home z:10];
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
