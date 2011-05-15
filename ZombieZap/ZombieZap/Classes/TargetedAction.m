//
//  TargetedAction.m
//  PrototypeZero
//
//  Created by Paul Vishayanuroj on 2/6/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "TargetedAction.h"


@implementation TargetedAction

+ (id) actionWithTarget:(id)target actionIn:(CCFiniteTimeAction *) daction
{
	return [[[self alloc] initWithTarget:target actionIn:daction] autorelease];
}

- (id) initWithTarget:(id)targetIn actionIn:(CCFiniteTimeAction *)actionIn
{
	if(nil != (self = [super initWithDuration:actionIn.duration]))
	{
		forcedTarget = [targetIn retain];
		action_ = [actionIn retain];
	}
	return self;
}

- (void) dealloc
{
	[forcedTarget release];
	[action_ release];
	[super dealloc];
}

- (void) startWithTarget:(id)aTarget
{
	[super startWithTarget:forcedTarget];
	[action_ startWithTarget:forcedTarget];
}

- (void) stop
{
	[action_ stop];
	[super stop];
}

- (void) update:(ccTime) time
{
	[action_ update:time];
}

@end
