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

#import "Debugging.h"

@implementation FogLayer

@synthesize mutableFog = mutableFog_;

- (id) init
{
	if ((self = [super init])) {
				
		[[GameManager gameManager] registerFogLayer:self];
		
		fog_ = [[CCSprite spriteWithFile:@"black_frame_trans.png"] retain];
		fog_.anchorPoint = ccp(0, 0);			
		[self addChild:fog_];		
		
		areLightsOff_ = NO;
		
#if DEBUG_NOFOG
		mutableFog_ = [[[CCTexture2DMutable alloc] initWithImage:[UIImage imageNamed:@"black_frame_notrans.png"]] retain];
		lightsOn_ = [[[CCTexture2DMutable alloc] initWithImage:[UIImage imageNamed:@"black_frame_notrans.png"]] retain];
		lightsOff_ = [[[CCTexture2DMutable alloc] initWithImage:[UIImage imageNamed:@"black_frame_notrans.png"]] retain];		
#else
		mutableFog_ = [[[CCTexture2DMutable alloc] initWithImage:[UIImage imageNamed:@"black_frame_trans.png"]] retain];
		lightsOn_ = [[[CCTexture2DMutable alloc] initWithImage:[UIImage imageNamed:@"black_frame_trans.png"]] retain];		
		lightsOff_ = [[[CCTexture2DMutable alloc] initWithImage:[UIImage imageNamed:@"black_frame_trans.png"]] retain];				
#endif
		tempTexture_ = [[[MutableTextureExtension alloc] initWithImage:[UIImage imageNamed:@"black_frame.png"]] retain];
		fogAlpha_ = [mutableFog_ alphaAt:CGPointZero];
		//NSLog(@"fog alpha: %d (%1.2f)", fogAlpha_, fogAlpha_/255.0f);
		
		// Precalculate all alpha multiplications
		for (int i = 0; i < 256; i++) {
			for (int j = 0; j < 256; j++) {
				alphaTable_[i][j] = 255 * (i/255.0f) * (j/255.0f);				
			}
		}
		
		// Precompute what pixels a single spotlight will affect
		CGPoint origin = CGPointMake(SPOTLIGHT_RADIUS, SPOTLIGHT_RADIUS);
		[Spotlight spotlight:origin radius:SPOTLIGHT_RADIUS texture:tempTexture_];
		for (int i = 0; i <= (SPOTLIGHT_RADIUS * 2); i++) {
			for (int j = 0; j <= (SPOTLIGHT_RADIUS * 2); j++) {
				//NSLog(@"(%d,%d)", i, j);
				spotlightTable_[i][j] = [tempTexture_ alphaAt:ccp(i,j)];
			}
		}
	}
	return self;
}

- (Spotlight *) drawPrecomputedSpotlight:(CGPoint)origin
{
	NSDate *ref = [NSDate date];		
	GLubyte a1, a2, a3;
	
	// Precalculate the box of what pixels will be changed - this greatly speeds up spotlight creation
	NSInteger xStart = origin.x - SPOTLIGHT_RADIUS;
	NSInteger xEnd = origin.x + SPOTLIGHT_RADIUS;
	NSInteger yStart = origin.y - SPOTLIGHT_RADIUS;
	NSInteger yEnd = origin.y + SPOTLIGHT_RADIUS;
	NSInteger xOffset = xStart;
	NSInteger yOffset = yStart;
	xStart = xStart < 0 ? 0 : xStart;
	xEnd = xEnd > 1023 ? 1023 : xEnd; 
	yStart = yStart < 0 ? 0 : yStart;	
	yEnd = yEnd > 1023 ? 1023 : yEnd;
	
	// Use the precomputed alpha values to determine how the spotlight would change the alpha values
	for (int i = xStart; i <= xEnd; i++) {
		for (int j = yStart; j <= yEnd; j++) {
			a2 = spotlightTable_[i-xOffset][j-yOffset];		
			if (a2 != 255) {
				// Get the original alpha
				a1 = [mutableFog_ alphaAt:ccp(i,j)];
				// Do the multiplication using precomputed values
				a3 = alphaTable_[a1][a2];
				[mutableFog_ setAlphaAt:ccp(i,j) a:a3];			
				[lightsOn_ setAlphaAt:ccp(i,j) a:a3];
			}
		}
	}
	
	Spotlight *s = [Spotlight spotlight:origin radius:SPOTLIGHT_RADIUS];
	
	[lightsOn_ apply];
	[self updateFog];
	
	NSLog(@"Spotlight drawn in: %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);	
	return s;
}
										 
- (Spotlight *) drawSpotlight:(CGPoint)origin radius:(NSUInteger)radius
{
	// If the radius matches that which precomputed for
	if (radius == SPOTLIGHT_RADIUS) {
		return [self drawPrecomputedSpotlight:origin];
	}
	
	NSDate *ref = [NSDate date];	
	unsigned char a1, a2, a3;	
	
	// Precalculate the box of what pixels will be changed - this greatly speeds up spotlight creation
	NSInteger xStart = origin.x - radius;
	NSInteger xEnd = origin.x + radius;
	NSInteger yStart = origin.y - radius;
	NSInteger yEnd = origin.y + radius;
	xStart = xStart < 0 ? 0 : xStart;
	xEnd = xEnd > 1023 ? 1023 : xEnd; 
	yStart = yStart < 0 ? 0 : yStart;	
	yEnd = yEnd > 1023 ? 1023 : yEnd;	
	
	NSDate *ref3 = [NSDate date];	
	Spotlight *spotlight = [Spotlight spotlight:origin radius:radius texture:tempTexture_];
	NSLog(@"Spotlight init takes %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref3]);				

	//NSDate *ref2 = [NSDate date];	
	for (int i = xStart; i <= xEnd; i++) {
		for (int j = yStart; j <= yEnd; j++) {
			a2 = [tempTexture_ alphaAt:ccp(i,j)];
			if (a2 != 255) {
				a1 = [mutableFog_ alphaAt:ccp(i,j)];
				a3 = alphaTable_[a1][a2];
				[mutableFog_ setAlphaAt:ccp(i,j) a:a3];					
				[lightsOn_ setAlphaAt:ccp(i,j) a:a3];				
			}
		}
	}
	
	//NSLog(@"Alpha multiplying takes %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref2]);		
	[self updateFog];	
	
	NSLog(@"Spotlight drawn in: %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);
	
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
	NSInteger xStart = spotlight.position.x - spotlight.radius;
	NSInteger xEnd = spotlight.position.x + spotlight.radius;
	NSInteger yStart = spotlight.position.y - spotlight.radius;
	NSInteger yEnd = spotlight.position.y + spotlight.radius;
	
	for (int i = xStart; i <= xEnd; i++) {
		for (int j = yStart; j <= yEnd; j++) {
			[mutableFog_ setAlphaAt:ccp(i,j) a:fogAlpha_];			
		}
	}
	
	GLubyte a1, a2;
	// Redraw those spotlights
	for (Spotlight *s in affectedLights) {

		int xOffset = s.position.x - s.radius;
		int yOffset = s.position.y - s.radius;
		int xE = xOffset + s.radius*2 + 1;
		int yE = yOffset + s.radius*2 + 1;
		
		// Go through each spotlight's list of affected pixels, since we have those already		
		for (int x = xOffset; x < xE; x++) {
			for (int y = yOffset; y < yE; y++) {
				// Only redraw the pixels that are in the removed spotlight's box
				if (x >= xStart && x <= xEnd && y >= yStart && y <= yEnd) {
					a2 = spotlightTable_[x-xOffset][y-yOffset];
					if (a2 != 255) {
						a1 = [mutableFog_ alphaAt:ccp(x,y)];
						[mutableFog_ setAlphaAt:ccp(x,y) a:alphaTable_[a1][a2]];
					}
				}
			}
		}
		
		/*
		int count = 0;
		int xOffset = s.pixelsOffset.x;
		int xE = xOffset + s.pixelsYSize;
		int yOffset = s.pixelsOffset.y;		
		int yE = yOffset + s.pixelsYSize;
		
		// Go through each spotlight's list of affected pixels, since we have those already		
		for (int x = xOffset; x < xE; x++) {
			for (int y = yOffset; y < yE; y++) {
				// Only redraw the pixels that are in the removed spotlight's box
				if (x >= xStart && x <= xEnd && y >= yStart && y <= yEnd && s.pixels[count] != 255) {
					a1 = [mutableFog_ alphaAt:ccp(x, y)];
					a2 = 255 * (a1/255.0f) * (s.pixels[count]/255.0f);			
					[mutableFog_ setAlphaAt:ccp(x, y) a:a2];					
				}
				count++;
			}
		}
		 */
	}
	
	[self updateFog];
	
	NSLog(@"Spotlight removed in: %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);			
}

- (void) off
{
	NSDate *ref = [NSDate date];		
	
	[self removeChild:fog_ cleanup:YES];
	fog_ = [CCSprite spriteWithTexture:lightsOff_];
	fog_.anchorPoint = ccp(0, 0);				
	[self addChild:fog_];	
	
	areLightsOff_ = YES;
	
	NSLog(@"Lights off in: %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);	
}

- (void) on
{
	NSDate *ref = [NSDate date];	

	[self removeChild:fog_ cleanup:YES];
	fog_ = [CCSprite spriteWithTexture:lightsOn_];
	fog_.anchorPoint = ccp(0, 0);				
	[self addChild:fog_];			
	
	areLightsOff_ = NO;
	
	NSLog(@"Lights on in: %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);		
}

- (BOOL) isPointLit:(CGPoint)pt
{
	// If lights are off, then definitely not lit
	if (areLightsOff_) {
		return NO;
	}
	// Otherwise compare against alpha
	return [mutableFog_ alphaAt:pt] < fogAlpha_;
	
}

- (void) redAlert
{
	
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
	[lightsOn_ release];
	[lightsOff_ release];
	[tempTexture_ release];
	
	[super dealloc];
}

@end
