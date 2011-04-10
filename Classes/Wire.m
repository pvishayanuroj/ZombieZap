//
//  Wire.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Wire.h"
#import "Pair.h"
#import "Grid.h"
#import "ElectricGrid.h"
#import "Enums.h"

@implementation Wire

@synthesize delegate = delegate_;
@synthesize gridPos = gridPos_;
@synthesize hasPower = hasPower_;

+ (id) wireWithPos:(Pair *)pos delegate:(id <WireDelegate>)d
{
	return [[[self alloc] initWireWithPos:pos delegate:d] autorelease];
}

- (id) initWireWithPos:(Pair *)pos delegate:(id <WireDelegate>)d
{
	if ((self = [super init])) {
		
		gridPos_ = [pos retain];
		
		Grid *grid = [Grid grid];
		
		sprite_ = [[self updateSpriteOrientation] retain];
		
		// Add sprite and position it
		[self addChild:sprite_];		
		CGPoint startCoord = [grid gridToPixel:pos];
		self.position = startCoord;
		
		hasPower_ = NO;
		delegate_ = d;

	}
	return self;
}

- (void) updateNeighbors
{
	ElectricGrid *eGrid = [ElectricGrid electricGrid];
	
	// Let adjacent wires know that their neighbor has been updated
	if ((wireType_ & W_UP) == W_UP) {
		[eGrid updateWireAtGrid:[gridPos_ topPair]];
	}
	if ((wireType_ & W_DOWN) == W_DOWN) {
		[eGrid updateWireAtGrid:[gridPos_ bottomPair]];			
	}
	if ((wireType_ & W_LEFT) == W_LEFT) {						
		[eGrid updateWireAtGrid:[gridPos_ leftPair]];			
	}
	if ((wireType_ & W_RIGHT) == W_RIGHT) {						
		[eGrid updateWireAtGrid:[gridPos_ rightPair]];			
	}		
}

- (CCSprite *) updateSpriteOrientation
{
	CCSprite *s;
	ElectricGrid *eGrid = [ElectricGrid electricGrid];
	
	wireType_ = 0;
	int connections = 0;
	
	// Check if there are any wires adjacent to this one
	if ([eGrid wireAtGrid:[gridPos_ topPair]]) {
		wireType_ |= W_UP;
		connections++;			
	}
	if ([eGrid wireAtGrid:[gridPos_ bottomPair]]) {
		wireType_ |= W_DOWN;			
		connections++;			
	}
	if ([eGrid wireAtGrid:[gridPos_ leftPair]]) {
		wireType_ |= W_LEFT;	
		connections++;						
	}
	if ([eGrid wireAtGrid:[gridPos_ rightPair]]) {
		wireType_ |= W_RIGHT;	
		connections++;						
	}		
	
	// Thru wire
	if (connections < 2) {
		s = [CCSprite spriteWithFile:@"wire_thru.png"];			
		
		if (wireType_ == W_LEFT || wireType_ == W_RIGHT) {
			s.rotation = 90;
		}
	}
	// Could be a thru wire or a corner wire
	else if (connections == 2) {
		if (wireType_ == (W_UP | W_DOWN)) {
			s = [CCSprite spriteWithFile:@"wire_thru.png"];			
		}
		else if (wireType_ == (W_RIGHT | W_LEFT)) {
			s =[CCSprite spriteWithFile:@"wire_thru.png"];			
			s.rotation = 90;
		}
		// Corner wire
		else {
			s = [CCSprite spriteWithFile:@"wire_corner.png"];			
			switch (wireType_) {
				case (W_DOWN | W_RIGHT):
					break;
				case (W_DOWN | W_LEFT):
					s.rotation = 90;
					break;
				case (W_UP | W_LEFT):
					s.rotation = 180;
					break;
				case (W_UP | W_RIGHT):
					s.rotation = -90;
					break;
				default:
					NSAssert(NO, @"Invalid 'corner' wire type");
			}
		}
	}
	// Tee wire
	else if (connections == 3) {
		s = [CCSprite spriteWithFile:@"wire_tee.png"];			
		switch (wireType_) {
			case (W_UP | W_DOWN | W_RIGHT):
				break;
			case (W_UP | W_DOWN | W_LEFT):
				s.rotation = 180;
				break;
			case (W_LEFT | W_RIGHT | W_UP):
				s.rotation = -90;
				break;
			case (W_LEFT | W_RIGHT | W_DOWN):
				s.rotation = 90;
				break;
			default:
				NSAssert(NO, @"Invalid 'tee' wire type");
		}
	}
	// Intersection wire
	else {
		s = [CCSprite spriteWithFile:@"wire_cross.png"];
	}
	
	return s;
}

- (void) updateWireOrientation
{
	[self removeChild:sprite_ cleanup:YES];
	[sprite_ release];
	
	sprite_ = [[self updateSpriteOrientation] retain];
	[self addChild:sprite_];
}
			
- (void) powerOn
{
	hasPower_ = YES;
	if (delegate_) {
		[delegate_ powerOn];
	}
}

- (void) powerOff
{
	hasPower_ = NO;
	if (delegate_) {
		[delegate_ powerOff];
	}	
}

- (void) dealloc
{
	NSLog(@"Wire dealloc'd");
	
	[sprite_ release];
	[gridPos_ release];
	[super dealloc];
}

@end
