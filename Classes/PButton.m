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

+ (id) pButton
{
	return [[[self alloc] initPButton] autorelease];		
}

- (id) initPButton
{
	if ((self = [super init])) {
		
		sprite = [[CCSprite spriteWithFile:@"small_icon.png"] retain];
		[self addChild:sprite];
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
	CGRect r = sprite.textureRect;	
	r = CGRectMake(sprite.position.x - r.size.width / 2, sprite.position.y - r.size.height / 2, r.size.width, r.size.height);	
	
	return CGRectContainsPoint(r, [self convertTouchToNodeSpaceAR:touch]);
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if (![self containsTouchLocation:touch])
		return NO;
	
	NSLog(@"button touch began");
	
	return YES;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	if (placementSprite == nil) {
		placementSprite = [[CCSprite spriteWithFile:@"small_icon.png"] retain];
		[self addChild:placementSprite];
	}
	
	CGPoint point = [self convertTouchToNodeSpaceAR:touch];
	//NSLog(@"gen Touch location @(%4f, %4f)", point.x, point.y);	
	
	placementSprite.position = point;
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{	
	[self removeChild:placementSprite cleanup:YES];
	[placementSprite release];
	placementSprite = nil;
	
	CGPoint touchPoint = [self convertTouchToNodeSpace:touch];
	touchPoint = [self convertToWorldSpace:touchPoint];
	//NSLog(@"Built @(%3f, %3f)", point.x, point.y);
	CGPoint gameOffset = [[[GameManager gameManager] gameLayer] position];
	//NSLog(@"Game offset: (%3f, %3f)", gameOffset.x, gameOffset.y);
	
	CGPoint pos = CGPointMake(touchPoint.x - gameOffset.x, touchPoint.y - gameOffset.y);
	
	Pair *location = [[Grid grid] gridCoordinateAtMapCoordinate:pos];
	//NSLog(@"Build @%@", location);
	[[GameManager gameManager] addTurretWithPos:location];
}

- (void) dealloc
{
	[sprite release];
	
	[super dealloc];
}

@end
