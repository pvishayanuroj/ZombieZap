//
//  BuildLayer.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 1/23/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "BuildLayer.h"
#import "PButton.h"
#import "Grid.h"

@implementation BuildLayer

- (id) init
{
	if ((self = [super init])) {
		
		self.isTouchEnabled = YES;
		
		rows = 5;
		columns = 3;
		buttonSize = 32;
		offset = CGPointMake(38, 180);
			
		buttons = [[NSMutableArray arrayWithCapacity:16] retain];
		
		CCSprite *sprite;
		greenGrid_ = [[NSMutableArray arrayWithCapacity:13] retain];
		redGrid_ = [[NSMutableArray arrayWithCapacity:13] retain];
	
		for (int i = 0; i < 5; i++) {
			// Green grids
			sprite = [CCSprite spriteWithFile:@"green_box.png"];
			[greenGrid_ addObject:sprite];
			sprite.visible = NO;
			[self addChild:sprite z:1];
			// Red grids
			sprite = [CCSprite spriteWithFile:@"red_box.png"];
			[redGrid_ addObject:sprite];
			[self addChild:sprite z:1];			
			sprite.visible = NO;			
		}
		
	}
	return self;
}

- (BOOL) buildGridAtPos:(CGPoint)pos
{
	NSArray *color;
	CCSprite *sprite;
	BOOL allowable = YES;
	
	[self buildGridOff];
	Pair *p = [[Grid grid] localPixelToWorldGrid:pos];
	
	// Determine whether to show red or green
	TerrainType terrain = [[Grid grid] terrainAtGrid:p];
	if (terrain == TERR_IMPASS || terrain == TERR_NOBUILD) {
		color = redGrid_;
		allowable = NO;
	}
	else {
		color = greenGrid_;
	}
	
	CGPoint gridPos = [[Grid grid] localPixelToLocalGridPixel:pos];
	CGPoint newPos;
	int count = 0;
	NSInteger gridSize = [[Grid grid] gridSize];
	/*
	// 1x1 build box shading
	sprite = [color objectAtIndex:0];
	sprite.position = gridPos;
	sprite.visible = YES;	
	 */
	
	// "pointed" build box shading
	for (int i = -1; i < 2; i++) {
		newPos = CGPointMake(gridPos.x + i * gridSize, gridPos.y);
		sprite = [color objectAtIndex:count++];
		sprite.position = newPos;
		sprite.visible = YES;
	}
	newPos = CGPointMake(gridPos.x, gridPos.y - gridSize);
	sprite = [color objectAtIndex:count++];
	sprite.position = newPos;
	sprite.visible = YES;
	newPos = CGPointMake(gridPos.x, gridPos.y + gridSize);
	sprite = [color objectAtIndex:count++];
	sprite.position = newPos;
	sprite.visible = YES;	
	
	/*
	// 3x3 + 1 build box shading
	// Middle row
	for (int i = -2; i < 3; i++) {
		newPos = CGPointMake(pos.x + i * gridSize, pos.y);
		sprite = [color objectAtIndex:count++];
		sprite.position = newPos;
		sprite.visible = YES;
	}
	
	for (int i = -1; i < 2; i++) {
		newPos = CGPointMake(pos.x + i * gridSize, pos.y + gridSize);
		sprite = [color objectAtIndex:count++];
		sprite.position = newPos;
		sprite.visible = YES;
		
		newPos = CGPointMake(pos.x + i * gridSize, pos.y - gridSize);
		sprite = [color objectAtIndex:count++];
		sprite.position = newPos;		
		sprite.visible = YES;		
	}	
	
	newPos = CGPointMake(pos.x, pos.y + 2*gridSize);
	sprite = [color objectAtIndex:count++];
	sprite.position = newPos;
	sprite.visible = YES;
	newPos = CGPointMake(pos.x, pos.y - 2*gridSize);
	sprite = [color objectAtIndex:count++];
	sprite.position = newPos;
	sprite.visible = YES;	
	 */
	
	return allowable;
}

- (void) buildGridOff
{	
	for (CCSprite *s in greenGrid_) {
		s.visible = NO;
	}
	for (CCSprite *s in redGrid_) {
		s.visible = NO;
	}	
}
	
- (void) addButton:(PButton *)button
{
	[buttons addObject:button];
	[self addChild:button z:0];
	
	NSUInteger n = [buttons count];
	NSUInteger x = (n - 1) % columns;
	NSUInteger y = (n - 1) / columns;
	
	CGPoint pos = CGPointMake(offset.x + x * buttonSize, offset.y - y * buttonSize);
	
	[button setPosition:pos];
}

- (void) dealloc
{
	[buttons release];
	[greenGrid_ release];
	[redGrid_ release];
	 
	[super dealloc];
}

@end
