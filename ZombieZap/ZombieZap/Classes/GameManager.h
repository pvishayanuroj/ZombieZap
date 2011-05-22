//
//  GameManager.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/5/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"
#import "WireDelegate.h"
#import "UnitMenuLayerDelegate.h"

@class Zombie;
@class Turret;
@class Pair;
@class GameLayer;
@class FogLayer;
@class EyesLayer;
@class UnitMenuLayer;
@class Spotlight;
@class Light;
@class Wire;
@class Generator;

@interface GameManager : NSObject {

	GameLayer *gameLayer_;
	
	FogLayer *fogLayer_;
	
	EyesLayer *eyesLayer_;
	
	UnitMenuLayer *unitMenuLayer_;
	
	NSMutableSet *zombies_;
	
	NSMutableSet *spotlights_;
	
	NSMutableDictionary *towerLocations_;
	
	Generator *generator_;
	
}

@property (nonatomic, readonly) CCLayer *gameLayer;
@property (nonatomic, readonly) NSMutableSet *zombies;
@property (nonatomic, readonly) NSMutableSet *spotlights;
@property (nonatomic, readonly) NSMutableDictionary *towerLocations;

+ (GameManager *) gameManager;

+ (void) purgeGameManager;

- (void) registerGameLayer:(GameLayer *)gameLayer;

- (void) registerFogLayer:(FogLayer *)fogLayer;

- (void) registerEyesLayer:(EyesLayer *)eyesLayer;

- (void) registerUnitMenuLayer:(UnitMenuLayer *)unitMenuLayer;

- (void) registerGenerator:(Generator *)generator;

- (void) updateDependentLayerPositions:(CGPoint)position;

- (void) addZombieWithPos:(Pair *)pos obj:(Pair *)obj;

- (void) removeZombie:(Zombie *)zombie;

- (void) addTeslaWithPos:(Pair *)pos level:(NSUInteger)level;

- (void) addGunWithPos:(Pair *)pos level:(NSUInteger)level;

- (void) addLaserWithPos:(Pair *)pos level:(NSUInteger)level;

- (void) addTurret:(Turret *)turret withPos:(Pair *)pos;
//- (void) addTurretWithPos:(Pair *)pos;

- (void) removeTurret:(Turret *)turret;

- (void) addLightWithPos:(Pair *)pos radius:(CGFloat)radius;

- (void) addStaticLightWithPos:(Pair *)pos radius:(CGFloat)radius;

- (Spotlight *) addSpotlight:(CGPoint)pos radius:(CGFloat)radius;

- (void) removeSpotlight:(Spotlight *)spotlight;

- (void) removeLight:(Light *)light;

- (Wire *) addWireWithPos:(Pair *)pos delegate:(id <WireDelegate>)delegate;

- (Wire *) addWireWithPos:(Pair *)pos;

- (void) removeWireWithPos:(Pair *)pos;

- (void) addHomeWithPos:(Pair *)pos;

- (void) addLightningDamageFromPos:(CGPoint)from to:(CGPoint)to;

- (void) addRedLaserDamageFromPos:(CGPoint)from to:(CGPoint)to;

- (CGPoint) getLayerOffset;

- (BOOL) isPointLit:(CGPoint)pt;

- (void) turnLightsOff;

- (void) turnLightsOn;

- (void) toggleUnitOn:(Pair *)pos withRange:(BOOL)range withDelegate:(id <UnitMenuLayerDelegate>)delegate;

- (void) toggleUnitOff;

- (void) forceToggleUnitOff;

- (CGFloat) getGeneratorSpeed;

@end
