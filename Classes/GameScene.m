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
#import "PButton.h"

@implementation GameScene

- (id) init 
{
	if ((self = [super init])) {
		
		// Initialize the layer
		GeneratorLayer *generatorLayer = [GeneratorLayer node];
		[self addChild:generatorLayer z:2];
		
		BuildLayer *buildLayer = [BuildLayer node];
		[self addChild:buildLayer z: 1];
		
		GameLayer *gameLayer = [GameLayer node];
		[self addChild:gameLayer z:0];
		
		PButton *b1 = [PButton pButton];
		//PButton *b2 = [PButton pButton];
		//PButton *b3 = [PButton pButton];
		//PButton *b4 = [PButton pButton];		
		[buildLayer addButton:b1];
		//[buildLayer addButton:b2];
		//[buildLayer addButton:b3];
		//[buildLayer addButton:b4];		
		
	}
	return self;
}

@end
