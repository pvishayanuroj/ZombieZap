//
//  Tower.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 4/8/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Tower.h"
#import "Grid.h"

@implementation Tower

@synthesize isDead = isDead_;
@synthesize gridPos = gridPos_;

- (id) initTowerWithPos:(Pair *)startPos
{
	if ((self = [super init])) {
		
		Grid *grid = [Grid grid];
		CGPoint startCoord = [grid gridToPixel:startPos];
		self.position = startCoord;
		gridPos_ = startPos;
		[gridPos_ retain];
	
		hasPower_ = NO;
		isDead_ = NO;		
		isToggled_ = NO;
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

- (CGRect) rect
{
	CGRect r = sprite_.textureRect;
	return CGRectMake(sprite_.position.x - r.size.width / 2, sprite_.position.y - r.size.height / 2, r.size.width, r.size.height);
}

- (BOOL) containsTouchLocation:(UITouch *)touch
{	
	return CGRectContainsPoint([self rect], [self convertTouchToNodeSpaceAR:touch]);
}

// This must be implemented in the subclass. At this level, always return no
- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return NO;
}

- (void) takeDamage:(CGFloat)damage
{
	
}

@end
