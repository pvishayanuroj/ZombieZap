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

+ (id) spotlight:(CGPoint)pos radius:(CGFloat)radius texture:(MutableTextureExtension *)texture
{
	return [[[self alloc] initSpotlight:pos radius:radius texture:texture] autorelease];
}

- (id) initSpotlight:(CGPoint)pos radius:(CGFloat)radius texture:(MutableTextureExtension *)texture
{
	if ((self = [super init])) {

		radius_ = radius;
		position_ = pos;
		pixels_ = [[NSMutableArray arrayWithCapacity:100] retain];
		
		int gradientWidth = (int)radius*0.33f;
		
		// Draw the main circle with no gradient
		[texture drawFilledBresenhamCircleAt:pos radius:radius-gradientWidth alpha:0];
		
		// Draw the outer gradient ring
		//[self drawOpacityGradientAt:origin innerR:radius-gradientWidth outerR:radius innerT:0 outerT:fogAlpha_ texture:tempTexture_];
		[texture drawOpacityGradientAt:pos innerR:radius-gradientWidth outerR:radius innerT:0 outerT:255];
	}
	return self;
}

- (void) addPixel:(CGPoint)pos alpha:(GLubyte)alpha
{
	[pixels_ addObject:[Triplet triplet:pos.x b:pos.y c:alpha]];
}

- (void) dealloc 
{
	[pixels_ release];
	
	[super dealloc];
}

@end
