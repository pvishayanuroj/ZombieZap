//
//  Quad.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Quad.h"


@implementation Quad

@synthesize x = x_;
@synthesize y = y_;
@synthesize z = z_;
@synthesize w = w_;

+ (id) quad:(NSInteger)a b:(NSInteger)b c:(NSInteger)c d:(NSInteger)d
{
	return [[[self alloc] initQuad:a b:b c:c d:d] autorelease];
}

- (id) initQuad:(NSInteger)a b:(NSInteger)b c:(NSInteger)c d:(NSInteger)d
{
	if ((self = [super init])) {
		
		x_ = a;
		y_ = b;
		z_ = c;
		w_ = d;
		
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

@end
