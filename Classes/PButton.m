//
//  PButton.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 1/23/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "PButton.h"


@implementation PButton

+ (id) pButton
{
	return [[[self alloc] initPButton] autorelease];		
}

- (id) initPButton
{
	if ((self = [super init])) {
		
		sprite = [[CCSprite spriteWithFile:@"Icon.png"] retain];
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
		placementSprite = [[CCSprite spriteWithFile:@"Icon.png"] retain];
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
}

- (void) dealloc
{
	[sprite release];
	
	[super dealloc];
}

@end
