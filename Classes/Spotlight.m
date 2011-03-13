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

+ (id) spotlight:(CGPoint)pos radius:(CGFloat)radius texture:(MutableTextureExtension *)texture
{
	return [[[self alloc] initSpotlight:pos radius:radius texture:texture] autorelease];
}

- (id) initSpotlight:(CGPoint)pos radius:(CGFloat)radius texture:(MutableTextureExtension *)texture
{
	if ((self = [super init])) {

		radius_ = radius;
		position_ = pos;
		NSUInteger xStart = pos.x - radius;
		NSUInteger xEnd = pos.x + radius;
		NSUInteger yStart = pos.y - radius;
		NSUInteger yEnd = pos.y + radius;
		pixelsOffset_ = CGPointMake(xStart, yStart);
		pixelsYSize_ = (yEnd - yStart + 1);
		pixelsSize_ = (xEnd - xStart + 1) * pixelsYSize_;
		//NSLog(@"x:%d-%d, y:%d-%d, size=%d", xStart, xEnd, yStart, yEnd, pixelsSize_);
		pixels_ = malloc(sizeof(unsigned char) * pixelsSize_);
		
		for (int i = 0; i < pixelsSize_; i++) {
			pixels_[i] = 255;
		}
		
		int gradientWidth = (int)radius*0.25f;
		
		//NSDate *ref = [NSDate date];
		// Draw the main circle with no gradient
		[texture drawFilledBresenhamCircleAt:pos radius:radius-gradientWidth alpha:0];
		//NSLog(@"Main circle filling takes %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);			
		
		//NSDate *ref2 = [NSDate date];		
		// Draw the outer gradient ring
		[texture drawOpacityGradientAt:pos innerR:radius-gradientWidth outerR:radius innerT:0 outerT:255];
		//NSLog(@"Gradient drawing takes %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref2]);				
	}
	return self;
}

- (void) addPixel:(CGPoint)pos alpha:(GLubyte)alpha
{
	CGPoint offsetPos = CGPointMake(pos.x - pixelsOffset_.x, pos.y - pixelsOffset_.y);
	NSUInteger index = offsetPos.y * pixelsYSize_ + offsetPos.x;

	NSAssert(index < pixelsSize_, ([NSString stringWithFormat:@"Array size: %d, trying to access index %d", pixelsSize_, index]));
	
	pixels_[index] = alpha;
}

- (void) dealloc 
{
	free(pixels_);
	
	[super dealloc];
}

@end
