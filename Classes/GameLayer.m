//
//  GameLayer.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 2/9/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "GameLayer.h"
#import "GameManager.h"
#import "SpawnManager.h"
#import "Grid.h"
#import "Zombie.h"
#import "Turret.h"
#import "Pair.h"
#import "AStar.h"

#import "CCTexture2DMutable.h"
#import "AWTextureFilter.h"
#import "FogLayer.h"

@implementation GameLayer

/**
 Game layer initialization method
 @returns Returns the created game layer
 */
- (id) init
{
	if ((self = [super init])) {
		
		self.isTouchEnabled = YES;
		
		Grid *grid = [Grid grid];
		[grid setGridWithMap:@"map_32"];
		[self addChild:grid.mapImage z:0];
		
		[[GameManager gameManager] registerGameLayer:self];
		
		[[GameManager gameManager] addHomeWithPos:[Pair pair:15 second:15]];
		
		//[[SpawnManager spawnManager] loadSpawns:@"Test_Spawns"];
		//[[SpawnManager spawnManager] loadSpawns:@"One_Spawn"];
		[[SpawnManager spawnManager] loadSpawns:@"Omni_Spawns"];
		
		[self debugCode];
	}
	return self;
}

- (void) debugCode
{
/*	
	AStar *aStar = [AStar aStar];
	Pair *start = [Pair pair:15 second:0];
	Pair *dest = [Pair pair:15 second:15];
	NSDate *reftime = [NSDate date];
	NSArray *path = [aStar findPathFrom:start to:dest];
	NSLog(@"Pathfinding done in: %4.9f", [[NSDate date] timeIntervalSinceDate:reftime]);
	
	[[Grid grid] addPathToObjective:path];
	
	for (int i = 0; i < [path count]; i++) {
		[self debugGridInfo:[path objectAtIndex:i] count:i];
	}
 */
	
	/*
	// Add some zombies
	Zombie *zombie = [Zombie zombieWithPos:start];
	//[self addChild:zombie];
	[[GameManager gameManager] addZombie:zombie];
	NSLog(@"Added %@, RC: %d\n", zombie, [zombie retainCount]);
	*/
	
	// Add some turrets
	/*
	[[GameManager gameManager] addTurretWithPos:[Pair pair:2 second:4]];
	[[GameManager gameManager] addTurretWithPos:[Pair pair:2 second:2]];
	[[GameManager gameManager] addTurretWithPos:[Pair pair:6 second:3]];		
	 */
	

}

/**
 When the player first puts their finger down on the screen
 @param touches Reference to the UITouch object
 @param event Associated UIEvent
 */
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSSet *allTouches = [event allTouches];
	
	if(allTouches.count == 1) {
		UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
		// Determine the touch point coordinates	
		finger1Start = [[CCDirector sharedDirector] convertToGL:[touch1 locationInView:[touch1 view]]];
		
		// Store the current location of the map
		layerPosStart = self.position;
		
#if DEBUG_TOUCHES
		NSLog(@"Touch began: %4.2f, %4.2f", finger1Start.x, finger1Start.y);
#endif
	}
}

/**
 When the player moves their finger across the screen
 @param touches Reference to the UITouch object
 @param event Associated UIEvent
 */
- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSSet *allTouches = [event allTouches];
	
	// Retrieve the background sprite and create a size object to store the screen size
	Grid *grid = [Grid grid];

	CCSprite *bg = 	grid.mapImage;
	CGSize size = [[CCDirector sharedDirector] winSize];
	
	CGPoint newPosition;

	
	if(allTouches.count == 1) {
		UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
		// Determine the touch point coordinates
		CGPoint touchPoint = [touch1 locationInView:[touch1 view]];
		touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];	
		
		// Calculate how much the user's finger moved from the start of the touch
		CGPoint movement;
		movement.x = finger1Start.x - touchPoint.x;
		movement.y = finger1Start.y - touchPoint.y;
		
#if DEBUG_TOUCHES
		NSLog(@"Touch moved: %4.2f, %4.2f", touchPoint.x, touchPoint.y);
		NSLog(@"Layer Position: %4.2f, %4.2f", self.position.x, self.position.y);
#endif
		
		// Create the new position to move the map to using the movement
		newPosition = ccpSub(layerPosStart, movement);
	}
		
	CGFloat zoomScale = 1.0f;
	CGSize newLayerSize = CGSizeMake(bg.contentSize.width * zoomScale, bg.contentSize.height * zoomScale);
	
	// If the position of the map is outside moving outside of the screen then reset the positon so it does not
	if (newPosition.x > 0) newPosition.x = 0;
	if (newPosition.y > 0) newPosition.y = 0;
	if (newPosition.x < -(newLayerSize.width - size.width)) newPosition.x = -(newLayerSize.width - size.width);
	if (newPosition.y < -(newLayerSize.height - size.height)) newPosition.y = -(newLayerSize.height - size.height);
	
#if DEBUG_PINCHES
	NSLog(@"Original Size: %4.2f, %4.2f", bg.contentSize.width, bg.contentSize.height);
	NSLog(@"New Size: %4.2f, %4.2f", newLayerSize.width, newLayerSize.height);
	NSLog(@"Diff Size: %4.2f, %4.2f", bg.contentSize.width-newLayerSize.width, bg.contentSize.height-newLayerSize.height);
	NSLog(@"Boundaries: %4.2f, %4.2f, %4.2f, %4.2f", 0, 0, -(newLayerSize.width - size.width), -(newLayerSize.height - size.height));
	NSLog(@"New Position: %4.2f, %4.2f", newPosition.x, newPosition.y);
#endif
	
	// Move the map
	self.position = newPosition;
	FogLayer *fogLayer = (FogLayer *)[self.parent getChildByTag:5];
	fogLayer.position = newPosition;
}

- (void) debugGridInfo:(Pair *)p count:(NSInteger)count
{
	Grid *grid = [Grid grid];
	NSString *msg0 = [NSString stringWithFormat:@"%d", count];
	CCLabelTTF *label0 = [CCLabelTTF labelWithString:msg0 fontName:@"Marker Felt" fontSize:12];
	label0.position = [grid gridToPixel:p]; 
	label0.color = ccc3(0,0,0);
	[self addChild:label0 z:1];	
}

@end
