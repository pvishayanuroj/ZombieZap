//
//  UnitMenuLayer.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 4/20/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "UnitMenuLayer.h"
#import "GameManager.h"
#import "Pair.h"
#import "Grid.h"
#import "UnitMenu.h"

@implementation UnitMenuLayer

- (id) init
{
	if ((self = [super init])) {
		
		[[GameManager gameManager] registerUnitMenuLayer:self];
		
		rangeSprite_ = [[CCSprite spriteWithFile:@"green_circle.png"] retain];		
		rangeSprite_.visible = NO;
		[self addChild:rangeSprite_];
		
		unitClicked_ = NO;
		unitMenu_ = nil;		
		
	}
	return self;
}

- (void) dealloc
{
	[rangeSprite_ release];
	[unitMenu_ release];
	
	[super dealloc];
}

- (void) rangeOn:(Pair *)pos
{
	rangeSprite_.position = [[Grid grid] gridToPixel:pos];
	rangeSprite_.visible = YES;
}

- (void) rangeOff
{
	rangeSprite_.visible = NO;
}

- (void) toggleUnit:(Pair *)pos withRange:(BOOL)range
{
	// Turn things off
	if (unitClicked_) {
		[unitMenu_ toggleButtons:NO];
		if (range) {
			[self rangeOff];
		}
		unitClicked_ = NO;
	}
	// Turn things on
	else {
		if (unitMenu_) {
			[unitMenu_ removeFromParentAndCleanup:YES];
			[unitMenu_ release];
		}
		
		if (range) {
			[self rangeOn:pos];
		}
		
		NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:4];
		CCMenuItemImage *m1 = [CCMenuItemImage itemFromNormalImage:@"Icon-Small.png" selectedImage:@"Icon-Small.png" target:self selector:nil]; 
		[m1 setIsEnabled:NO];
		[buttons addObject:m1];		
		
		/*
		CCMenuItemImage *m2 = [CCMenuItemImage itemFromNormalImage:@"Icon-Small.png" selectedImage:@"Icon-Small.png" target:self selector:nil]; 
		[m2 setIsEnabled:NO];
		[buttons addObject:m2];				
		*/
		
		unitMenu_ = [[UnitMenu unitMenuWithHUDButtons:buttons] retain];	
		unitMenu_.position = [[Grid grid] gridToPixel:pos];		
		[self addChild:unitMenu_];	
		
		[unitMenu_ toggleButtons:NO];	
		unitClicked_ = YES;
	}	
}

@end
