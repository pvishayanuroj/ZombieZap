//
//  Pair.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 2/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 A useful pair class to hold integers
 */
@interface Pair : NSObject <NSCopying>
{
	/**
	 First stored integer
	 */
	NSInteger x;
	
	/**
	 Second stored integer
	 */
	NSInteger y;
}

@property (nonatomic) NSInteger x;
@property (nonatomic) NSInteger y;

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
 Method to multiply a pair's x and y values by -1
 */
- (void) invertPair;

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

/**
 Subclass of the Pair class to be used for A* Path Finding Algorithm
 */
@interface AStarPair : Pair
{
	/**
	 The movement cost to move from the starting point A to a given square on the grid, following the path generated to get there.
	 */
	NSUInteger g;
	
	/**
	 The estimated movement cost to move from that given square on the grid to the final destination, point B.
	 */
	NSUInteger h;
	
	/**
	 The parent node of this AStarPair
	 */
	AStarPair *parent;
	
}

@property(nonatomic) NSUInteger g;
@property(nonatomic) NSUInteger h;
@property(nonatomic, readonly) NSUInteger f;
@property(nonatomic, copy) AStarPair *parent;

/**
 Class constructor to create an AStarPair with a Pair
 @param pair The pair to create an AStarPair from.
 @returns An AStarPair with g = 0 and h = 0.
 */
+ (id) aStarPairWithPair:(Pair *)pair;

/**
 AStarPair class initializer
 @param a The value of the first integer
 @param b The value of the second integer
 @returns Returns the created AStarPair object
 */
- (id) initAStarPair:(NSInteger)a second:(NSInteger)b;

/**
 Implementation to comply with NSCopying protocol
 @param zone Memory zone to copy to
 @returns A new copy of the pair object
 */
- (id) copyWithZone: (NSZone *)zone;

@end
