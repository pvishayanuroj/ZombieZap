//
//  BuildLayer.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 1/23/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "BuildLayer.h"
#import "PButton.h"

@implementation BuildLayer

- (id) init
{
	if ((self = [super init])) {
		
		self.isTouchEnabled = YES;
		
		rows = 5;
		columns = 4;
		buttonSize = 50;
		offset = CGPointMake(20, 200);
			
		buttons = [[NSMutableArray arrayWithCapacity:16] retain];
	}
	return self;
}

- (void) addButton:(PButton *)button
{
	[buttons addObject:button];
	[self addChild:button];
	
	NSUInteger n = [buttons count];
	NSUInteger x = (n - 1) % rows;
	NSUInteger y = (n - 1) / rows;
	
	CGPoint pos = CGPointMake(offset.x + x * buttonSize, offset.y - y * buttonSize);
	
	[button setPosition:pos];
}

- (void) dealloc
{
	[buttons release];
	 
	[super dealloc];
}

@end
