//
//  MutableTextureExtension.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/11/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "MutableTextureExtension.h"


@implementation MutableTextureExtension

- (CGFloat) calculateResolution:(NSUInteger)radius
{
	// There's probably some formula for this, but I have no idea, so will just do some testing.
	// Acceptable resolution for the follow radii are:
	// R = 20, res = 0.01f
	// R = 60, res = 0.005f
	return 0.001f;
}

- (void) drawCircleAt:(CGPoint)origin radius:(NSUInteger)radius color:(ccColor4B)color
{
	NSInteger x, y;
	CGFloat resolution = [self calculateResolution:radius];
	
	for (double t = 0; t < 2*M_PI; t += resolution) {
		x = origin.x + radius*cos(t);
		y = origin.y + radius*sin(t);
		[self setPixelAt:ccp(x,y) rgba:color];
	}		
}

- (void) drawCircleAt:(CGPoint)origin radius:(NSUInteger)radius alpha:(GLubyte)alpha
{
	NSInteger x, y;
	CGFloat resolution = [self calculateResolution:radius];
	
	for (double t = 0; t < 2*M_PI; t += resolution) {
		x = origin.x + radius*cos(t);
		y = origin.y + radius*sin(t);
		[self setAlphaAt:ccp(x,y) a:alpha];
	}		
}

- (void) drawFilledCircleAt:(CGPoint)origin radius:(NSUInteger)r
{
	//NSDate *ref = [NSDate date];	
	ccColor4B c = ccc4(0,0,0,0);
	
	for (int i = 0; i < r; i++) {
		
		int t = 255 - 20*(r-i);
		if (t > 0) {
			c.a = t;
		}
		
		[self drawCircleAt:origin radius:i color:c];
	}
	
	//NSLog(@"Filled circle done in: %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);	
}

- (void) drawOpacityGradientAt:(CGPoint)origin innerR:(NSUInteger)innerR outerR:(NSUInteger)outerR innerT:(GLubyte)innerT outerT:(GLubyte)outerT
{
	//NSDate *ref = [NSDate date];	
	ccColor4B c = ccc4(0,0,0,0);
	CGFloat radiusRange = outerR - innerR;
	CGFloat opacityRange = outerT - innerT;
	int count = 0;
	
	for (int i = innerR; i < outerR; i++) {
		c.a = innerT + (int)(opacityRange*(count++/radiusRange));
		[self drawCircleAt:origin radius:i alpha:c.a];
	}
	
	//NSLog(@"Calculated opacity gradient in: %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);		
}

- (void) drawBresenhamCircleAt:(CGPoint)origin radius:(NSUInteger)radius color:(ccColor4B)color
{
	int x0 = origin.x;
	int y0 = origin.y;
	int f = 1 - radius;
	int ddF_x = 1;
	int ddF_y = -2 * radius;
	int x = 0;
	int y = radius;
	
	[self setPixelAt:ccp(x0, y0 + radius) rgba:color];	
	[self setPixelAt:ccp(x0, y0 - radius) rgba:color];	
	[self setPixelAt:ccp(x0 + radius, y0) rgba:color];	
	[self setPixelAt:ccp(x0 - radius, y0) rgba:color];	
	
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
		[self setPixelAt:ccp(x0 + x, y0 + y) rgba:color];
		[self setPixelAt:ccp(x0 - x, y0 + y) rgba:color];			
		[self setPixelAt:ccp(x0 + x, y0 - y) rgba:color];			
		[self setPixelAt:ccp(x0 - x, y0 - y) rgba:color];			
		[self setPixelAt:ccp(x0 + y, y0 + x) rgba:color];			
		[self setPixelAt:ccp(x0 - y, y0 + x) rgba:color];			
		[self setPixelAt:ccp(x0 + y, y0 - x) rgba:color];			
		[self setPixelAt:ccp(x0 - y, y0 - x) rgba:color];			
	}
}

- (void) drawFilledBresenhamCircleAt:(CGPoint)origin radius:(NSUInteger)radius color:(ccColor4B)color
{	
	//NSDate *ref = [NSDate date];	
	int x0 = origin.x;
	int y0 = origin.y;
	int f = 1 - radius;
	int ddF_x = 1;
	int ddF_y = -2 * radius;
	int x = 0;
	int y = radius;
	
	[self setPixelAt:ccp(x0, y0 + radius) rgba:color];	
	[self setPixelAt:ccp(x0, y0 - radius) rgba:color];		
	[self drawHorizontalLine:(x0 - radius) x2:(x0 + radius) y:y0 color:color];
	
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
		[self drawHorizontalLine:(x0 - x) x2:(x0 + x) y:(y0 + y) color:color];
		[self drawHorizontalLine:(x0 - x) x2:(x0 + x) y:(y0 - y) color:color];
		[self drawHorizontalLine:(x0 - y) x2:(x0 + y) y:(y0 + x) color:color];
		[self drawHorizontalLine:(x0 - y) x2:(x0 + y) y:(y0 - x) color:color];
	}
	
	//NSLog(@"Drew filled Bresenham circle in: %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);		
}

- (void) drawFilledBresenhamCircleAt:(CGPoint)origin radius:(NSUInteger)radius alpha:(GLubyte)alpha
{	
	//NSDate *ref = [NSDate date];	
	int x0 = origin.x;
	int y0 = origin.y;
	int f = 1 - radius;
	int ddF_x = 1;
	int ddF_y = -2 * radius;
	int x = 0;
	int y = radius;
	
	[self setAlphaAt:ccp(x0, y0 + radius) a:alpha];	
	[self setAlphaAt:ccp(x0, y0 - radius) a:alpha];		
	[self drawHorizontalLine:(x0 - radius) x2:(x0 + radius) y:y0 alpha:alpha];
	
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
		[self drawHorizontalLine:(x0 - x) x2:(x0 + x) y:(y0 + y) alpha:alpha];
		[self drawHorizontalLine:(x0 - x) x2:(x0 + x) y:(y0 - y) alpha:alpha];
		[self drawHorizontalLine:(x0 - y) x2:(x0 + y) y:(y0 + x) alpha:alpha];
		[self drawHorizontalLine:(x0 - y) x2:(x0 + y) y:(y0 - x) alpha:alpha];
	}
	
	//NSLog(@"Drew filled Bresenham circle in: %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);		
}

- (void) drawHorizontalLine:(NSInteger)x1 x2:(NSInteger)x2 y:(NSInteger)y color:(ccColor4B)color
{
	for (int i = x1; i <= x2; i++) {
		[self setPixelAt:ccp(i,y) rgba:color];
	}
}

- (void) drawHorizontalLine:(NSInteger)x1 x2:(NSInteger)x2 y:(NSInteger)y alpha:(GLubyte)alpha
{
	for (int i = x1; i <= x2; i++) {
		[self setAlphaAt:ccp(i,y) a:alpha];
	}
}

- (void) dealloc
{
	[super dealloc];
}

@end
