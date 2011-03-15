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

@implementation PButton

+ (id) pButton:(NSString *)buttonImage placementImage:(NSString *)placementImage buttonType:(BuildButtonType)buttonType
{
	return [[[self alloc] initPButton:buttonImage placementImage:placementImage buttonType:buttonType] autorelease];		
}

- (id) initPButton:(NSString *)buttonImage placementImage:(NSString *)placementImage buttonType:(BuildButtonType)buttonType
{
	if ((self = [super init])) {

		buttonType_ = buttonType;
		
		placementSprite_ = [[CCSprite spriteWithFile:placementImage] retain];		
		placementAdded_ = NO;
		
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
	
	CGPoint point = [self convertTouchToNodeSpaceAR:touch];
	//NSLog(@"gen Touch location @(%4f, %4f)", point.x, point.y);	
	
	placementSprite_.position = point;
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{	
	[self removeChild:placementSprite_ cleanup:YES];
	placementAdded_ = NO;
	
	CGPoint touchPoint = [self convertTouchToNodeSpace:touch];
	touchPoint = [self convertToWorldSpace:touchPoint];
	//NSLog(@"Built @(%3f, %3f)", point.x, point.y);
	CGPoint gameOffset = [[[GameManager gameManager] gameLayer] position];
	//NSLog(@"Game offset: (%3f, %3f)", gameOffset.x, gameOffset.y);
	
	CGPoint pos = CGPointMake(touchPoint.x - gameOffset.x, touchPoint.y - gameOffset.y);
	
	Pair *location = [[Grid grid] gridCoordinateAtMapCoordinate:pos];

	[self buildAction:location];
}

- (void) buildAction:(Pair *)location
{
	switch (buttonType_) {
		case B_WIRE:
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
