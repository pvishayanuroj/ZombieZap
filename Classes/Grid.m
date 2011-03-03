//
//  Grid.m
//  PrototypeOne
//
//  Created by Paul Vishayanuroj & Jamorn Ho on 6/4/10.
//  Copyright 2010 Paul Vishayanuroj & Jamorn Ho. All rights reserved.
//

#import "Grid.h"
#import "Pair.h"

// For singleton
static Grid *_grid = nil;

@implementation Grid

@synthesize gridX, gridY, mapImage, terrain, mapObjects;
@synthesize objectiveMap = objectiveMap_;

+ (Grid *) grid
{
	if (!_grid)
		_grid = [[self alloc] init];
	
	return _grid;
}

+ (id) alloc
{
	NSAssert(_grid == nil, @"Attempted to allocate a second instance of a Grid singleton.");
	return [super alloc];
}

+ (void) purgeGrid
{
	[_grid release];
}

- (id) init
{
	if ((self = [super init]))
	{
		objectiveMap_ = [[NSMutableDictionary dictionaryWithCapacity:50] retain];
	}
	return self;
}

- (void) setGridWithMap:(NSString *)mapName {
	
	// Background sprite
	[self loadElevation:mapName];
		
	mapImage = [[CCSprite spriteWithFile:[mapName stringByAppendingString:@".png"]] retain];
		
	// By default this is 0.5, 0.5 (center of node), we want bottom-left corner
	mapImage.anchorPoint = ccp(0, 0);
}

- (void) loadElevation:(NSString *)fileName
{
	Pair *pair;
	NSNumber *elevation;
	NSInteger val;
	NSUInteger x, y;
	NSUInteger count = 0;
	
	// Parse file into string
	NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];		
    NSString *input = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	
	NSScanner *scanner = [NSScanner scannerWithString:input];
	
	// Ignore new lines, spaces, and commas
	NSCharacterSet *toIgnore = [NSCharacterSet characterSetWithCharactersInString:@", \n\r"];
	[scanner setCharactersToBeSkipped:toIgnore];
	
	NSMutableArray *keys;
	NSMutableArray *vals;
	
	// Scan
	while ([scanner isAtEnd] == NO) {
		
		if(count == 0) {
			[scanner scanInteger:&val];
			gridX = val;
		}
		else if(count == 1) {
			[scanner scanInteger:&val];
			gridY = val;
			
			// Initialize the arrays with exactly the correct number of grids needed.
			keys = [NSMutableArray arrayWithCapacity: gridX * gridY];
			vals = [NSMutableArray arrayWithCapacity: gridX * gridY];
		}
		else {
			
			[scanner scanInteger:&val];
			
			// Calculate what coordinate we are on based off the count
			x = (count-2) % gridX;
			y = (gridY - 1) - ((count-2) / gridY);
			
			// Create the pair and store it along with elevation
			pair = [Pair pair:x second:y];
			elevation = [NSNumber numberWithInt:val];
			
			[keys addObject:pair];
			[vals addObject:elevation];
		}
		
		count++;
	}
	
	// Exception in case map file is wrong
	NSAssert((count-2) == self.gridX * self.gridY, @"Map cells do not match with grid constants");
		 
	// Create the terrain dictionary	 
	terrain = [[NSDictionary dictionaryWithObjects:vals forKeys:keys] retain];
	
#if DEBUG_MAPLOADER
	NSLog(@"terrain: %@", terrain);
#endif
}

- (Pair *)gridCoordinateAtMapCoordinate:(CGPoint)mapCoordinate {
	NSAssert((int)mapImage.contentSize.width % gridX == 0, @"Map width does not divide perfectly into the number of grids X.");
	NSAssert((int)mapImage.contentSize.height % gridX == 0, @"Map width does not divide perfectly into the number of grids Y.");
	
	NSUInteger gridSizeX = mapImage.contentSize.width / gridX;
	NSUInteger gridSizeY = mapImage.contentSize.height / gridY;
	
	Pair *gridCoordinate = [Pair pair:mapCoordinate.x / gridSizeX second:mapCoordinate.y / gridSizeY];
	
	return gridCoordinate;
}

- (TerrainType)terrainAtGridCoordinate:(Pair *)gridCoordinate 
{
	if (gridCoordinate.x < 0 || gridCoordinate.y < 0 || gridCoordinate.x >= self.gridX || gridCoordinate.y >= self.gridY) 
		return TERR_IMPASS;
		
	NSUInteger terrainType = [[terrain objectForKey:gridCoordinate] intValue];
	return (TerrainType)terrainType;
}

- (CGPoint)mapCoordinateAtGridCoordinate:(Pair *)gridCoordinate 
{
	NSUInteger gridSizeX = mapImage.contentSize.width / gridX;
	NSUInteger gridSizeY = mapImage.contentSize.height / gridY;
	
	CGPoint mapCoordinate = CGPointMake(((gridCoordinate.x+1) * gridSizeX) - gridSizeX/2, ((gridCoordinate.y+1) * gridSizeY) - gridSizeY/2);
	return mapCoordinate;
}

- (BOOL)objectsCanBeAddedToGridCoordinate:(Pair *)gridCoordinate 
{
	return [self terrainAtGridCoordinate:gridCoordinate] != TERR_IMPASS;
}

- (void) addPathToObjective:(NSArray *)path 
{
	Pair *key, *value;
	
	for (int i = 0; i < [path count] - 1; i++) {
		
		key = [path objectAtIndex:i];
		value = [path objectAtIndex:(i + 1)];
		
		[objectiveMap_ setObject:value forKey:key];
	}
}

- (void) dealloc
{
	[mapImage release];
	[terrain release];
	[objectiveMap_ release];
	
	_grid = nil;
	
	[super dealloc];
}

@end
