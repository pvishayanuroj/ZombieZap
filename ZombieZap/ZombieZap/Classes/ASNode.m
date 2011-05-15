//
//  ASNode.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 2/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "ASNode.h"


@implementation ASNode

@synthesize f = f_;
@synthesize g = g_;
@synthesize h = h_;
@synthesize parent = parent_;

+ (id) ASNodeWithPair:(Pair *)pair
{
	return [[[self alloc] initASNode:pair.x yVal:pair.y g:0 parent:nil] autorelease];
}

+ (id) ASNodeWithValues:(NSInteger)xVal yVal:(NSInteger)yVal g:(NSUInteger)g parent:(ASNode *)parent
{
	return [[[self alloc] initASNode:xVal yVal:yVal g:g parent:parent] autorelease];
}

- (id) initASNode:(NSUInteger)xVal yVal:(NSUInteger)yVal g:(NSUInteger)g parent:(ASNode *)parent
{
	if ((self = [super initPair:xVal second:yVal])) {
		
		g_ = g;
		h_ = 0;
		f_ = 0;
		parent_ = parent;
		[parent_ retain];
	}
	return self;
}

- (BOOL) coordinatesEqual:(Pair *)pair
{
	return x == pair.x && y == pair.y;
}

- (void) setG:(NSUInteger)value
{
	g_ = value;
	f_ = g_ + h_;
}

- (void) setH:(NSUInteger)value
{
	h_ = value;
	f_ = g_ + h_;
}

- (void) dealloc
{
	[parent_ release];
	
	[super dealloc];
}

@end
