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

#import "Debugging.h"

@implementation Home

+ (id) homeWithPos:(Pair *)pos
{
	return [[[self alloc] initHomeWithPos:pos] autorelease];
}

- (id) initHomeWithPos:(Pair *)pos
{
	if ((self = [super init])) {
		
		sprite_ = [[CCSprite spriteWithFile:@"home_1.png"] retain];
#if !DEBUG_NOBASESPRITE
		[self addChild:sprite_];				
#endif
		
		Grid *grid = [Grid grid];
		CGPoint startCoord = [grid gridToPixel:pos];
		self.position = startCoord;		
		
		// Make the goal and the doorway just unbuildable
		[grid makeNoBuild:pos];
		[grid makeNoBuild:[pos rightPair]];
		//[grid makeImpassable:[pos rightPair]];		
		// Make the surrounding squares impassable
		[grid makeImpassable:[pos leftPair]];
		[grid makeImpassable:[pos topPair]];
		[grid makeImpassable:[pos bottomPair]];
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
