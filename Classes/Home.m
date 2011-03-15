//
//  Home.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Home.h"
#import "Grid.h"
#import "Pair.h"
#import "GameManager.h"

@implementation Home

+ (id) homeWithPos:(Pair *)pos
{
	return [[[self alloc] initHomeWithPos:pos] autorelease];
}

- (id) initHomeWithPos:(Pair *)pos
{
	if ((self = [super init])) {
		
		sprite_ = [[CCSprite spriteWithFile:@"home_1.png"] retain];
		[self addChild:sprite_];				
		
		Grid *grid = [Grid grid];
		CGPoint startCoord = [grid gridToPixel:pos];
		self.position = startCoord;		
		
		//[grid makeImpassable:pos];
		[grid makeImpassable:[Pair pair:(pos.x-1) second:pos.y]];
		//[grid makeImpassable:[Pair pair:(pos.x+1) second:pos.y]];	// This is the goal node
		[grid makeImpassable:[Pair pair:(pos.y) second:(pos.y-1)]];		
		[grid makeImpassable:[Pair pair:(pos.y) second:(pos.y+1)]];				
		[grid makeImpassable:[Pair pair:(pos.x+1) second:(pos.y+1)]];				
		[grid makeImpassable:[Pair pair:(pos.x+1) second:(pos.y-1)]];				
		[grid makeImpassable:[Pair pair:(pos.x-1) second:(pos.y+1)]];				
		[grid makeImpassable:[Pair pair:(pos.x-1) second:(pos.y-1)]];			
		
		[[GameManager gameManager] addStaticLightWithPos:pos];
		
	}
	return self;
}

- (void) dealloc
{
	[sprite_ release];
	
	[super dealloc];
}

@end
