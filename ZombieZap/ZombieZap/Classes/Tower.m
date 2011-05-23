//
//  Tower.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 4/8/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Tower.h"
#import "Grid.h"
#import "GameManager.h"

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

- (void) dealloc
{
    [gridPos_ release];
    
	[super dealloc];
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
	NSAssert(HP_ >= 0, @"Tower is dead, should not be taking damage");
	
	// Subtract health points
	HP_ -= damage;
	
	// Turret dies from hit
	if (HP_ <= 0) {
		
		[self preTowerDeath];
	}
	// Tower just takes damage
	else {
		
	}	
}

- (void) menuClosed
{
	isToggled_ = NO;
}

- (void) unitSold
{
	[self preTowerDeath];
}

- (void) unitUpgraded
{
    [self preTowerDeath];
    [[GameManager gameManager] addTurretType:towerType_ withPos:gridPos_ level:techLevel_+1];
}

- (void) preTowerDeath
{
	// Make sure the menu is closed
	if (isToggled_) {
		[[GameManager gameManager] toggleUnitOff];				
		isToggled_ = NO;
	}	
	
	// Set ourselves to dead
	HP_ = 0;
	isDead_ = YES;
	
	sprite_.visible = NO;
	[[GameManager gameManager] removeWireWithPos:gridPos_];
	
	// Call death function only after a delay
	CCFiniteTimeAction *delay = [CCDelayTime actionWithDuration:1.0f];
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(towerDeath)];
	[self runAction:[CCSequence actions:delay, method, nil]];		
}

- (void) towerDeath
{	
	// Remove ourself from the game layer
	[self removeFromParentAndCleanup:YES];	
}

@end
