//
//  EyesLayer.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 4/8/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "EyesLayer.h"
#import "GameManager.h"

@implementation EyesLayer

- (id) init
{
	if ((self = [super init])) {
		
		[[GameManager gameManager] registerEyesLayer:self];
		
	}
	return self;
}

- (void) dealloc
{	
	[super dealloc];
}

@end
