//
//  PButton.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 1/23/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "PButton.h"
#import "Grid.h"
#import "Pair.h"
#import "GameManager.h"
#import "BuildLayer.h"

@implementation PButton

+ (id) pButton:(NSString *)buttonImage placementImage:(NSString *)placementImage buttonType:(BuildButtonType)buttonType
{
	return [[[self alloc] initPButton:buttonImage placementImage:placementImage buttonType:buttonType] autorelease];		
}

- (id) initPButton:(NSString *)buttonImage placementImage:(NSString *)placementImage buttonType:(BuildButtonType)buttonType
{
	if ((self = [super init])) {

		buttonType_ = buttonType;
		
		placementSprite_ = [[CCSprite spriteWithSpriteFrameName:placementImage] retain];		
		placementAdded_ = NO;
		
		allowable_ = NO;
		
		sprite_ = [CCSprite spriteWithFile:buttonImage];
		[self addChild:sprite_];		
	}
	return self;
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

- (BOOL) containsTouchLocation:(UITouch *)touch
{
	CGRect r = sprite_.textureRect;	
	r = CGRectMake(sprite_.position.x - r.size.width / 2, sprite_.position.y - r.size.height / 2, r.size.width, r.size.height);	
	
	return CGRectContainsPoint(r, [self convertTouchToNodeSpaceAR:touch]);
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if (![self containsTouchLocation:touch])
		return NO;
	
	return YES;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	if (!placementAdded_) {
		[self addChild:placementSprite_];
		placementAdded_ = YES;
	}
	
	// Touchpoint is relative to the node
	CGPoint touchPoint = [self convertTouchToNodeSpace:touch];
	
	// Convert from node to local screen space
	CGPoint localPoint = [self convertToWorldSpace:touchPoint];

	// Show the build grid and returns whether or not we're allowed to build there
	allowable_ = [(BuildLayer *)self.parent buildGridAtPos:localPoint];	
	
	// Returns the closest grid in local space
	CGPoint gridPixel = [[Grid grid] localPixelToLocalGridPixel:localPoint];
	CGPoint pos = [self convertToNodeSpace:gridPixel];
	placementSprite_.position = pos;
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{	
	[self removeChild:placementSprite_ cleanup:YES];
	placementAdded_ = NO;
	
	[(BuildLayer *)self.parent buildGridOff];	
	
	if (allowable_) {
		CGPoint touchPoint = [self convertTouchToNodeSpace:touch];
		CGPoint worldPoint = [self convertToWorldSpace:touchPoint];
	
		Pair *p = [[Grid grid] localPixelToWorldGrid:worldPoint];
		[self buildAction:p];
	}
}

- (void) buildAction:(Pair *)location
{
	switch (buttonType_) {
		case B_WIRE:
			[[GameManager gameManager] addWireWithPos:location];
			break;
		case B_LIGHT:
			[[GameManager gameManager] addLightWithPos:location];
			break;
		case B_TASER:
			[[GameManager gameManager] addTurretWithPos:location];			
			break;
		default:
			break;
	}
}

- (void) dealloc
{	
	[placementSprite_ release];
	
	[super dealloc];
}

@end
