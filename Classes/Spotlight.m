//
//  Spotlight.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/11/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Spotlight.h"
#import "MutableTextureExtension.h"
#import "Triplet.h"

@implementation Spotlight

@synthesize pixels = pixels_;
@synthesize position = position_;
@synthesize radius = radius_;
@synthesize pixelsSize = pixelsSize_;
@synthesize pixelsYSize = pixelsYSize_;
@synthesize pixelsOffset = pixelsOffset_;

+ (id) spotlight:(CGPoint)pos radius:(CGFloat)radius
{
	return [[[self alloc] initSpotlight:pos radius:radius] autorelease];
}

+ (id) spotlight:(CGPoint)pos radius:(CGFloat)radius texture:(MutableTextureExtension *)texture
{
	return [[[self alloc] initSpotlight:pos radius:radius texture:texture] autorelease];
}

- (id) initSpotlight:(CGPoint)pos radius:(CGFloat)radius
{
	if ((self = [super init])) {
		pixels_ = NULL;
		radius_ = radius;
		position_ = pos;
	}
	return self;
}

- (id) initSpotlight:(CGPoint)pos radius:(CGFloat)radius texture:(MutableTextureExtension *)texture
{
	if ((self = [super init])) {
		radius_ = radius;
		position_ = pos;
		NSInteger xStart = pos.x - radius;
		NSInteger xEnd = pos.x + radius;
		NSInteger yStart = pos.y - radius;
		NSInteger yEnd = pos.y + radius;
		
		pixelsOffset_ = CGPointMake(xStart, yStart);
		pixelsYSize_ = (yEnd - yStart + 1);
		pixelsSize_ = (xEnd - xStart + 1) * pixelsYSize_;
		pixels_ = malloc(sizeof(unsigned char) * pixelsSize_);
		
		int c = 0;
		for (int i = xStart; i <= xEnd; i++) {
			for (int j = yStart; j <= yEnd; j++) {
				[texture setAlphaAt:ccp(i,j) a:255];			
				pixels_[c++] = 255;
			}
		}		
		
		int threshold = radius_*0.3f;
		texture.radiusSquared = radius_ * radius_;
		texture.thresholdSquared = threshold * threshold;
		texture.gradientRangeSquared = texture.radiusSquared - texture.thresholdSquared;
		texture.center = pos;
		
		//NSDate *ref = [NSDate date];
		
		// Draw circle
		[texture drawFilledBresenhamCircleAt:pos radius:radius alpha:0];
		//NSLog(@"Main circle filling takes %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);						
	}
	return self;
}

- (void) addPixel:(CGPoint)pos alpha:(GLubyte)alpha
{
	CGPoint offsetPos = ccpSub(pos, pixelsOffset_);
	NSUInteger index = offsetPos.y * pixelsYSize_ + offsetPos.x;

	NSAssert(index < pixelsSize_, ([NSString stringWithFormat:@"Array size: %d, trying to access index %d", pixelsSize_, index]));
	
	pixels_[index] = alpha;
}

- (void) dealloc 
{
	if (pixels_ != NULL) {
		free(pixels_);
	}
	
	[super dealloc];
}

@end
