//
//  Triplet.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/11/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Triplet.h"


@implementation Triplet

@synthesize x = x_;
@synthesize y = y_;
@synthesize z = z_;

+ (id) triplet:(NSInteger)a b:(NSInteger)b c:(NSInteger)c
{
	return [[[self alloc] initTriplet:a b:b c:c] autorelease];
}

- (id) initTriplet:(NSInteger)a b:(NSInteger)b c:(NSInteger)c
{
	if ((self = [super init])) {
		
		x_ = a;
		y_ = b;
		z_ = c;
		
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

@end
