//
//  GameManager.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/5/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"
#import "WireDelegate.h"

@class Zombie;
@class Turret;
@class Pair;
@class GameLayer;
@class FogLayer;
@class EyesLayer;
@class Spotlight;
@class Light;
@class Wire;

@interface GameManager : NSObject {

	GameLayer *gameLayer_;
	
	FogLayer *fogLayer_;
	
	EyesLayer *eyesLayer_;
	
	NSMutableSet *zombies_;
	
	NSMutableSet *spotlights_;
	
	NSMutableDictionary *towerLocations_;
	
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

- (void) addZombieWithPos:(Pair *)pos obj:(Pair *)obj;

- (void) removeZombie:(Zombie *)zombie;

- (void) addTurretWithPos:(Pair *)pos;

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

- (void) addDamageFromPos:(CGPoint)from to:(CGPoint)to;

- (CGPoint) getLayerOffset;

- (BOOL) isPointLit:(CGPoint)pt;

- (void) turnLightsOff;

- (void) turnLightsOn;

@end
