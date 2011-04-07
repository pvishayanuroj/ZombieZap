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
#import "Wire.h"
#import "Home.h"
#import "Damage.h"
#import "Grid.h"
#import "ElectricGrid.h"
#import "Pair.h"
#import "Enums.h"

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
		//towerLocations_ = [[NSMutableSet setWithCapacity:24] retain];		
		towerLocations_ = [[NSMutableDictionary dictionaryWithCapacity:24] retain];		
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
	[gameLayer_ addChild:light z:kTower];
	//[towerLocations_ addObject:pos];
	[towerLocations_ setObject:light forKey:pos];
	
	CGPoint spotlightPos = CGPointMake(light.position.x, 1023 - light.position.y);
	Spotlight *spotlight = [fogLayer_ drawSpotlight:spotlightPos radius:radius];
	[spotlights_ addObject:spotlight];
	
	// Add a wire associated with this position if there isn't already one
	if (![[ElectricGrid electricGrid] wireAtGrid:pos]) {
		[self addWireWithPos:pos];
	}	
	
	return spotlight;
}

- (Spotlight *) addLightWithPos:(Pair *)pos
{
	NSAssert(fogLayer_ != nil, @"Trying to add a Spotlight without a registered Fog Layer");	
	
	Light *light = [Light lightWithPos:pos];
	[gameLayer_ addChild:light z:kTower];
	//[towerLocations_ addObject:pos];	
	[towerLocations_ setObject:light forKey:pos];	
	
	CGPoint spotlightPos = CGPointMake(light.position.x, 1023 - light.position.y);
	Spotlight *spotlight = [fogLayer_ drawSpotlight:spotlightPos];
	[spotlights_ addObject:spotlight];
	
	// Add a wire associated with this position if there isn't already one
	if (![[ElectricGrid electricGrid] wireAtGrid:pos]) {
		[self addWireWithPos:pos];
	}	
	
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
	[gameLayer_ addChild:zombie z:kZombie];
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
	
	//[towerLocations_ addObject:pos];	
	[towerLocations_ setObject:turret forKey:pos];
	[gameLayer_ addChild:turret z:kTower];
	
	// Add a wire associated with this position if there isn't already one
	if (![[ElectricGrid electricGrid] wireAtGrid:pos]) {
		[self addWireWithPos:pos];
	}
}

- (void) removeTurret:(Turret *)turret
{
	[towerLocations_ removeObjectForKey:turret.gridPos];
}

- (void) addWireWithPos:(Pair *)pos
{
	NSAssert(gameLayer_ != nil, @"Trying to add a Wire without a registered Game Layer");
	
	// Create the wire and add it
	Wire *wire = [Wire wireWithPos:pos];
	[gameLayer_ addChild:wire z:kWire];
}

- (void) addHomeWithPos:(Pair *)pos
{
	NSAssert(gameLayer_ != nil, @"Trying to add a Home without a registered Game Layer");
	
	// Create home base, make sure it stays above the zombies
	Home *home = [Home homeWithPos:pos];
	[gameLayer_ addChild:home z:kHome];
	
	// Simulate the electric nodes from the base
	[self addWireWithPos:[pos topPair]];
	[self addWireWithPos:[pos bottomPair]];	
}

- (void) addDamageFromPos:(CGPoint)from to:(CGPoint)to
{
	NSAssert(gameLayer_ != nil, @"Trying to add a Damage without a registered Game Layer");
	
	Damage *damage = [Damage damageFrom:from to:to];
	[gameLayer_ addChild:damage z:kDamage];
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
