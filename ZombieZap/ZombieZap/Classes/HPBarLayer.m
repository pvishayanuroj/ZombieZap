//
//  HPBarLayer.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/23/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "HPBarLayer.h"
#import "GameManager.h"

@implementation HPBarLayer

- (id) init
{
	if ((self = [super init])) {
		
		[[GameManager gameManager] registerHPBarLayer:self];
		
	}
	return self;
}

- (void) dealloc
{	
	[super dealloc];
}

@end
