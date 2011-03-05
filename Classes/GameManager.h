//
//  GameManager.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/5/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class Zombie;

@interface GameManager : NSObject {

	CCLayer *gameLayer_;
	
	NSMutableSet *zombies_;
	
}

@property (nonatomic, readonly) NSMutableSet *zombies;

+ (GameManager *) gameManager;

+ (void) purgeGameManager;

- (void) addZombie:(Zombie *)zombie;

- (void) removeZombie:(Zombie *)zombie;

@end
