//
//  Damage.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/16/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Damage.h"

@implementation Damage

- (void) finish
{		
	// Remove ourself from the game layer
	[self removeFromParentAndCleanup:YES];
	
	//NSLog(@"%@ RC: %d\n", self, [self retainCount]);	
}

@end
