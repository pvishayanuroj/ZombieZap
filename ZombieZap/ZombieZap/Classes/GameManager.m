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
#import "EyesLayer.h"
#import "Zombie.h"
#import "ZombieEyes.h"
#import "Turret.h"
#import "Light.h"
#import "Spotlight.h"
#import "Wire.h"
#import "Home.h"
#import "Damage.h"
#import "LightningDamage.h"
#import "RedLaserDamage.h"
#import "Grid.h"
#import "ElectricGrid.h"
#import "Pair.h"
#import "Enums.h"
#import "Constants.h"
#import "CCTexture2DMutable.h"
#import "TrackingTurret.h"
#import "UnitMenuLayer.h"
#import "Generator.h"
#import "Taser.h"
#import "Tesla.h"
#import "SuperTesla.h"
#import "Pellet.h"
#import "Gatling.h"
#import "Rail.h"
#import "RedLaser.h"
#import "GreenLaser.h"
#import "BlueLaser.h"

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
		fogLayer_ = nil;
		eyesLayer_ = nil;
		unitMenuLayer_ = nil;
		generator_ = nil;
		zombies_ = [[NSMutableSet setWithCapacity:24] retain];
		spotlights_ = [[NSMutableSet setWithCapacity:24] retain];
		towerLocations_ = [[NSMutableDictionary dictionaryWithCapacity:24] retain];		
	}
	return self;
}

- (void) dealloc
{
	[zombies_ release];
	[spotlights_ release];
	[towerLocations_ release];
	
	[gameLayer_ release];
	[fogLayer_ release];
	[eyesLayer_ release];
	[unitMenuLayer_ release];
	[generator_ release];
	
	[super dealloc];
}

- (void) registerGameLayer:(GameLayer *)gameLayer
{
	NSAssert(gameLayer_ == nil, @"Trying to register a Game Layer when one already exists");
	gameLayer_ = gameLayer;
	[gameLayer_ retain];
}

- (void) registerFogLayer:(FogLayer *)fogLayer
{
	NSAssert(fogLayer_ == nil, @"Trying to register a Fog Layer when one already exists");	
	fogLayer_ = fogLayer;
	[fogLayer_ retain];
}

- (void) registerEyesLayer:(EyesLayer *)eyesLayer
{
	NSAssert(eyesLayer_ == nil, @"Trying to register an Eyes Layer when one already exists");	
	eyesLayer_ = eyesLayer;
	[eyesLayer_ retain];
}

- (void) registerUnitMenuLayer:(UnitMenuLayer *)unitMenuLayer
{
	NSAssert(unitMenuLayer_ == nil, @"Trying to register a Unit Menu Layer when one already exists");	
	unitMenuLayer_ = unitMenuLayer;
	[unitMenuLayer_ retain];
}

- (void) registerGenerator:(Generator *)generator
{
	NSAssert(generator_ == nil, @"Trying to register a Generator when one already exists");		
	generator_ = [generator retain];
}

- (void) updateDependentLayerPositions:(CGPoint)position
{
	fogLayer_.position = position;
	eyesLayer_.position = position;
	unitMenuLayer_.position = position;
}

- (void) addLightWithPos:(Pair *)pos radius:(CGFloat)radius
{
	NSAssert(gameLayer_ != nil, @"Trying to add a Light without a registered Game Layer");	
	
	Light *light = [Light lightWithPos:pos radius:radius];
	[gameLayer_ addChild:light z:kTower];
	[towerLocations_ setObject:light forKey:pos];	
	
	// Add a wire associated with this position if there isn't already one
	if (![[ElectricGrid electricGrid] wireAtGrid:pos]) {
		[self addWireWithPos:pos delegate:light];
	}	
	// Else there's a wire, see if it's powered
	else if ([[ElectricGrid electricGrid] isGridPowered:pos]) {
		[light powerOn];
		[[ElectricGrid electricGrid] addDelegateToWireAtPos:pos delegate:light];
	}
}

- (void) addStaticLightWithPos:(Pair *)pos radius:(CGFloat)radius
{
	NSAssert(fogLayer_ != nil, @"Trying to add a Spotlight without a registered Fog Layer");	
	
	CGPoint startCoord = [[Grid grid] gridToPixel:pos];	
	CGPoint spotlightPos = CGPointMake(startCoord.x, 1023 - startCoord.y);
	Spotlight *spotlight = [fogLayer_ drawSpotlight:spotlightPos radius:radius];
	[spotlights_ addObject:spotlight];
}

- (Spotlight *) addSpotlight:(CGPoint)pos radius:(CGFloat)radius
{
	Spotlight *spotlight = [fogLayer_ drawSpotlight:pos radius:radius];
	[spotlights_ addObject:spotlight];
	
	return spotlight;
}

- (void) removeSpotlight:(Spotlight *)spotlight
{
	// Make sure this happens first, since we assume the removal of the spotlight in fogLayer's removeSpotlight() function
	[spotlights_ removeObject:spotlight];
	[fogLayer_ removeSpotlight:spotlight];
}

- (void) removeLight:(Light *)light
{
	[towerLocations_ removeObjectForKey:light.gridPos];
}

- (void) addZombieWithPos:(Pair *)pos obj:(Pair *)obj
{
	NSAssert(gameLayer_ != nil, @"Trying to add a Zombie without a registered Game Layer");
	NSAssert(eyesLayer_ != nil, @"Trying to add a Zombie without a registered Eyes Layer");	
	
	// Create the zombie
	Zombie *zombie = [Zombie zombieWithPos:pos obj:obj];
	ZombieEyes *eyes = zombie.eyes;
	
	// Add to the array that keeps track of all zombies, and add to the game layer
	[zombies_ addObject:zombie];
	[gameLayer_ addChild:zombie z:kZombie];
	[eyesLayer_ addChild:eyes];
}

- (void) removeZombie:(Zombie *)zombie
{
	[zombies_ removeObject:zombie];
}

- (void) addTeslaWithPos:(Pair *)pos level:(NSUInteger)level
{
    NSAssert(gameLayer_ != nil, @"Trying to add a Tesla Turret without a registered Game Layer");
    
    Turret *turret;
    switch (level) {
        case 1:
            turret = [Taser taserWithPos:pos];
            break;
        case 2:
            turret = [Tesla teslaWithPos:pos];
            break;
        case 3:
            turret = [SuperTesla superTeslaWithPos:pos];
            break;
        default:
            break;
    }
    
    [self addTurret:turret withPos:pos];
}

- (void) addGunWithPos:(Pair *)pos level:(NSUInteger)level
{
    NSAssert(gameLayer_ != nil, @"Trying to add a Gun Turret without a registered Game Layer");
    
    Turret *turret;
    switch (level) {
        case 1:
            turret = [Pellet pelletWithPos:pos];
            break;
        case 2:
            turret = [Gatling gatlingWithPos:pos];
            break;
        case 3:
            turret = [Rail railWithPos:pos];
            break;
        default:
            break;
    }
    
    [self addTurret:turret withPos:pos];
}

- (void) addLaserWithPos:(Pair *)pos level:(NSUInteger)level
{
    NSAssert(gameLayer_ != nil, @"Trying to add a Laser Turret without a registered Game Layer");
    
    Turret *turret;
    switch (level) {
        case 1:
            turret = [RedLaser redLaserWithPos:pos];
            break;
        case 2:
            turret = [GreenLaser greenLaserWithPos:pos];
            break;
        case 3:
            turret = [BlueLaser blueLaserWithPos:pos];
            break;
        default:
            break;
    }
    
    [self addTurret:turret withPos:pos];
}

- (void) addTurret:(Turret *)turret withPos:(Pair *)pos
{
	NSAssert(gameLayer_ != nil, @"Trying to add a Turret without a registered Game Layer");
	
	// Create the turret
	//Turret *turret = [Turret turretWithPos:pos];
	//TrackingTurret *turret = [TrackingTurret trackingTurretWithPos:pos];
	
	[towerLocations_ setObject:turret forKey:pos];
	[gameLayer_ addChild:turret z:kTower];
	
	// Add a wire associated with this position if there isn't already one
	if (![[ElectricGrid electricGrid] wireAtGrid:pos]) {
		[self addWireWithPos:pos delegate:turret];
	}
	// Else there's a wire, see if it's powered
	else if ([[ElectricGrid electricGrid] isGridPowered:pos]) {
		[turret powerOn];
		[[ElectricGrid electricGrid] addDelegateToWireAtPos:pos delegate:turret];
	}	
}

- (void) removeTurret:(Turret *)turret
{
	[towerLocations_ removeObjectForKey:turret.gridPos];
}

- (Wire *) addWireWithPos:(Pair *)pos delegate:(id <WireDelegate>)delegate
{
	NSAssert(gameLayer_ != nil, @"Trying to add a Wire without a registered Game Layer");
	
	Wire *wire = [[ElectricGrid electricGrid] addWireAtGrid:pos delegate:delegate];
	NSAssert(wire != nil, @"Trying to add a Wire on top of another wire");
	[gameLayer_ addChild:wire z:kWire];
	
	return wire;
}

- (Wire *) addWireWithPos:(Pair *)pos
{
	NSAssert(gameLayer_ != nil, @"Trying to add a Wire without a registered Game Layer");
	
	Wire *wire = [[ElectricGrid electricGrid] addWireAtGrid:pos];		
	NSAssert(wire != nil, @"Trying to add a Wire on top of another wire");	
	[gameLayer_ addChild:wire z:kWire];
	
	return wire;
}

- (void) removeWireWithPos:(Pair *)pos
{
	[[ElectricGrid electricGrid] removeWireAtGrid:pos];
}

- (void) addHomeWithPos:(Pair *)pos
{
	NSAssert(gameLayer_ != nil, @"Trying to add a Home without a registered Game Layer");
	
	// Create home base, make sure it stays above the zombies
	Home *home = [Home homeWithPos:pos];
	[gameLayer_ addChild:home z:kHome];
	
	// Simulate the electric nodes from the base
	Wire *w1 = [self addWireWithPos:[pos topPair]];
	Wire *w2 = [self addWireWithPos:[pos bottomPair]];	
	
	[[ElectricGrid electricGrid] setPowerNode:w1];
	[[ElectricGrid electricGrid] setPowerNode:w2];
}

- (void) addLightningDamageFromPos:(CGPoint)from to:(CGPoint)to
{
	NSAssert(gameLayer_ != nil, @"Trying to add Lightning Damage without a registered Game Layer");
	
	Damage *damage = [LightningDamage lightningDamageFrom:from to:to];
	[eyesLayer_ addChild:damage z:kDamage];
}

- (void) addRedLaserDamageFromPos:(CGPoint)from to:(CGPoint)to
{
	NSAssert(gameLayer_ != nil, @"Trying to add Red Laser Damage without a registered Game Layer");    
    
	Damage *damage = [RedLaserDamage redLaserDamageFrom:from to:to];
	[eyesLayer_ addChild:damage z:kDamage];    
}

- (CGPoint) getLayerOffset
{
	return gameLayer_.position;
}

- (BOOL) isPointLit:(CGPoint)pt
{
	return [fogLayer_ isPointLit:CGPointMake(pt.x, 1023 - pt.y)];
}

- (void) turnLightsOff
{
	NSAssert(fogLayer_ != nil, @"Trying to turn lights off without a registered Fog Layer");		
	[fogLayer_ off];
}

- (void) turnLightsOn
{
	NSAssert(fogLayer_ != nil, @"Trying to turn lights on without a registered Fog Layer");		
	[fogLayer_ on];	
}

- (void) toggleUnitOn:(Pair *)pos withRange:(BOOL)range withDelegate:(id <UnitMenuLayerDelegate>)delegate
{
	NSAssert(unitMenuLayer_ != nil, @"Trying to toggle unit menu without a registered Unit Menu Layer");			
	
	[unitMenuLayer_ toggleOn:pos withRange:range withDelegate:delegate];
}

- (void) toggleUnitOff
{
	NSAssert(unitMenuLayer_ != nil, @"Trying to toggle unit menu without a registered Unit Menu Layer");			
	
	[unitMenuLayer_ toggleOff];
}

- (void) forceToggleUnitOff
{
	NSAssert(unitMenuLayer_ != nil, @"Trying to toggle unit menu without a registered Unit Menu Layer");			
	
	[unitMenuLayer_ forceToggleOff];
}

- (CGFloat) getGeneratorSpeed
{
	NSAssert(generator_ != nil, @"Trying to get generator speed without a registered Generator");				
	
	return generator_.currentSpeedPct;
}

@end
