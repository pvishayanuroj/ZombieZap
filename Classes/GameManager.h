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

@interface GameManager : NSObject {

	GameLayer *gameLayer_;
	
	FogLayer *fogLayer_;
	
	NSMutableSet *zombies_;
	
	NSMutableSet *spotlights_;
	
	NSMutableSet *towerLocations_;
	
}

@property (nonatomic, readonly) CCLayer *gameLayer;
@property (nonatomic, readonly) NSMutableSet *zombies;
@property (nonatomic, readonly) NSMutableSet *spotlights;
@property (nonatomic, readonly) NSMutableSet *towerLocations;

+ (GameManager *) gameManager;

+ (void) purgeGameManager;

- (void) registerGameLayer:(GameLayer *)gameLayer;

- (void) registerFogLayer:(FogLayer *)fogLayer;

- (void) addZombie:(Zombie *)zombie;

- (void) addZombieWithPos:(Pair *)pos;

- (void) removeZombie:(Zombie *)zombie;

- (void) addTurret:(Turret *)turret;

- (void) addTurretWithPos:(Pair *)pos;

- (Spotlight *) addLightWithPos:(Pair *)pos radius:(CGFloat)radius;

- (Spotlight *) addLightWithPos:(Pair *)pos;

- (void) removeSpotlight:(Spotlight *)spotlight;

- (CGPoint) getLayerOffset;

@end
