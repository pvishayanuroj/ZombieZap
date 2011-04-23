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

@synthesize delegate = delegate_;

- (id) init
{
	if ((self = [super init])) {
		
		[[GameManager gameManager] registerUnitMenuLayer:self];
		
		rangeSprite_ = [[CCSprite spriteWithFile:@"green_circle.png"] retain];		
		rangeSprite_.visible = NO;
		[self addChild:rangeSprite_];
		
		unitMenu_ = nil;		
		delegate_ = nil;
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

- (void) toggleOn:(Pair *)pos withRange:(BOOL)range withDelegate:(id <UnitMenuLayerDelegate>)d
{	
	if (unitMenu_) {
		[self forceToggleOff];
		[unitMenu_ removeFromParentAndCleanup:YES];
		[unitMenu_ release];
		unitMenu_ = nil;
	}
	
	if (range) {
		[self rangeOn:pos];
	}
	
	delegate_ = d;
	NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:4];
	CCMenuItemImage *m1 = [CCMenuItemImage itemFromNormalImage:@"Icon-Small.png" selectedImage:@"Icon-Small.png" target:self selector:@selector(sell)]; 
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
	
	[unitMenu_ toggleButtonsOnWithAnimation:NO];	
}

- (void) forceToggleOff
{	
	if (delegate_) {
		[delegate_ menuClosed];
	}
	
	[self toggleOff];	
}

- (void) toggleOff
{
	[unitMenu_ toggleButtonsOffWithAnimation:NO];
	[self rangeOff];
	delegate_ = nil;
}

- (void) sell
{
	if (delegate_) {
		[delegate_ unitSold];
	}
	
	[self toggleOff];
}

@end
