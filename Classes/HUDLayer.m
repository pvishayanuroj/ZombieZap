//
//  HUDLayer.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/2/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "HUDLayer.h"
#import "GameManager.h"

@implementation HUDLayer

- (id) init
{
	if ((self = [super init])) {
		
		[self schedule:@selector(update:) interval:2.0/60.0];					
		
		genRateLabel_ = [[CCLabelAtlas labelWithString:@"0.0" charMapFile:@"fps_images.png" itemWidth:16 itemHeight:24 startCharMap:'.'] retain];		
		genRateLabel_.position = CGPointMake(390, 170);
		
		[self addChild:genRateLabel_];
	}
	return self;
}

- (void) dealloc
{
	[genRateLabel_ release];
	
	[super dealloc];
}

- (void) update:(ccTime)dt
{
	CGFloat speed = [[GameManager gameManager] getGeneratorSpeed];
	NSString *s = [NSString stringWithFormat:@"%3.0f", speed*100];
	[genRateLabel_ setString:s];
	
}

@end
