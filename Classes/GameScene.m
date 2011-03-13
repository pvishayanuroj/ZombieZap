//
//  GameScene.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 1/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "GameScene.h"
#import "GeneratorLayer.h"
#import "BuildLayer.h"
#import "GameLayer.h"
#import "FogLayer.h"
#import "PButton.h"
#import "BinaryHeap.h"
#import "GameManager.h"
#import "Pair.h"

@implementation GameScene

- (id) init 
{
	if ((self = [super init])) {
		
		[self animationLoader:@"Units" spriteSheetName:@"CharacterSpriteSheet"];
		
		// Initialize the layer
		GeneratorLayer *generatorLayer = [GeneratorLayer node];
		[self addChild:generatorLayer z:3];
		
		BuildLayer *buildLayer = [BuildLayer node];
		[self addChild:buildLayer z:2];
		
		FogLayer *fogLayer = [FogLayer node];
		[self addChild:fogLayer z:1 tag:5];

		GameLayer *gameLayer = [GameLayer node];
		[self addChild:gameLayer z:0];
		
		[self addButtons:buildLayer];
		
		/*
		s1 = [[[GameManager gameManager] addLightWithPos:[Pair pair:10 second:5] radius:100] retain];
		s2 = [[[GameManager gameManager] addLightWithPos:[Pair pair:7 second:5] radius:120] retain];		
		s3 = [[[GameManager gameManager] addLightWithPos:[Pair pair:8 second:8] radius:120] retain];		
		[self schedule:@selector(update:) interval:120.0f/60.0f];		
		*/
		
		// DEBUG
		/*
		BinaryHeap *b = [BinaryHeap bHeapWithCapacity:10];
		[b addObject:10];
		[b addObject:17];
		[b addObject:24];
		[b addObject:20];
		[b addObject:34];
		[b addObject:38];
		[b addObject:30];
		[b addObject:30];
		NSLog(@"b: %@", b);
		NSLog(@"removed: %d", [b removeFirst]);
		NSLog(@"b: %@", b);		
		NSLog(@"removed: %d", [b removeFirst]);
		NSLog(@"b: %@", b);		
		NSLog(@"removed: %d", [b removeFirst]);
		NSLog(@"b: %@", b);		
		NSLog(@"removed: %d", [b removeFirst]);
		NSLog(@"b: %@", b);		
		NSLog(@"removed: %d", [b removeFirst]);
		NSLog(@"b: %@", b);		
		NSLog(@"removed: %d", [b removeFirst]);
		NSLog(@"b: %@", b);		
		NSLog(@"removed: %d", [b removeFirst]);
		NSLog(@"b: %@", b);		
		NSLog(@"removed: %d", [b removeFirst]);		
		*/
	}
	return self;
}

- (void) update:(ccTime)dt
{
	[[GameManager gameManager] removeSpotlight:s1];
	//[[GameManager gameManager] removeSpotlight:s2];			
}

- (void) addButtons:(BuildLayer *)buildLayer
{
	PButton *taser = [PButton pButton:@"taser_button.png" placementImage:@"taser_button.png" buttonType:B_TASER];
	PButton *light = [PButton pButton:@"light_button.png" placementImage:@"light_button.png" buttonType:B_LIGHT];
	PButton *wire = [PButton pButton:@"wire_button.png" placementImage:@"wire_button.png" buttonType:B_WIRE];	
	[buildLayer addButton:taser];
	[buildLayer addButton:light];
	[buildLayer addButton:wire];	
}

- (void) animationLoader:(NSString *)unitListName spriteSheetName:(NSString *)spriteSheetName
{
	
	NSArray *unitAnimations;
	NSString *unitName;
	NSString *animationName;
	NSUInteger numFr;
	CGFloat delay;
	NSMutableDictionary *animationDictionary;
	NSMutableDictionary *actionDictionary;
	NSMutableArray *frames;
	CCAnimation *animation;
	
	// Load from the Units.plist file
	NSString *path = [[NSBundle mainBundle] pathForResource:unitListName ofType:@"plist"];
	NSArray *unit_array = [NSArray arrayWithContentsOfFile:path];	
	
	// Load the frames from the spritesheet into the shared cache
	CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
	path = [[NSBundle mainBundle] pathForResource:spriteSheetName ofType:@"plist"];
	[cache addSpriteFramesWithFile:path];
	
	// Load the spritesheet and add it to the game scene
	path = [[NSBundle mainBundle] pathForResource:spriteSheetName ofType:@"png"];
	CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:path];
	[self addChild:spriteSheet];
	
	// Go through all units in the plist (dictionary objects)
	for (id obj in unit_array) {
		
		unitName = [obj objectForKey:@"Name"]; 
		
		// Retrieve the array holding information for each animation
		unitAnimations = [NSArray arrayWithArray:[obj objectForKey:@"Animations"]];		
		
		// Initialize where we store this unit's animations
		animationDictionary = [NSMutableDictionary dictionaryWithCapacity:4];
		actionDictionary = [NSMutableDictionary dictionaryWithCapacity:4];		
		
		// Go through all the different animations for this unit (different dictionaries)
		for (id unitAnimation in unitAnimations) {
			
			// Parse the animation specific information 
			animationName = [unitAnimation objectForKey:@"Name"];		
			animationName = [NSString stringWithFormat:@"%@ %@", unitName, animationName];
			numFr = [[unitAnimation objectForKey:@"Num Frames"] intValue];
			delay = [[unitAnimation objectForKey:@"Animate Delay"] floatValue];
			
			frames = [NSMutableArray arrayWithCapacity:6];
			
			// Store each frame in the array
			for (int i = 0; i < numFr; i++) {
				
				// Formulate the frame name based off the unit's name and the animation's name and add each frame
				// to the animation array
				NSString *frameName = [NSString stringWithFormat:@"%@ %02d.png", animationName, i+1];
				CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
				[frames addObject:frame];
			}
			
			// Create the animation object from the frames we just processed
			//animation = [CCAnimation animationWithFrames:frames];
			animation = [CCAnimation animationWithFrames:frames delay:0.1f];
			
			// Store the animation
			[[CCAnimationCache sharedAnimationCache] addAnimation:animation name:animationName];
			
		} // end for-loop of animations
	} // end for-loop of units
	
	//NSLog(@"Units dictionary: %@", units);
}

@end
