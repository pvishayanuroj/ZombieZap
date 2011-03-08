//
//  FogLayer.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/8/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "FogLayer.h"
#import "CCTexture2DMutable.h"

@implementation FogLayer

- (id) init
{
	if ((self = [super init])) {
		
		//CCTexture2DMutable *mutableTexture = [[[CCTexture2DMutable alloc] initWithImage:[UIImage imageNamed:@"Icon.png"]] autorelease];
		
		fog_ = [[CCSprite spriteWithFile:@"black_frame.png"] retain];
		fog_.anchorPoint = ccp(0, 0);			
		[self addChild:fog_];		
	}
	return self;
}

- (void) drawCircle
{
	CGFloat a = 100;
	CGFloat b = 900;
	CGFloat r = 20;
	NSInteger x, y;
	
	ccColor4B red = ccc4(255,0,0,255);
	
	CCTexture2DMutable *mutableTexture = [[[CCTexture2DMutable alloc] initWithImage:[UIImage imageNamed:@"black_frame.png"]] autorelease];
	/*
	for (int i = 0; i < 800; i++) {
		for (int j = 0; j < 800; j++) {
			[mutableTexture setPixelAt:ccp(i,j) rgba:red];
		}
	}*/
	
	
	
	for (double t = 0; t < 2*M_PI; t+=0.01) {
		x = a + r*cos(t);
		y = b + r*sin(t);

		BOOL set = [mutableTexture setPixelAt:ccp(x,y) rgba:red];
		NSLog(@"Set (%d,%d) %d", x, y, set);		
	}	
	
	[mutableTexture apply];
	
	[self removeChild:fog_ cleanup:YES];
	fog_ = [CCSprite spriteWithTexture:mutableTexture];
		fog_.anchorPoint = ccp(0, 0);				
	[self addChild:fog_];
}

@end
