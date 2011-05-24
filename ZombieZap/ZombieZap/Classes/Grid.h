//
//  Grid.h
//  PrototypeOne
//
//  Created by Paul Vishayanuroj & Jamorn Ho on 6/4/10.
//  Copyright 2010 Paul Vishayanuroj & Jamorn Ho. All rights reserved.
//

#import "cocos2d.h"

@class Pair;

/**
	Grid singeton object, used to keep track of what's on the map
 */
@interface Grid : NSObject {

	/** How many cells across the grid is */
	NSUInteger gridX_;

	/** How many cells top to bottom the grid is */
	NSUInteger gridY_;

	/** Width and height of a cell in pixels (cells must be square) */	
	NSUInteger gridSize_;
	
	/** The background image we are using */
	CCSprite *mapImage_;
	
	/** Associative map holding coordinate as a key and an integer value as elevation representation */
	NSMutableDictionary *terrain_;
	
	/** Dictionary that maps coordinates to a direction to move towards the objective */
	NSMutableDictionary *objectiveMap_;
}

@property(nonatomic, readonly)	NSUInteger gridX;
@property(nonatomic, readonly)	NSUInteger gridY;
@property(nonatomic, readonly)	NSUInteger gridSize;
@property(nonatomic, readonly)	CCSprite *mapImage;
@property(nonatomic, readonly)	NSMutableDictionary *terrain;
@property(nonatomic, readonly)	NSMutableDictionary *objectiveMap;

/**
	Returns the Grid singleton. Initializes a new one if one does not exist
	@returns The Grid singleton
 */
+ (Grid *) grid;

/**
	Releases the Grid singleton
 */
+ (void) purgeGrid;

/**
	Loads the elevation map and specific background for the map
	@param mapName Name to use for the background image and elevation file
 */
- (void) setGridWithMap:(NSString *)mapName;

/**
	Method to read elevation data from a CSV file
	@param fileName Name of the elevation file (just the name, don't need the .txt)
 */
- (void) loadElevation:(NSString *)fileName;

/**
	Method that converts a pixel coordinate into a grid coordinate.
	@param p The pixel coordinate that you wish to get the grid coordinate for.
	@return A pair of integer values representing the grid coordinate.
 */
- (Pair *) pixelToGrid:(CGPoint)p;

/**
	Method that gets the map coordinate at the center of a grid.
	@param g The grid coordinate to get the map coordinate for.
	@returns The midpoint pixel coordinate value of the grid.
 */
- (CGPoint) gridToPixel:(Pair *)g;

/**
	Method that converts a local pixel coordinate into a local grid coordinate (uses GameLayer offset)
	@param pixel The local pixel coordinate that you wish to get the local grid coordinate for.
	@return A pair of integer values representing the local grid coordinate.
 */
- (CGPoint) localPixelToLocalGridPixel:(CGPoint)pixel;

/**
	Method that converts a local pixel coordinate into a world grid coordinate (uses GameLayer offset)
	@param pixel The local pixel coordinate that you wish to get the world grid coordinate for.
	@return A pair of integer values representing the world grid coordinate.
 */
- (Pair *) localPixelToWorldGrid:(CGPoint)pixel;

/**
	Method that converts a world grid coordinate into a local pixel coordinate (uses GameLayer offset)
	@param pixel The world grid coordinate that you wish to get the local pixel coordinate for.
	@return The local midpoint pixel value
 */
- (CGPoint) worldGridToLocalPixel:(Pair *)p;

/**
	Method that retrieves the terrain type from the grid by taking in the grid coordinate.
	@param p The grid coordinate to retrieve the terrain.
	@returns The terrain value of the grid.
 */
- (TerrainType) terrainAtGrid:(Pair *)p;

/**
	Method that returns whether or not there is a tower at the given grid coordinate.
	@param p The grid coordinate to query.
	@returns True if a tower exists, false otherwise (including out of bounds).
 */
- (BOOL) towerAtGrid:(Pair *)p;

- (BOOL) impassableAtGrid:(Pair *)p;

- (void) makePassable:(Pair *)p;

- (void) makeImpassable:(Pair *)p;

- (void) makeNoBuild:(Pair *)p;

- (void) addPathToObjective:(NSArray *)path;

- (Pair *) getNextStep:(NSUInteger)pathNum current:(Pair *)current prev:(Pair *)prev;

@end
