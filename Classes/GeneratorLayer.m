//
//  GeneratorLayer.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 1/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "GeneratorLayer.h"
#import "Generator.h"

@implementation GeneratorLayer

- (id) init
{
	if ((self = [super init])) {
		
		self.isTouchEnabled = YES;
		generator = [Generator generator];
		[self addChild:generator];
		generator.position = CGPointMake(70, 250);
		
	}
	return self;
}

@end
