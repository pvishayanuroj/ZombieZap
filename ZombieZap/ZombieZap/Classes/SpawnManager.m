//
//  SpawnManager.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/6/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "SpawnManager.h"
#import "Spawn.h"
#import "GameManager.h"
#import "AStar.h"
#import "Grid.h"
#import "Pair.h"

// For singleton
static SpawnManager *_spawnManager = nil;

@implementation SpawnManager

+ (SpawnManager *) spawnManager
{
	if (!_spawnManager)
		_spawnManager = [[self alloc] init];
	
	return _spawnManager;
}

+ (id) alloc
{
	NSAssert(_spawnManager == nil, @"Attempted to allocate a second instance of a Spawn Manager singleton.");
	return [super alloc];
}

+ (void) purgeGameManager
{
	[_spawnManager release];
	_spawnManager = nil;
}

- (id) init
{
	if ((self = [super init]))
	{
		spawns_ = [[NSMutableArray arrayWithCapacity:8] retain];
	}
	return self;
}

- (void) loadSpawns:(NSString *)filename
{
	// Load from plist
	NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
	NSAssert(path != nil, ([NSString stringWithFormat:@"Invalid spawn file: %@", filename]));
	NSArray *spawn_array = [NSArray arrayWithContentsOfFile:path];	
	
	Spawn *spawn;
	Pair *startPos;
	Pair *objective;
	CGFloat interval;
	
	// Go through all spawns in the plist (dictionary objects)	
	for (id obj in spawn_array) {
		
		startPos = [self parsePair:[obj objectForKey:@"Start"]];
		interval = [[obj objectForKey:@"Interval"] floatValue];
		objective = [self parsePair:[obj objectForKey:@"Objective"]];
		
		// Create the spawn object
		spawn = [Spawn spawn:interval location:startPos obj:objective];
		[spawns_ addObject:spawn];		
	}
	
	// Do A* pathfinding pregame
	[self precalculatePaths];
	
	// Add these to the game layer
	[self activateSpawns];
}

- (void) activateSpawns
{
	GameLayer *gameLayer = (GameLayer *)[[GameManager gameManager] gameLayer];
	
	NSAssert(gameLayer != nil, @"Trying to add Spawns without a registered Game Layer");
	
	for (Spawn *s in spawns_) {
		[gameLayer addChild:s];
	}
}

- (Pair *) parsePair:(NSString *)string
{
	NSInteger first, second;
	BOOL firstDone = NO;
	
	NSScanner *scanner = [NSScanner scannerWithString:string];
	
	// Ignore new lines, spaces, commas, parens, and braces
	NSCharacterSet *toIgnore = [NSCharacterSet characterSetWithCharactersInString:@"()[], \n\r"];
	[scanner setCharactersToBeSkipped:toIgnore];	
	
	while ([scanner isAtEnd] == NO) {
		if (!firstDone) {
			[scanner scanInteger:&first];
			firstDone = YES;
		}
		else {
			[scanner scanInteger:&second];
		}
	}
	
	return [Pair pair:first second:second];
}

- (void) precalculatePaths
{
	AStar *aStar;
	NSArray *path;
	NSDate *ref = [NSDate date];
	
	for (Spawn *s in spawns_) {
		aStar = [AStar aStar];
		path = [aStar findPathFrom:s.startPos to:s.objective];
		if (path != nil) {
			[[Grid grid] addPathToObjective:path];		
		}
		else {
			NSLog(@"No path found from %@ to %@", s.startPos, s.objective);
		}
	}
	
	NSLog(@"Path precalculation done in: %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);
}

- (BOOL) checkIfObjectiveBlocked:(Pair *)p
{
	AStar *aStar;
	NSArray *path;
	NSDate *ref = [NSDate date];
	
	BOOL b = NO;
	[[Grid grid] makeImpassable:p];
	
	for (Spawn *s in spawns_) {
		aStar = [AStar aStar];
		path = [aStar findPathFrom:s.startPos to:s.objective];
		if (path == nil) {
			b = YES;
			break;
		}
	}
	[[Grid grid] makePassable:p];	
	
	NSLog(@"Path checking in: %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);
	return b;
}

- (void) dealloc
{
	for (Spawn *s in spawns_) {
		[s removeFromParentAndCleanup:YES];
	}
	
	[spawns_ release];
	
	[super dealloc];
}

@end
