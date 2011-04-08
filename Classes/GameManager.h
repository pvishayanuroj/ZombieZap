//
//  GameManager.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/5/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class Zombie;
@class Turret;
@class Pair;
@class GameLayer;
@class FogLayer;
@class Spotlight;
@class Light;

@interface GameManager : NSObject {

	GameLayer *gameLayer_;
	
	FogLayer *fogLayer_;
	
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

- (void) addZombieWithPos:(Pair *)pos obj:(Pair *)obj;

- (void) removeZombie:(Zombie *)zombie;

- (void) addTurretWithPos:(Pair *)pos;

- (void) removeTurret:(Turret *)turret;

- (Spotlight *) addLightWithPos:(Pair *)pos radius:(CGFloat)radius;

- (void) addStaticLightWithPos:(Pair *)pos radius:(CGFloat)radius;

- (void) removeSpotlight:(Light *)light;

- (void) removeLight:(Light *)light;

- (void) addWireWithPos:(Pair *)pos;

- (void) addHomeWithPos:(Pair *)pos;

- (void) addDamageFromPos:(CGPoint)from to:(CGPoint)to;

- (CGPoint) getLayerOffset;

@end
