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
		
		genRateLabel_ = [[CCLabelAtlas labelWithString:@"0" charMapFile:@"fps_images.png" itemWidth:16 itemHeight:24 startCharMap:'.'] retain];		
		genRateLabel_.position = CGPointMake(390, 170);
		
		powerLabel_ = [[CCLabelTTF labelWithString:@"0 kWh (-0)" fontName:@"Marker Felt" fontSize:12] retain];
		powerLabel_.position = CGPointMake(230, 310);
		
		partsLabel_ = [[CCLabelTTF labelWithString:@"0 Parts" fontName:@"Marker Felt" fontSize:12] retain];
		partsLabel_.position = CGPointMake(150, 310);		
		
		[self addChild:genRateLabel_];
		[self addChild:powerLabel_];
		[self addChild:partsLabel_];
	}
	return self;
}

- (void) dealloc
{
	[genRateLabel_ release];
	[powerLabel_ release];
	[partsLabel_ release];
	
	[super dealloc];
}

- (void) setGeneratorSpeed:(CGFloat)speed
{
	NSString *s = [NSString stringWithFormat:@"%3.0f", speed*100];	
	[genRateLabel_ setString:s];	
}

- (void) setPower:(CGFloat)power powerDraw:(CGFloat)powerDraw
{
	NSString *s = [NSString stringWithFormat:@"%4.0f kWh (-%d)", power, (NSInteger)powerDraw];		
	[powerLabel_ setString:s];	
}

- (void) setParts:(NSInteger)parts
{
	NSString *s = [NSString stringWithFormat:@"%d Parts", parts];			
	[partsLabel_ setString:s];	
}


@end
