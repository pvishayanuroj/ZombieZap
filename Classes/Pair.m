//
//  Pair.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 2/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Pair.h"


@implementation Pair

@synthesize x, y;

+ (id) pair
{
	return [[[self alloc] initPair:0 second:0] autorelease];
}

+ (id) pair:(NSInteger)a second:(NSInteger)b
{
	return [[[self alloc] initPair:a second:b] autorelease];
}

+ (id) pairWithPair:(Pair *)p
{
	return [[[self alloc] initPair:p.x second:p.y] autorelease];
}

+ (Pair *) addPair:(Pair *)a withPair:(Pair *)b
{
	return [Pair pair:(a.x+b.x) second:(a.y+b.y)];
}

+ (Pair *) subtractPair:(Pair *)a withPair:(Pair *)b
{
	return [Pair pair:(a.x-b.x) second:(a.y-b.y)];
}

/*
+ (Pair *) getDirectionFromPair:(Pair *)a toPair:(Pair *)b
{
	NSInteger tempX = b.x - a.x;
	NSInteger tempY = b.y - a.y;
	
	Pair *pair;
	
	if(tempX == 0) {
		if (tempY == 0) {
			pair = [Pair pair:0 second:0];
		}
		else {
			pair = [Pair pair:0 second:tempY/abs(tempY)];
		}
	}
	else if(tempY == 0) {
		pair = [Pair pair:tempX/abs(tempX) second:0];
	}
	else {
		CGFloat radian = atan(tempY/abs(tempX));
		
		if (radian <= RADIAN_DOWN_RIGHT_START) {
			// DOWN
			pair = [Pair pair:0 second:-1];
		}
		else if(radian <= RADIAN_RIGHT_START) {
			// DOWN RIGHT
			pair = [Pair pair:(tempX / abs(tempX)) second:-1];
			
		}
		else if(radian <= RADIAN_UP_RIGHT_START) {
			// RIGHT
			pair = [Pair pair:(tempX / abs(tempX)) second:0];
		}
		else if(radian <= RADIAN_UP_START) {
			// UP RIGHT
			pair = [Pair pair:(tempX / abs(tempX)) second:1];
		}
		else {
			// UP
			pair = [Pair pair:0 second:1];
		}
	}
	return pair;
}
*/

+ (CGFloat) getAngleFromPair:(Pair *)a b:(Pair *)b
{
	// Interesting note, floats can divide by zero
	CGFloat tempX = b.x - a.x;
	CGFloat tempY = b.y - a.y;
	
	CGFloat radians = atan(tempY/tempX);
	
	if (b.x < a.x)
		radians	+= M_PI;
	
	return radians;
}

+ (BOOL) pairsEqual:(Pair *)a withPair:(Pair *)b
{
	return (a.x == b.x && a.y == b.y);
}

+ (NSUInteger) manhattanDistance:(Pair *)a withPair:(Pair *)b
{
	return abs(a.x - b.x) + abs(a.y - b.y);
}

+ (CGFloat) euclideanDistance:(Pair *)a withPair:(Pair *)b
{
	return sqrt(((a.x-b.x) * (a.x-b.x)) + ((a.y-b.y) * (a.y-b.y)));
}

+ (NSUInteger) euclideanDistanceNoRoot:(Pair *)a withPair:(Pair *)b
{
	NSInteger t1 = a.x - b.x;
	NSInteger t2 = a.y - b.y;
	return t1*t1 + t2*t2;
}

+ (NSUInteger) boxDistance:(Pair *)a withPair:(Pair *)b
{
	NSUInteger t1 = abs(a.x - b.x);
	NSUInteger t2 = abs(a.y - b.y);
	
	if (t1 > t2 )
		return t1;
	else
		return t2;
}

- (id) initPair:(NSInteger)a second:(NSInteger)b
{
	if ((self = [super init]))
	{
		x = a;
		y = b;
	}
	return self;
}

- (void) addWithPair:(Pair *)p
{
	x += p.x;
	y += p.y;
}

- (void) subtractWithPair:(Pair *)p
{
	x -= p.x;
	y -= p.y;
}

- (void) invertPair
{
	x *= -1;
	y *= -1;
}

- (void) setEqualWith:(Pair *)p
{
	x = p.x;
	y = p.y;
}

- (NSUInteger) manhattanDistance:(Pair *)p
{
	return abs(x - p.x) + abs(y - p.y);	
}

- (id) copyWithZone: (NSZone *)zone
{
	Pair *pairCopy = [[Pair allocWithZone:zone] init];
	pairCopy.x = self.x;
	pairCopy.y = self.y;
	return pairCopy;
}

- (NSUInteger) hash
{
	// Not the best hash function, but it will do
	//NSUInteger hashNum = x + y;
	NSUInteger hashNum = 1024*x + y;
	return hashNum;	
}

- (BOOL) isEqual:(id)anObject
{
	if ([anObject isKindOfClass:[Pair class]]) {
		Pair *otherPair= (Pair *)anObject;
		return (self.x == otherPair.x && self.y == otherPair.y);
	}
	return NO;
}

// Override the description method to give us something more useful than a pointer address
- (NSString *) description
{
	return [NSString stringWithFormat:@"(%d, %d)", x, y];
}

- (void) dealloc
{
	[super dealloc];
}

@end

@implementation AStarPair

@synthesize g, h, parent;

+ (id) aStarPairWithPair:(Pair *)pair
{	
	return [[[self alloc] initAStarPair:pair.x second:pair.y] autorelease];
}

- (id) initAStarPair:(NSInteger)a second:(NSInteger)b
{
	if((self = [super initPair:a second:b])) {
		g = 0;
		h = 0;
	}
	return self;
}

- (NSUInteger) f
{
	return g + h;
}

- (id) copyWithZone: (NSZone *)zone
{
	AStarPair *aStarPairCopy = [[AStarPair allocWithZone:zone] init];
	aStarPairCopy.x = self.x;
	aStarPairCopy.y = self.y;
	aStarPairCopy.parent = self.parent;
	aStarPairCopy.g = self.g;
	aStarPairCopy.h = self.h;
	return aStarPairCopy;
}

// Override the description method to give us something more useful than a pointer address
- (NSString *) description
{
	return [NSString stringWithFormat:@"(%d, %d, F:%d, G:%d, H:%d)", x, y, self.f, g, h];
}

- (void)dealloc
{
	[parent release];
	[super dealloc];
}

@end

