//
//  FogLayer.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/8/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "FogLayer.h"
#import "CCTexture2DMutable.h"
#import "MutableTextureExtension.h"
#import "Pair.h"
#import "Triplet.h"
#import "GameManager.h"
#import "Spotlight.h"

@implementation FogLayer

- (id) init
{
	if ((self = [super init])) {
				
		[[GameManager gameManager] registerFogLayer:self];
		
		fog_ = [[CCSprite spriteWithFile:@"black_frame_trans.png"] retain];
		fog_.anchorPoint = ccp(0, 0);			
		[self addChild:fog_];		
		
		mutableFog_ = [[[CCTexture2DMutable alloc] initWithImage:[UIImage imageNamed:@"black_frame_trans.png"]] retain];
		tempTexture_ = [[[MutableTextureExtension alloc] initWithImage:[UIImage imageNamed:@"black_frame.png"]] retain];
		fogAlpha_ = [mutableFog_ alphaAt:CGPointZero];
		changedAlphas_ = [[NSMutableArray arrayWithCapacity:1000] retain];
		NSLog(@"fog alpha: %d (%1.2f)", fogAlpha_, fogAlpha_/255.0f);
	}
	return self;
}

- (Spotlight *) drawSpotlight:(CGPoint)origin radius:(NSUInteger)radius
{
	NSDate *ref = [NSDate date];	
	unsigned char a1, a2, a3;	
	
	// Precalculate the box of what pixels will be changed - this greatly speeds up spotlight creation
	NSUInteger xStart = origin.x - radius;
	NSUInteger xEnd = origin.x + radius;
	NSUInteger yStart = origin.y - radius;
	NSUInteger yEnd = origin.y + radius;

	for (int i = xStart; i <= xEnd; i++) {
		for (int j = yStart; j <= yEnd; j++) {
			[tempTexture_ setAlphaAt:ccp(i,j) a:255];			
		}
	}
	
	Spotlight *spotlight = [Spotlight spotlight:origin radius:radius texture:tempTexture_];

	//NSDate *ref2 = [NSDate date];	
	for (int i = xStart; i <= xEnd; i++) {
		for (int j = yStart; j <= yEnd; j++) {
			a2 = [tempTexture_ alphaAt:ccp(i,j)];
			if (a2 != 255) {
				a1 = [mutableFog_ alphaAt:ccp(i,j)];
				a3 = 255 * (a1/255.0f) * (a2/255.0f);
				[mutableFog_ setAlphaAt:ccp(i,j) a:a3];			
				[changedAlphas_ addObject:[Pair pair:i second:j]];		
				[spotlight addPixel:ccp(i,j) alpha:a2];
			}
		}
	}
	//NSLog(@"Alpha multiplying takes %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref2]);		
	[self updateFog];
	
	
	double t1 = [[NSDate date] timeIntervalSinceDate:ref];
	NSLog(@"Spotlight drawn in: %4.9f seconds", t1);
	
	return spotlight;
}

- (void) removeSpotlight:(Spotlight *)spotlight
{
	NSDate *ref = [NSDate date];	
	
	NSMutableArray *affectedLights = [NSMutableArray arrayWithCapacity:5];
	CGFloat limitDist;
	
	// Figure out which spotlight's areas may be affected by the removal of this spotlight	
	for (Spotlight *s in [[GameManager gameManager] spotlights]) {
		limitDist = s.radius + spotlight.radius;
		if (ccpDistance(s.position, spotlight.position) <= limitDist) {
			[affectedLights	addObject:s];
		}
	}

	// Calculate the box to zero out
	NSUInteger xStart = spotlight.position.x - spotlight.radius;
	NSUInteger xEnd = spotlight.position.x + spotlight.radius;
	NSUInteger yStart = spotlight.position.y - spotlight.radius;
	NSUInteger yEnd = spotlight.position.y + spotlight.radius;
	
	for (int i = xStart; i <= xEnd; i++) {
		for (int j = yStart; j <= yEnd; j++) {
			[mutableFog_ setAlphaAt:ccp(i,j) a:fogAlpha_];			
		}
	}
	
	GLubyte a1, a2;
	// Redraw those spotlights
	for (Spotlight *s in affectedLights) {
		// Go through each spotlight's list of affected pixels, since we have those already
		for (Triplet *t in s.pixels) {
			// Make sure we're inside the original box of the removed spotlight
			if (t.x >= xStart && t.x <= xEnd && t.y >= yStart && t.x <= yEnd) {
				a1 = [mutableFog_ alphaAt:ccp(t.x, t.y)];
				a2 = 255 * (a1/255.0f) * (t.z/255.0f);			
				[mutableFog_ setAlphaAt:ccp(t.x, t.y) a:a2];
			}
		}
	}
	
	[self updateFog];
	
	double t1 = [[NSDate date] timeIntervalSinceDate:ref];
	NSLog(@"Spotlight removed in: %4.9f seconds", t1);			
}

- (void) off
{
	for (Pair *p in changedAlphas_) {
		[mutableFog_ setAlphaAt:ccp(p.x, p.y) a:fogAlpha_];
	}
	
	[self updateFog];
}

- (CGRect) getSpotlightBox:(CGPoint)pos radius:(CGFloat)radius
{
	NSUInteger xStart = pos.x - radius;
	NSUInteger xEnd = pos.x + radius;
	NSUInteger yStart = pos.y - radius;
	NSUInteger yEnd = pos.y + radius;
	
	return CGRectMake(xStart, yStart, xEnd, yEnd);
}
	 
- (void) updateFog
{
	[mutableFog_ apply];
	
	[self removeChild:fog_ cleanup:YES];
	fog_ = [CCSprite spriteWithTexture:mutableFog_];
	fog_.anchorPoint = ccp(0, 0);				
	[self addChild:fog_];		
}

- (void) dealloc
{
	[fog_ release];
	[mutableFog_ release];
	[tempTexture_ release];
	[changedAlphas_ release];
	
	[super dealloc];
}

@end
