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
		
		isDead_ = NO;		
	}
	return self;
}

- (void) takeDamage:(CGFloat)damage
{
}

@end
