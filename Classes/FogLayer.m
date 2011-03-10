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

- (void) drawCircleAt:(CGPoint)origin radius:(NSUInteger)radius a:(unsigned char)a map:(NSMutableDictionary *)map
{
	NSInteger x, y;
	CGFloat resolution = [self calculateResolution:radius];
	
	for (double t = 0; t < 2*M_PI; t += resolution) {
		x = origin.x + radius*cos(t);
		y = origin.y + radius*sin(t);
		[map setObject:[NSNumber numberWithUnsignedChar:a] forKey:[Pair pair:x second:y]];
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
	
	double t1 = [[NSDate date] timeIntervalSinceDate:ref];
	NSLog(@"Filled circle done in: %4.9f seconds", t1);	
}

- (void) drawOpacityGradientAt:(CGPoint)origin innerR:(NSUInteger)innerR outerR:(NSUInteger)outerR innerT:(NSUInteger)innerT outerT:(NSUInteger)outerT texture:(CCMutableTexture2D *)texture
{
	NSDate *ref = [NSDate date];	
	ccColor4B c = ccc4(0,0,0,0);
	CGFloat radiusRange = outerR - innerR;
	CGFloat opacityRange = outerT - innerT;
	int count = 0;
	
	for (int i = innerR; i < outerR; i++) {
		
		c.a = innerT + (int)(opacityRange*(count++/radiusRange));
		[self drawCircleAt:origin radius:i color:c texture:texture];
	}
	
	double t1 = [[NSDate date] timeIntervalSinceDate:ref];
	NSLog(@"Calculated opacity gradient in: %4.9f seconds", t1);		
}

- (void) drawOpacityGradientAt:(CGPoint)origin innerR:(NSUInteger)innerR outerR:(NSUInteger)outerR innerT:(NSUInteger)innerT outerT:(NSUInteger)outerT map:(NSMutableDictionary *)map
{
	NSDate *ref = [NSDate date];	
	unsigned char a;
	CGFloat radiusRange = outerR - innerR;
	CGFloat opacityRange = outerT - innerT;
	int count = 0;
	
	for (int i = innerR; i < outerR; i++) {
		
		a = innerT + (int)(opacityRange*(count++/radiusRange));
		[self drawCircleAt:origin radius:i a:a map:map];
	}
	
	double t1 = [[NSDate date] timeIntervalSinceDate:ref];
	NSLog(@"Calculated opacity gradient in: %4.9f seconds", t1);		
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

- (void) drawFilledBresenhamCircleAt:(CGPoint)origin radius:(NSUInteger)radius a:(unsigned char)a map:(NSMutableDictionary *)map
{	
	int x0 = origin.x;
	int y0 = origin.y;
	int f = 1 - radius;
	int ddF_x = 1;
	int ddF_y = -2 * radius;
	int x = 0;
	int y = radius;
	
	[map setObject:[NSNumber numberWithUnsignedChar:a] forKey:[Pair pair:x0 second:(y0 + radius)]];
	[map setObject:[NSNumber numberWithUnsignedChar:a] forKey:[Pair pair:x0 second:(y0 - radius)]];	
	[self drawHorizontalLine:(x0 - radius) x2:(x0 + radius) y:y0 a:a map:map];
	
	int c =0;
	while(x < y)
	{
		//NSLog(@"inFillBCircle:%d", c++);
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
		[self drawHorizontalLine:(x0 - x) x2:(x0 + x) y:(y0 + y) a:a map:map];
		[self drawHorizontalLine:(x0 - x) x2:(x0 + x) y:(y0 - y) a:a map:map];
		[self drawHorizontalLine:(x0 - y) x2:(x0 + y) y:(y0 + x) a:a map:map];
		[self drawHorizontalLine:(x0 - y) x2:(x0 + y) y:(y0 - x) a:a map:map];		
	}
}

- (void) drawFilledBresenhamCircleAt:(CGPoint)origin radius:(NSUInteger)radius color:(ccColor4B)color texture:(CCMutableTexture2D *)texture
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
}

- (void) drawSpotlight:(CGPoint)origin radius:(NSUInteger)radius
{
	NSDate *ref2 = [NSDate date];	
	
	NSUInteger xStart = origin.x - radius;
	NSUInteger xEnd = origin.x + radius;
	NSUInteger yStart = origin.y - radius;
	NSUInteger yEnd = origin.y + radius;
	
	NSDate *ref = [NSDate date];	
	CCMutableTexture2D *blank = [[CCTexture2DMutable alloc] initWithImage:[UIImage imageNamed:@"black_frame.png"]];
	NSLog(@"Setting blank takes %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);			
	
	int gradientWidth = 40;
	ccColor4B p1, p2;
	ccColor4B clear = ccc4(0,0,0,0);
	
	// Draw the main circle with no gradient
	[self drawFilledBresenhamCircleAt:origin radius:radius-gradientWidth color:clear texture:blank];
	// Draw the outer gradient ring
	[self drawOpacityGradientAt:origin innerR:radius-gradientWidth outerR:radius innerT:0 outerT:255 texture:blank];
	
	ref = [NSDate date];	
	for (int i = xStart; i <= xEnd; i++) {
		for (int j = yStart; j <= yEnd; j++) {
			p1 = [mutableFog_ pixelAt:ccp(i,j)];
			p2 = [blank pixelAt:ccp(i,j)];
			p1.a = 255 * (p1.a/255.0f) * (p2.a/255.0f);
			[mutableFog_ setPixelAt:ccp(i,j) rgba:p1];			
		}
	}
	/*
	for (int i = 0; i < mutableFog_.pixelsHigh; i++) {
		for (int j = 0; j < mutableFog_.pixelsWide; j++) {
			p1 = [mutableFog_ pixelAt:ccp(i,j)];
			p2 = [blank pixelAt:ccp(i,j)];
			p1.a = 255 * (p1.a/255.0f) * (p2.a/255.0f);
			[mutableFog_ setPixelAt:ccp(i,j) rgba:p1];
		}
	}*/
	NSLog(@"Alpha multiplying takes %4.9f seconds", [[NSDate date] timeIntervalSinceDate:ref]);		
	[self updateFog];
	
	
	double t1 = [[NSDate date] timeIntervalSinceDate:ref2];
	NSLog(@"Spotlight drawn in: %4.9f seconds", t1);			
}

- (void) drawSpotlight2:(CGPoint)origin radius:(NSUInteger)radius
{
	NSDate *ref = [NSDate date];	
	int gradientWidth = 40;
	ccColor4B clear = ccc4(0,0,0,0);
	NSMutableDictionary *changedPixels = [NSMutableDictionary dictionaryWithCapacity:1000];
	
	// Draw the main circle with no gradient
	[self drawFilledBresenhamCircleAt:origin radius:radius-gradientWidth a:0 map:changedPixels];
	// Draw the outer gradient ring
	//[self drawOpacityGradientAt:origin innerR:radius-gradientWidth outerR:radius innerT:0 outerT:255 map:changedPixels];
	
	NSEnumerator *enumerator = [changedPixels keyEnumerator];
	
	for (Pair *p in enumerator) {
		clear.a = [[changedPixels objectForKey:p] unsignedCharValue];
		[mutableFog_ setPixelAt:ccp(p.x, p.y) rgba:clear];
	}
	
	[self updateFog];
	
	double t1 = [[NSDate date] timeIntervalSinceDate:ref];
	NSLog(@"Spotlight 2 drawn in: %4.9f seconds", t1);			
}

- (void) drawHorizontalLine:(NSInteger)x1 x2:(NSInteger)x2 y:(NSInteger)y color:(ccColor4B)color texture:(CCMutableTexture2D *)texture
{
	for (int i = x1; i <= x2; i++) {
		[texture setPixelAt:ccp(i,y) rgba:color];
	}
}

- (void) drawHorizontalLine:(NSInteger)x1 x2:(NSInteger)x2 y:(NSInteger)y a:(unsigned char)a map:(NSMutableDictionary *)map
{
	for (int i = x1; i <= x2; i++) {
		[map setObject:[NSNumber numberWithUnsignedChar:a] forKey:[Pair pair:i second:y]];
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
	
	[super dealloc];
}

@end
