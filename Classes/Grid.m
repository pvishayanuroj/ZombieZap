//
//  Grid.m
//  PrototypeOne
//
//  Created by Paul Vishayanuroj & Jamorn Ho on 6/4/10.
//  Copyright 2010 Paul Vishayanuroj & Jamorn Ho. All rights reserved.
//

#import "Grid.h"
#import "Pair.h"
#import "GameManager.h"

// For singleton
static Grid *_grid = nil;

@implementation Grid

@synthesize gridX = gridX_;
@synthesize gridY = gridY_;
@synthesize gridSize = gridSize_;
@synthesize mapImage = mapImage_;
@synthesize terrain = terrain_;
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
	_grid = nil;
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

	// Image must be set first, since loadElevation depends on this
	mapImage_ = [[CCSprite spriteWithFile:[mapName stringByAppendingString:@".png"]] retain];
	
	// By default this is 0.5, 0.5 (center of node), we want bottom-left corner
	mapImage_.anchorPoint = ccp(0, 0);	
	
	// Background sprite
	[self loadElevation:mapName];
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
			gridX_ = val;
		}
		else if(count == 1) {
			[scanner scanInteger:&val];
			gridY_ = val;
			
			// Initialize the arrays with exactly the correct number of grids needed.
			keys = [NSMutableArray arrayWithCapacity: gridX_ * gridY_];
			vals = [NSMutableArray arrayWithCapacity: gridX_ * gridY_];
		}
		else {
			
			[scanner scanInteger:&val];
			
			// Calculate what coordinate we are on based off the count
			x = (count-2) % gridX_;
			y = (gridY_ - 1) - ((count-2) / gridY_);
			
			// Create the pair and store it along with elevation
			pair = [Pair pair:x second:y];
			elevation = [NSNumber numberWithInt:val];
			
			[keys addObject:pair];
			[vals addObject:elevation];
		}
		
		count++;
	}
	
	NSUInteger gridSizeX = mapImage_.contentSize.width / gridX_;
	NSUInteger gridSizeY = mapImage_.contentSize.height / gridY_;		
	
	// Map checks
	NSAssert((int)mapImage_.contentSize.width % gridX_ == 0, @"Map width does not result in a divisible amount of specified X cells");
	NSAssert((int)mapImage_.contentSize.height % gridY_ == 0, @"Map height does not result in a divisible amount of specified Y cells");	
	
	NSAssert((count-2) == self.gridX * self.gridY, @"Map cells do not match with grid constants");
	NSAssert(gridSizeX == gridSizeY, @"Map cells must be square");
	
	gridSize_ = gridSizeX;
	
	// Create the terrain dictionary	 
	terrain_ = [[NSMutableDictionary dictionaryWithObjects:vals forKeys:keys] retain];
	
#if DEBUG_MAPLOADER
	NSLog(@"terrain: %@", terrain_);
#endif
}

- (Pair *) pixelToGrid:(CGPoint)p
{
	return [Pair pair:p.x / gridSize_ second:p.y / gridSize_];
}

- (CGPoint) gridToPixel:(Pair *)g
{	
	return CGPointMake(((g.x+1) * gridSize_) - gridSize_/2, ((g.y+1) * gridSize_) - gridSize_/2);
}

- (CGPoint) localPixelToLocalGridPixel:(CGPoint)pixel
{
	CGPoint offset = [[GameManager gameManager] getLayerOffset];

	// Local space to world space, then
	// convert to the closest grid
	CGPoint actual = ccpSub(pixel, offset);	
	Pair *p = [self pixelToGrid:actual];
	
	// Go from grid to pixel then read the offset
	CGPoint gridPixel = [self gridToPixel:p];
	return ccpAdd(gridPixel, offset);
}

- (Pair *) localPixelToWorldGrid:(CGPoint)pixel
{
	CGPoint offset = [[GameManager gameManager] getLayerOffset];
	
	// Local space to world space, then
	// convert to the closest grid
	CGPoint actual = ccpSub(pixel, offset);	
	Pair *p = [self pixelToGrid:actual];
	
	return p;
}

- (TerrainType) terrainAtGrid:(Pair *)p 
{
	if (p.x < 0 || p.y < 0 || p.x >= self.gridX || p.y >= self.gridY) 
		return TERR_IMPASS;
	
	// Check if a tower is there
	if ([self towerAtGrid:p])
		return TERR_IMPASS;
	
	TerrainType terrainType = [[terrain_ objectForKey:p] intValue];
	return terrainType;
}

- (BOOL) towerAtGrid:(Pair *)p
{
	if (p.x < 0 || p.y < 0 || p.x >= self.gridX || p.y >= self.gridY) 
		return NO;	
	
	NSSet *towers = [[GameManager gameManager] towerLocations];
	return [towers containsObject:p];
}

- (void) makeImpassable:(Pair *)p
{
	if (p.x >= 0 && p.y >= 0 && p.x < self.gridX && p.y < self.gridY) {
		
		[terrain_ removeObjectForKey:p];
		[terrain_ setObject:[NSNumber numberWithInt:TERR_IMPASS] forKey:p];
	}
}

- (void) makeNoBuild:(Pair *)p
{
	if (p.x >= 0 && p.y >= 0 && p.x < self.gridX && p.y < self.gridY) {
		
		[terrain_ removeObjectForKey:p];
		[terrain_ setObject:[NSNumber numberWithInt:TERR_NOBUILD] forKey:p];
	}
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
	[mapImage_ release];
	[terrain_ release];
	[objectiveMap_ release];
	
	_grid = nil;
	
	[super dealloc];
}

@end
