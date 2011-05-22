//
//  Spawn.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/6/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Spawn.h"
#import "Pair.h"
#import "GameManager.h"
#import "Grid.h"

@implementation Spawn

@synthesize startPos = startPos_;
@synthesize objective = objective_;

+ (id) spawn:(CGFloat)interval location:(Pair *)location obj:(Pair *)obj pathNum:(NSUInteger)pathNum
{
	return [[[self alloc] initSpawn:interval location:location obj:obj pathNum:pathNum] autorelease];
}

- (id) initSpawn:(CGFloat)interval location:(Pair *)location obj:(Pair *)obj pathNum:(NSUInteger)pathNum
{
	if ((self = [super init])) {
		
        // Make sure the path number exists at the start location
        NSUInteger val = [[[[Grid grid] terrain] objectForKey:location] unsignedIntegerValue];
        
        NSAssert((val & pathNum) == pathNum, ([NSString stringWithFormat:@"Path number %d does not exist at %@", pathNum, location]));
        
		startPos_ = [location retain];
		objective_ = [obj retain];
		[self schedule:@selector(update:) interval:interval];			
		
	}
	return self;
}

- (void) update:(ccTime)dt
{
	[[GameManager gameManager] addZombieWithPos:startPos_ obj:objective_];
}

- (void) dealloc
{
	[startPos_ release];
	[objective_ release];
	
	[super dealloc];
}

@end
