//
//  Grid.h
//  PrototypeOne
//
//  Created by Paul Vishayanuroj & Jamorn Ho on 6/4/10.
//  Copyright 2010 Paul Vishayanuroj & Jamorn Ho. All rights reserved.
//

#import "cocos2d.h"
#import "Enums.h"
#import "Constants.h"

@class Pair;

/**
	Grid singeton object, used to keep track of what's on the map
 */
@interface Grid : NSObject {

	/**
		How many cells across the grid is
	 */
	NSUInteger gridX_;

	/**
		How many cells top to bottom the grid is
	 */
	NSUInteger gridY_;

	/**
		Width and height of a cell in pixels (cells must be square)
	 */	
	NSUInteger gridSize_;
	
	/**
		The background image we are using
	 */
	CCSprite *mapImage_;
	
	/**
		Associative map holding coordinate as a key and an integer value as elevation representation
	 */
	NSDictionary *terrain_;
	
	/**
		Dictionary that maps coordinates to a direction to move towards the objective
	 */
	NSMutableDictionary *objectiveMap_;

	/**
		Associative map holding coordinate as a key and an array of gameobjects as the value
	 */	
	NSMutableDictionary *mapObjects_;
	
}

@property(nonatomic, readonly)	NSUInteger gridX;
@property(nonatomic, readonly)	NSUInteger gridY;
@property(nonatomic, readonly)	NSUInteger gridSize;
@property(nonatomic, readonly)	CCSprite *mapImage;
@property(nonatomic, readonly)	NSDictionary *terrain;
@property(nonatomic, readonly)	NSDictionary *mapObjects;
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
	Method that converts the map coordinate into a grid coordinate.
	@param mapCoordinate The map coordinate that you wish to get the grid coordinate for.
	@return A pair of integer values representing the grid coordinate.
 */
- (Pair *)gridCoordinateAtMapCoordinate:(CGPoint)mapCoordinate;

/**
	Method that retrieves the terrain type from the grid by taking in the grid coordinate.
	@param gridCoordinate The grid coordinate to retrieve the terrain.
	@returns The terrain value of the grid.
 */
- (TerrainType)terrainAtGridCoordinate:(Pair *)gridCoordinate;

/**
	Method that gets the map coordinate at the center of a grid.
	@param gridCoordinate The grid coordinate to get the map coordinate for.
	@returns The mid point map coordinate value of the grid.
 */
- (CGPoint)mapCoordinateAtGridCoordinate:(Pair *)gridCoordinate;

- (void) addPathToObjective:(NSArray *)path;

/**
	Method to check if an object can be added to a specified grid coordinate, basically if it is full or impassable.
	@param gridCoordinate Grid coordinate that you need to check if it is full impassable.
	@returns YES if objects can be added, NO if objects can't be added.
 */
//- (BOOL)objectsCanBeAddedToGridCoordinate:(Pair *)gridCoordinate;

/**
	Adds the reference of the game object to the grid with the grid coordinate as the key.
	@param gameObject The game object to be added to the grid.
	@param gridCoordinate The grid coordinate that the unit is being added.
	@returns YES if the unit has been added, NO if the unit was not added.
 */
//- (BOOL)addGameObject:(GameObject *)gameObject toGridCoordinate:(Pair *)gridCoordinate;

/**
	Removes the specified game object from the dictionary
	@param gameObject Game Object to be removed
	@param gridCoord Grid coordinate that the object is located in
	@returns Whether or not the operation was successful
 */
//- (BOOL) removeGameObject:(GameObject *)gameObject atGrid:(Pair *)gridCoord;

@end
