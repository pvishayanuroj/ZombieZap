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

@synthesize placementSpriteDrawOffset = placementSpriteDrawOffset_;

+ (id) pButton:(NSString *)buttonImage placementImage:(NSString *)placementImage buttonType:(BuildButtonType)buttonType
{
	return [[[self alloc] initPButton:buttonImage placementImage:placementImage buttonType:buttonType] autorelease];		
}

+ (id) pButton:(NSString *)buttonImage placementImage:(NSString *)placementImage toggledImage:(NSString *)toggledImage buttonType:(BuildButtonType)buttonType
{
	return [[[self alloc] initPButton:buttonImage placementImage:placementImage toggledImage:toggledImage buttonType:buttonType] autorelease];
}

- (id) initPButton:(NSString *)buttonImage placementImage:(NSString *)placementImage buttonType:(BuildButtonType)buttonType
{
	if ((self = [super init])) {

		buttonType_ = buttonType;
		
		placementSprite_ = [[CCSprite spriteWithSpriteFrameName:placementImage] retain];
		placementSpriteDrawOffset_ = CGPointZero;
		placementAdded_ = NO;
		
		allowable_ = NO;
		
		sprite_ = [[CCSprite spriteWithFile:buttonImage] retain];
		[self addChild:sprite_ z:0 tag:kCurrentSprite];		
	}
	return self;
}

- (id) initPButton:(NSString *)buttonImage placementImage:(NSString *)placementImage toggledImage:(NSString *)toggledImage buttonType:(BuildButtonType)buttonType
{
	if ((self = [self initPButton:buttonImage placementImage:placementImage buttonType:buttonType])) {
			
		toggledSprite_ = [[CCSprite spriteWithFile:toggledImage] retain];
		
	}
	return self;
}

- (void) onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:kTouchPriorityPButton swallowsTouches:YES];
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

	if (buttonType_ == B_TEST1) {
		[[GameManager gameManager] turnLightsOff];
		return NO;
	}
	else if (buttonType_ == B_TEST2) {
		[[GameManager gameManager] turnLightsOn];
		return NO;
	}
	
	return YES;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	// Don't show the single placement sprite when dealing with wires
	if (buttonType_ != B_WIRE) {
		
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
		
		// Account for the draw offset
		placementSprite_.position = ccpAdd(placementSprite_.position, placementSpriteDrawOffset_);
	}
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{	
	// For all non-wire buttons
	if (buttonType_ != B_WIRE) {
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
	// Else this is a wire button
	else {
		// If button was pressed, toggle the wire
		if ([self containsTouchLocation:touch]) {	
			[self changeToToggled];
			[(BuildLayer *)self.parent toggleWirePlacement:self];	
		}
	}
}

- (void) changeToToggled
{
	[self removeChildByTag:kCurrentSprite cleanup:YES];
	[self addChild:toggledSprite_ z:0 tag:kCurrentSprite];
}

- (void) changeToNormal
{
	[self removeChildByTag:kCurrentSprite cleanup:YES];
	[self addChild:sprite_ z:0 tag:kCurrentSprite];	
}

- (void) buildAction:(Pair *)location
{
	switch (buttonType_) {
		case B_WIRE:
			[[GameManager gameManager] turnLightsOn];
			[[GameManager gameManager] addWireWithPos:location];
			break;
		case B_LIGHT:
			[[GameManager gameManager] addLightWithPos:location radius:SPOTLIGHT_RADIUS];
			break;
		case B_TASER:
			[[GameManager gameManager] addTurretType:@"Tesla" withPos:location level:1];			
			break;
		case B_GUN:
			[[GameManager gameManager] addTurretType:@"Gun" withPos:location level:1];			
			break;
		case B_LASER:
			[[GameManager gameManager] addTurretType:@"Laser" withPos:location level:1];			
			break;            
		default:
			break;
	}
}

- (void) dealloc
{	
	[sprite_ release];
	[placementSprite_ release];
	[toggledSprite_ release];
	
	[super dealloc];
}

@end
