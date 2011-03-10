//
//  FogLayer.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/8/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "FogLayer.h"
#import "CCTexture2DMutable.h"
#import "Pair.h"

@implementation FogLayer

- (id) init
{
	if ((self = [super init])) {
				
		fog_ = [[CCSprite spriteWithFile:@"black_frame.png"] retain];
		fog_.anchorPoint = ccp(0, 0);			
		[self addChild:fog_];		
		
		mutableFog_ = [[[CCTexture2DMutable alloc] initWithImage:[UIImage imageNamed:@"black_frame.png"]] retain];
		blackFrame_ = [[[CCTexture2DMutable alloc] initWithImage:[UIImage imageNamed:@"black_frame.png"]] retain];
		tempTexture_ = [[[CCTexture2DMutable alloc] initWithImage:[UIImage imageNamed:@"black_frame.png"]] retain];
	}
	return self;
}

- (CGFloat) calculateResolution:(NSUInteger)radius
{
	// There's probably some formula for this, but I have no idea, so will just do some testing.
	// Acceptable resolution for the follow radii are:
	// R = 20, res = 0.01f
	// R = 60, res = 0.005f
	return 0.001f;
}

- (void) drawCircleAt:(CGPoint)origin radius:(NSUInteger)radius color:(ccColor4B)color texture:(CCMutableTexture2D *)texture
{
	NSInteger x, y;
	CGFloat resolution = [self calculateResolution:radius];
		
	for (double t = 0; t < 2*M_PI; t += resolution) {
		x = origin.x + radius*cos(t);
		y = origin.y + radius*sin(t);
		[texture setPixelAt:ccp(x,y) rgba:color];
	}		
}

- (void) drawCircleAt:(CGPoint)origin radius:(NSUInteger)radius alpha:(unsigned char)alpha texture:(CCMutableTexture2D *)texture
{
	NSInteger x, y;
	CGFloat resolution = [self calculateResolution:radius];
	
	for (double t = 0; t < 2*M_PI; t += resolution) {
		x = origin.x + radius*cos(t);
		y = origin.y + radius*sin(t);
		[texture setAlphaAt:ccp(x,y) a:alpha];
	}		
}

- (void) drawFilledCircleAt:(CGPoint)origin radius:(NSUInteger)r texture:(CCMutableTexture2D *)texture
{
	ccColor4B c = ccc4(0,0,0,0);
	
	NSDate *ref = [NSDate date];
	
	for (int i = 0; i < r; i++) {
		
		int t = 255 - 20*(r-i);
		if (t > 0) {
			c.a = t;
		}
		
		[self drawCircleAt:origin radius:i color:c texture:texture];
	}
	
	NSLog(@"Filled circle done in: %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);	
}

- (void) drawOpacityGradientAt:(CGPoint)origin innerR:(NSUInteger)innerR outerR:(NSUInteger)outerR innerT:(NSUInteger)innerT outerT:(NSUInteger)outerT texture:(CCMutableTexture2D *)texture
{
	//NSDate *ref = [NSDate date];	
	ccColor4B c = ccc4(0,0,0,0);
	CGFloat radiusRange = outerR - innerR;
	CGFloat opacityRange = outerT - innerT;
	int count = 0;
	
	for (int i = innerR; i < outerR; i++) {
		
		c.a = innerT + (int)(opacityRange*(count++/radiusRange));
		[self drawCircleAt:origin radius:i alpha:c.a texture:texture];
	}
	
	//NSLog(@"Calculated opacity gradient in: %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);		
}

- (void) drawOpacityGradientAt2:(CGPoint)origin innerR:(NSUInteger)innerR outerR:(NSUInteger)outerR innerT:(NSUInteger)innerT outerT:(NSUInteger)outerT texture:(CCMutableTexture2D *)texture
{
	//NSDate *ref = [NSDate date];	
	ccColor4B c = ccc4(0,0,0,0);
	CGFloat radiusRange = outerR - innerR;
	CGFloat opacityRange = outerT - innerT;
	int count = 0;
	
	for (int i = innerR; i < outerR; i++) {
		
		c.a = innerT + (int)(opacityRange*(count++/radiusRange));
		[self drawCircleAt:origin radius:i color:c texture:texture];
	}
	
	//NSLog(@"Calculated opacity gradient in: %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);		
}

- (void) drawBresenhamCircleAt:(CGPoint)origin radius:(NSUInteger)radius color:(ccColor4B)color texture:(CCMutableTexture2D *)texture
{
	int x0 = origin.x;
	int y0 = origin.y;
	int f = 1 - radius;
	int ddF_x = 1;
	int ddF_y = -2 * radius;
	int x = 0;
	int y = radius;
	
	[texture setPixelAt:ccp(x0, y0 + radius) rgba:color];	
	[texture setPixelAt:ccp(x0, y0 - radius) rgba:color];	
	[texture setPixelAt:ccp(x0 + radius, y0) rgba:color];	
	[texture setPixelAt:ccp(x0 - radius, y0) rgba:color];	

	while(x < y)
	{
		// ddF_x == 2 * x + 1;
		// ddF_y == -2 * y;
		// f == x*x + y*y - radius*radius + 2*x - y + 1;
		if(f >= 0) 
		{
			y--;
			ddF_y += 2;
			f += ddF_y;
		}
		x++;
		ddF_x += 2;
		f += ddF_x;    
		[texture setPixelAt:ccp(x0 + x, y0 + y) rgba:color];
		[texture setPixelAt:ccp(x0 - x, y0 + y) rgba:color];			
		[texture setPixelAt:ccp(x0 + x, y0 - y) rgba:color];			
		[texture setPixelAt:ccp(x0 - x, y0 - y) rgba:color];			
		[texture setPixelAt:ccp(x0 + y, y0 + x) rgba:color];			
		[texture setPixelAt:ccp(x0 - y, y0 + x) rgba:color];			
		[texture setPixelAt:ccp(x0 + y, y0 - x) rgba:color];			
		[texture setPixelAt:ccp(x0 - y, y0 - x) rgba:color];			
	}
}

- (void) drawFilledBresenhamCircleAt:(CGPoint)origin radius:(NSUInteger)radius color:(ccColor4B)color texture:(CCMutableTexture2D *)texture
{	
	//NSDate *ref = [NSDate date];	
	int x0 = origin.x;
	int y0 = origin.y;
	int f = 1 - radius;
	int ddF_x = 1;
	int ddF_y = -2 * radius;
	int x = 0;
	int y = radius;
	
	[texture setPixelAt:ccp(x0, y0 + radius) rgba:color];	
	[texture setPixelAt:ccp(x0, y0 - radius) rgba:color];		
	[self drawHorizontalLine:(x0 - radius) x2:(x0 + radius) y:y0 color:color texture:texture];
	
	while(x < y)
	{
		// ddF_x == 2 * x + 1;
		// ddF_y == -2 * y;
		// f == x*x + y*y - radius*radius + 2*x - y + 1;
		if(f >= 0) 
		{
			y--;
			ddF_y += 2;
			f += ddF_y;
		}
		x++;
		ddF_x += 2;
		f += ddF_x;    
		[self drawHorizontalLine:(x0 - x) x2:(x0 + x) y:(y0 + y) color:color texture:texture];
		[self drawHorizontalLine:(x0 - x) x2:(x0 + x) y:(y0 - y) color:color texture:texture];
		[self drawHorizontalLine:(x0 - y) x2:(x0 + y) y:(y0 + x) color:color texture:texture];
		[self drawHorizontalLine:(x0 - y) x2:(x0 + y) y:(y0 - x) color:color texture:texture];		
	}
	
	//NSLog(@"Drew filled Bresenham circle in: %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);		
}

- (void) drawFilledBresenhamCircleAt:(CGPoint)origin radius:(NSUInteger)radius alpha:(unsigned char)alpha texture:(CCMutableTexture2D *)texture
{	
	//NSDate *ref = [NSDate date];	
	int x0 = origin.x;
	int y0 = origin.y;
	int f = 1 - radius;
	int ddF_x = 1;
	int ddF_y = -2 * radius;
	int x = 0;
	int y = radius;
	
	[texture setAlphaAt:ccp(x0, y0 + radius) a:alpha];	
	[texture setAlphaAt:ccp(x0, y0 - radius) a:alpha];		
	[self drawHorizontalLine:(x0 - radius) x2:(x0 + radius) y:y0 alpha:alpha texture:texture];
	
	while(x < y)
	{
		// ddF_x == 2 * x + 1;
		// ddF_y == -2 * y;
		// f == x*x + y*y - radius*radius + 2*x - y + 1;
		if(f >= 0) 
		{
			y--;
			ddF_y += 2;
			f += ddF_y;
		}
		x++;
		ddF_x += 2;
		f += ddF_x;    
		[self drawHorizontalLine:(x0 - x) x2:(x0 + x) y:(y0 + y) alpha:alpha texture:texture];
		[self drawHorizontalLine:(x0 - x) x2:(x0 + x) y:(y0 - y) alpha:alpha texture:texture];
		[self drawHorizontalLine:(x0 - y) x2:(x0 + y) y:(y0 + x) alpha:alpha texture:texture];
		[self drawHorizontalLine:(x0 - y) x2:(x0 + y) y:(y0 - x) alpha:alpha texture:texture];		
	}
	
	//NSLog(@"Drew filled Bresenham circle in: %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);		
}

- (void) drawSpotlight:(CGPoint)origin radius:(NSUInteger)radius
{
	NSDate *ref2 = [NSDate date];	
	
	// Precalculate the box of what pixels will be changed - this greatly speeds up spotlight creation
	NSUInteger xStart = origin.x - radius;
	NSUInteger xEnd = origin.x + radius;
	NSUInteger yStart = origin.y - radius;
	NSUInteger yEnd = origin.y + radius;
	
	//NSDate *ref = [NSDate date];	
	for (int i = xStart; i <= xEnd; i++) {
		for (int j = yStart; j <= yEnd; j++) {
			[tempTexture_ setAlphaAt:ccp(i,j) a:255];			
		}
	}
	//NSLog(@"Setting blank takes %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);			
	
	int gradientWidth = 40;
	unsigned char a1, a2;
	
	// Draw the main circle with no gradient
	[self drawFilledBresenhamCircleAt:origin radius:radius-gradientWidth alpha:0 texture:tempTexture_];
	
	// Draw the outer gradient ring
	[self drawOpacityGradientAt:origin innerR:radius-gradientWidth outerR:radius innerT:0 outerT:255 texture:tempTexture_];
	
	//ref = [NSDate date];	
	for (int i = xStart; i <= xEnd; i++) {
		for (int j = yStart; j <= yEnd; j++) {
			a1 = [mutableFog_ alphaAt:ccp(i,j)];
			a2 = [tempTexture_ alphaAt:ccp(i,j)];
			a1 = 255 * (a1/255.0f) * (a2/255.0f);
			[mutableFog_ setAlphaAt:ccp(i,j) a:a1];			
		}
	}
	//NSLog(@"Alpha multiplying takes %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);		
	[self updateFog];
	
	
	double t1 = [[NSDate date] timeIntervalSinceDate:ref2];
	NSLog(@"Spotlight drawn in: %4.9f seconds", t1);			
	NSLog(@"------ ");
}

- (void) drawSpotlight2:(CGPoint)origin radius:(NSUInteger)radius
{
	NSDate *ref2 = [NSDate date];	
	
	// Precalculate the box of what pixels will be changed - this greatly speeds up spotlight creation
	NSUInteger xStart = origin.x - radius;
	NSUInteger xEnd = origin.x + radius;
	NSUInteger yStart = origin.y - radius;
	NSUInteger yEnd = origin.y + radius;
	
	//NSDate *ref = [NSDate date];	
	CCMutableTexture2D *blank = [[CCTexture2DMutable alloc] initWithImage:[UIImage imageNamed:@"black_frame.png"]];
	//CCMutableTexture2D *blank = [blackFrame_ copy];
	//NSLog(@"Setting blank takes %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);			
	
	int gradientWidth = 40;
	//unsigned char a1, a2;
	ccColor4B clear = ccc4(0,0,0,0);
	ccColor4B a1, a2;
	
	// Draw the main circle with no gradient
	[self drawFilledBresenhamCircleAt:origin radius:radius-gradientWidth color:clear texture:blank];
	
	// Draw the outer gradient ring
	[self drawOpacityGradientAt2:origin innerR:radius-gradientWidth outerR:radius innerT:0 outerT:255 texture:blank];
	
	//ref = [NSDate date];	
	for (int i = xStart; i <= xEnd; i++) {
		for (int j = yStart; j <= yEnd; j++) {
			a1 = [mutableFog_ pixelAt:ccp(i,j)];
			a2 = [blank pixelAt:ccp(i,j)];
			a1.a = 255 * (a1.a/255.0f) * (a2.a/255.0f);
			[mutableFog_ setPixelAt:ccp(i,j) rgba:a1];			
		}
	}
	//NSLog(@"Alpha multiplying 2 takes %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);		
	[self updateFog];
	
	
	double t1 = [[NSDate date] timeIntervalSinceDate:ref2];
	NSLog(@"Spotlight 2 drawn in: %4.9f seconds", t1);			
}

- (void) drawHorizontalLine:(NSInteger)x1 x2:(NSInteger)x2 y:(NSInteger)y color:(ccColor4B)color texture:(CCMutableTexture2D *)texture
{
	for (int i = x1; i <= x2; i++) {
		[texture setPixelAt:ccp(i,y) rgba:color];
	}
}

- (void) drawHorizontalLine:(NSInteger)x1 x2:(NSInteger)x2 y:(NSInteger)y alpha:(unsigned char)alpha texture:(CCMutableTexture2D *)texture
{
	for (int i = x1; i <= x2; i++) {
		[texture setAlphaAt:ccp(i,y) a:alpha];
	}
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
	[blackFrame_ release];
	[tempTexture_ release];
	
	[super dealloc];
}

@end
