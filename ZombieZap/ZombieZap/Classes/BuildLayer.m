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
#import "Pair.h"
#import "GameManager.h"
#import "ElectricGrid.h"
#import "SpawnManager.h"

@implementation BuildLayer

- (id) init
{
	if ((self = [super init])) {
		
		self.isTouchEnabled = YES;
		
		prevPlacement_ = [[Pair pair:-1 second:-1] retain];
		
		wirePlacement_ = NO;
		dirPreference_ = D_VERTICAL;
		
		rows = 5;
		columns = 3;
		buttonSize = 32;
		offset = CGPointMake(38, 180);
			
		buttons = [[NSMutableArray arrayWithCapacity:16] retain];
		
		CCSprite *sprite;
		greenGrid_ = [[NSMutableArray arrayWithCapacity:13] retain];
		redGrid_ = [[NSMutableArray arrayWithCapacity:13] retain];
	
		int longestWire = 25; // NEED TO CALCULATE THIS
		for (int i = 0; i < longestWire; i++) {
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
	Pair *p = [[Grid grid] localPixelToWorldGrid:pos];
	
	// Check if we've moved off the last tile we were on to save some computation time
	// If so, then do the new calculation
	if (![p isEqual:prevPlacement_]) {

		CCSprite *sprite;		
		NSArray *color = greenGrid_;
		BOOL allowable = YES;		
		
		[self buildGridOff];		
		
		// Determine whether to show red or green
		TerrainType terrain = [[Grid grid] terrainAtGrid:p];
		if (terrain != TERR_PASS) {
			color = redGrid_;
			allowable = NO;
		}
		// To enable the style of play where towers cannot block the path to the objective
		/*
		else {
			if ([[SpawnManager spawnManager] checkIfObjectiveBlocked:p]) {
				color = redGrid_;
				allowable = NO;
			}
		}
		*/
		
		// Set values to remember for the next time we come in here
		prevAllowable_ = allowable;
		[prevPlacement_ setEqualWith:p];		

		// Draw the build grid
		CGPoint gridPos = [[Grid grid] localPixelToLocalGridPixel:pos];
		CGPoint newPos;
		int count = 0;
		NSInteger gridSize = [[Grid grid] gridSize];
		
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
		
		return allowable;
	}
	// Else we haven't moved off the tile, just return what we returned last time
	else {
		return prevAllowable_;		
	}	
}

- (void) buildGridOff
{	
	for (CCSprite *s in greenGrid_) {
		s.visible = NO;
	}
	for (CCSprite *s in redGrid_) {
		s.visible = NO;
	}	
	
	// Reset this so we don't get confused next time in buildGridAtPos()
	prevPlacement_.x = -1;
	prevPlacement_.y = -1;
}
	
- (NSArray *) buildGridFrom:(Pair *)from to:(Pair *)to passable:(BOOL *)passable
{
	CCSprite *sprite;	
	NSMutableArray *path;
	NSArray *color = greenGrid_;
	int count = 0;	
	*passable = YES;
	
	// Get the tiles in the path
	// Straight line path
	if (from.x == to.x || from.y == to.y) {
		path = [self getStraightPathFrom:from to:to passable:passable];
		// Store the directional preference, because if we corner, the first segment will be in the same intial direction
		dirPreference_ = (from.x == to.x) ? D_VERTICAL : D_HORIZONTAL;
	}
	// L-shaped path
	else {
		Pair *corner;
		// If vertical preference, corner's x will stay the same as start node
		if (dirPreference_ == D_VERTICAL) {
			corner = [Pair pair:from.x second:to.y];
		}
		// Else horizontal preference, corner's y will stay the same as end node
		else {
			corner = [Pair pair:to.x second:from.y];			
		}
		
		// Get first and second segments and form the cumulative path
		path = [self getStraightPathFrom:from to:corner passable:passable];		
		NSArray *p2 = [self getStraightPathFrom:corner to:to passable:passable];
		[path addObjectsFromArray:p2];
	}
	

	// Turn the grid red if there's an obstruction
	if (!*passable) {
		color = redGrid_;
	}
	
	// Draw the path tiles	
	for (Pair *p in path) {
		sprite = [color objectAtIndex:count++];
		sprite.position = [[Grid grid] worldGridToLocalPixel:p];
		sprite.visible = YES;
	}
	
	return path;
}
							 
- (NSMutableArray *) getStraightPathFrom:(Pair *)from to:(Pair *)to passable:(BOOL *)passable
{
	Grid *grid = [Grid grid];
	NSMutableArray *path = nil;
	Pair *p;	
	Pair *start = from;
	Pair *end = to;

	
	// Vertical path
	if (from.x == to.x) {
		// Make sure the start is the one with the lower value
		if (to.y < from.y) {
			start = to;
			end = from;
		}
		
		path = [NSMutableArray arrayWithCapacity:(end.y - start.y + 1)];
		// Get the path, and check to see if anything's blocking it
		for (int i = start.y; i <= end.y; i++) {
			p = [Pair pair:from.x second:i];
			[path addObject:p];
			if ([grid impassableAtGrid:p]) {
				*passable = NO;
			}
		}
	}
	// Horizontal path
	else if (from.y == to.y) {
		// Make sure the start tis the one with the lower value
		if (to.x < from.x) {
			start = to;
			end = from;
		}
		
		path = [NSMutableArray arrayWithCapacity:(end.y - start.y + 1)];
		// Get the path, and check to see if anything's blocking it		
		for (int i = start.x; i <= end.x; i++) {
			p = [Pair pair:i second:from.y];
			[path addObject:p];
			if ([grid impassableAtGrid:p]) {
				*passable = NO;
			}			
		}
	}
	
	return path;
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

- (void) toggleWirePlacement:(PButton *)b
{
	if (wirePlacement_) {
		wirePlacement_ = NO;
		[toggledButton_ changeToNormal];
		[toggledButton_ release];
	}
	else {
		wirePlacement_ = YES;
		toggledButton_ = [b retain];
	}
}

- (void) onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}

- (void) onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if (wirePlacement_) {
		
		// Touchpoint is relative to the build layer
		CGPoint touchPoint = [self convertTouchToNodeSpace:touch];
		
		wireStart_ = [[[Grid grid] localPixelToWorldGrid:touchPoint] retain];
		wireEnd_ = [[[Grid grid] localPixelToWorldGrid:touchPoint] retain];
		
		// Draw the initial one tile wire build path
		BOOL b;
		[self buildGridFrom:wireStart_ to:wireEnd_ passable:&b];
		
		return YES;
	}
	return NO;
}


- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	// Touchpoint is relative to the build layer
	CGPoint touchPoint = [self convertTouchToNodeSpace:touch];
	
	Pair *p = [[Grid grid] localPixelToWorldGrid:touchPoint];	
	
	// If the user moved their finger to new grid to end the wire
	if (![p isEqual:wireEnd_]) {
		[self buildGridOff];
		[wireEnd_ release];
		wireEnd_ = [p retain];
		
		// Redraw the wire build path
		BOOL b;
		[self buildGridFrom:wireStart_ to:wireEnd_ passable:&b];
	}
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	BOOL passable;
	NSArray *path = [self buildGridFrom:wireStart_ to:wireEnd_ passable:&passable];
	[self buildGridOff];
	
	// Reset things
	wirePlacement_ = NO;
	[wireStart_ release];	
	[wireEnd_ release];
	[toggledButton_ changeToNormal];
	[toggledButton_ release];
	
	// Lay the wire down if nothing is blocking the path
	if (passable) {
		GameManager *gameManager = [GameManager gameManager];
		ElectricGrid *eGrid = [ElectricGrid electricGrid];
		// Check duplicates, since wire can go on top of wire
		for (Pair *p in path) {
			if (![eGrid wireAtGrid:p]) {
				[gameManager addWireWithPos:p];
			}
		}
	}
}

- (void) dealloc
{
	[buttons release];
	[greenGrid_ release];
	[redGrid_ release];
	
	[prevPlacement_ release];
	 
	[super dealloc];
}

@end
