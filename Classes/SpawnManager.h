//
//  SpawnManager.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/6/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

@class Pair;

@interface SpawnManager : NSObject {

	NSMutableArray *spawns_;
		
}

+ (SpawnManager *) spawnManager;

- (void) loadSpawns:(NSString *)filename;

- (void) activateSpawns;

- (void) precalculatePaths;

- (Pair *) parsePair:(NSString *)string;

@end
