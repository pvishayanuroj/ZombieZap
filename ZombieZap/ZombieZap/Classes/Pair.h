//
//  Pair.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 2/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

/**
 A useful pair class to hold integers
 */
@interface Pair : NSObject <NSCopying>
{
	/** First stored integer */
	NSInteger x;
	
	/** Second stored integer */
	NSInteger y;
}

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;

/**
	Pair class convenience constructor. Returns a pair initialized to (0, 0)
	@returns Returns an autorelased pair object
 */
+ (id) pair;

/**
	Pair class convenience constructor
	@param a The value of the first integer
	@param b The value of the second integer
	@returns Returns the autoreleased created pair object
 */
+ (id) pair:(NSInteger)a second:(NSInteger)b;

/**
	Pair class convenience constructor using another pair's values to initialize with
	@param p The pair being used 
	@returns Returns an autoreleased pair object
 */
+ (id) pairWithPair:(Pair *)p;

/**
	Method to add the values of one pair to another pair
	@param a The first Pair
	@param b The second Pair
	@returns The resulting Pair from the addition
 */
+ (Pair *) addPair:(Pair *)a withPair:(Pair *)b;

/**
	Method to subtract the values of one pair from another pair
	@param a The first Pair (Pair to be subtracted)
	@param b The second Pair (Pair used as subtractor)
	@returns The resulting Pair from the subtraction (a-b)
 */
+ (Pair *) subtractPair:(Pair *)a withPair:(Pair *)b;

/**
	Method to determine the direction from point a to point b
	@param a Position of the origin
	@param b Position to find the direction from origin to
	@returns A pair to denote the relative diection
*/
//+ (Pair *) getDirectionFromPair:(Pair *)a toPair:(Pair *)b;

/**
	Method to determine the angle in radians that point b makes relative to point a
	@param a First pair
	@param b Second pair
	@returns The angle in radians
 */
+ (CGFloat) getAngleFromPair:(Pair *)a b:(Pair *)b;

/**
	Checks if two pairs have equal values
	@param a The first pair
	@param b The second pair
	@returns Whether or not they hold equal values
 */
+ (BOOL) pairsEqual:(Pair *)a withPair:(Pair *)b;

/**
	Method returning the Manhattan distance between two pairs
	@param a First pair
	@param b Second pair
	@returns The Manhattan distance
 */
+ (NSUInteger) manhattanDistance:(Pair *)a withPair:(Pair *)b;

/**
	Method returning the Euclidean distance between two pairs
	@param a First pair
	@param b Second pair
	@returns The Euclidean distance
 */
+ (CGFloat) euclideanDistance:(Pair *)a withPair:(Pair *)b;

/**
	Method returning the Euclidean distance between two pairs without the square root
	@param a First pair
	@param b Second pair
	@returns The Euclidean distance without square-rooting
 */
+ (NSUInteger) euclideanDistanceNoRoot:(Pair *)a withPair:(Pair *)b;

/**
	Method that calculates distance based by ignoring diagonals. E.g. Top-left is the same distance away as left
	@param a First pair
	@param b Second pair
	@returns Returns the distance based on this box method
 */
+ (NSUInteger) boxDistance:(Pair *)a withPair:(Pair *)b;

/**
	Pair class initializer
	@param a The value of the first integer
	@param b The value of the second integer
	@returns Returns the created pair object
 */
- (id) initPair:(int)a second:(int)b;

/**
	Method to add the values of one pair to this pair
	@param p The pair addend
 */
- (void) addWithPair:(Pair *)p;

/**
	Method to subtract the values of one pair from this pair
	@param p The pair addend
 */
- (void) subtractWithPair:(Pair *)p;

/**
	Method to return a new pair to the left of this pair (x-1)
	@returns A new pair whose location is to the left of this pair
 */
- (Pair *) leftPair;

/**
	Method to return a new pair to the right of this pair (x+1)
	@returns A new pair whose location is to the right of this pair
 */
- (Pair *) rightPair;

/**
	Method to return a new pair above this pair (y+1)
	@returns A new pair whose location is above this pair
 */
- (Pair *) topPair;

/**
	Method to return a new pair below this pair (y-1)
	@returns A new pair whose location is below this pair
 */
- (Pair *) bottomPair;

/**
	Method to multiply a pair's x and y values by -1
 */
- (void) invertPair;

/**
	Method returning the Manhattan distance from this pair to the given pair
	@param p The pair to get the distance to
	@returns The Manhattan distance
 */
- (NSUInteger) manhattanDistance:(Pair *)p;

/**
	Sets the values of this pair equal to another
	@param p The pair to set this one equal to
 */
- (void) setEqualWith:(Pair *)p;

/**
	Implementation to comply with NSCopying protocol
	@param zone Memory zone to copy to
	@returns A new copy of the pair object
 */
- (id) copyWithZone:(NSZone *)zone;

@end

