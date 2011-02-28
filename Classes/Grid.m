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
		//mapObjects = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
		[self initAdjArray];
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


- (void) initAdjArray
{
	adjArray = [[NSMutableArray arrayWithCapacity:8] retain];
	[adjArray addObject:[Pair pair:0 second:1]]; // up
	[adjArray addObject:[Pair pair:1 second:1]]; // up-right
	[adjArray addObject:[Pair pair:1 second:0]]; // right
	[adjArray addObject:[Pair pair:1 second:-1]]; // down-right
	[adjArray addObject:[Pair pair:0 second:-1]]; // down
	[adjArray addObject:[Pair pair:-1 second:-1]]; // down-left
	[adjArray addObject:[Pair pair:-1 second:0]]; // left
	[adjArray addObject:[Pair pair:-1 second:1]]; // up-left
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

- (void) zeroGrid
{
	Pair *point;
	NSMutableArray *keys = [NSMutableArray arrayWithCapacity: GRIDX * GRIDY];
	NSMutableArray *vals = [NSMutableArray arrayWithCapacity: GRIDX * GRIDY];
	NSNumber *val = [NSNumber numberWithInt:0];
	
	NSLog(@"gridx: %d", GRIDX);
	NSLog(@"gridy: %d", GRIDY);
	
	for (int i = 0; i < GRIDX; i++) {
		for (int j = 0; j < GRIDY; j++) {
			point = [Pair pair:i second:j];
			[keys addObject:point];
			[vals addObject:val];
		}
	}
	
	terrain = [[NSDictionary dictionaryWithObjects:vals forKeys:keys] retain];
}

- (Pair *)gridCoordinateAtMapCoordinate:(CGPoint)mapCoordinate {
	NSAssert((int)mapImage.contentSize.width % gridX == 0, @"Map width does not divide perfectly into the number of grids X.");
	NSAssert((int)mapImage.contentSize.height % gridX == 0, @"Map width does not divide perfectly into the number of grids Y.");
	
	NSUInteger gridSizeX = mapImage.contentSize.width / gridX;
	NSUInteger gridSizeY = mapImage.contentSize.height / gridY;
	
	Pair *gridCoordinate = [Pair pair:mapCoordinate.x / gridSizeX second:mapCoordinate.y / gridSizeY];
	
	return gridCoordinate;
}

- (TerrainType)terrainAtGridCoordinate:(Pair *)gridCoordinate {
	if (gridCoordinate.x < 0 || gridCoordinate.y < 0 || gridCoordinate.x >= self.gridX || gridCoordinate.y >= self.gridY) 
		return TERR_IMPASS;
		
	NSUInteger terrainType = [[terrain objectForKey:gridCoordinate] intValue];
	return (TerrainType)terrainType;
}

- (CGPoint)mapCoordinateAtGridCoordinate:(Pair *)gridCoordinate {
	NSUInteger gridSizeX = mapImage.contentSize.width / gridX;
	NSUInteger gridSizeY = mapImage.contentSize.height / gridY;
	
	CGPoint mapCoordinate = CGPointMake(((gridCoordinate.x+1) * gridSizeX) - gridSizeX/2, ((gridCoordinate.y+1) * gridSizeY) - gridSizeY/2);
	return mapCoordinate;
}

- (BOOL)objectsCanBeAddedToGridCoordinate:(Pair *)gridCoordinate {
	return [self terrainAtGridCoordinate:gridCoordinate] != TERR_IMPASS;
}

// Our magical pathfinding algorithm oooooooooh!
// F = G + H = Calculated Search Cost
// G = Movement cost from starting point to this node
// H = Estimated movement cost from this node to the end point
- (NSMutableArray *) findPathFrom:(Pair *)start to:(Pair *)dest
{	
	if ([Pair pairsEqual:start withPair:dest])
		return nil;
	
	NSMutableDictionary *openList = [NSMutableDictionary dictionaryWithCapacity:10];
	NSMutableDictionary *closeList = [NSMutableDictionary dictionaryWithCapacity:10];
	NSMutableArray *path = [NSMutableArray arrayWithCapacity:10];
	
	// Add the starting square to the open list
	[openList setObject:[AStarPair aStarPairWithPair:start] forKey:start];
	
	// Main pathfinding loop
	// Iterate as long as the open list is not empty and the target node has not been found
	while (YES) {
		
		// Find the lowest F cost square in the open list
		// Move it to the closed list
		NSEnumerator *openEnumerator = [openList objectEnumerator];
		AStarPair *lowestFNode = (AStarPair *)[openEnumerator nextObject];
		AStarPair *tempNode;
		
		while ((tempNode = (AStarPair *)[openEnumerator nextObject])) {
			if (tempNode.f < lowestFNode.f)
				lowestFNode = tempNode;
		}
		
		Pair *key = [[openList allKeysForObject:lowestFNode] objectAtIndex:0];
		
		[closeList setObject:lowestFNode forKey:key];
		[openList removeObjectForKey:key];
		
		// If the key node is the dest node then the algorithm is done.
		if ([Pair pairsEqual:key withPair:dest]) {
			
			NSMutableArray *tempReversePath = [NSMutableArray arrayWithCapacity:10];
			// Trace the path back from the end node to the original node.
			AStarPair *tempChild = lowestFNode;
			AStarPair *tempParent;
			do {
				tempParent = tempChild.parent;
				
				[tempReversePath addObject:[Pair pair:tempChild.x-tempParent.x second:tempChild.y-tempParent.y]];
				
				tempChild = tempParent;
			} while(tempParent.x != start.x || tempParent.y != start.y);
			
			// Reverse the path
			for (int i=tempReversePath.count-1; i >= 0; i--) {
				[path addObject:[tempReversePath objectAtIndex:i]];
			}
			break;
		}

#if DEBUG_PATHFINDING
		NSLog(@"EVALUATE %@", key);
#endif
		// For each adjacent square (8 squares)
		// Check if passable and not on the closed list
		for (Pair *element in adjArray) {
			
			Pair *pair = [Pair addPair:key withPair:element];
			
			// If the grid is impassable then skip.
			if([self terrainAtGridCoordinate:pair] == TERR_IMPASS)
				continue;
			
			//if ([mapObjects objectForKey:pair])
			//	continue;
			
			// If the grid is in closed list skip it.
			if ([closeList objectForKey:pair]) 
				continue;
			
			// If the adjacent node is diaganal from the current node
			// then check if the nodes adjacent to itself and the current node
			// is impassable, if it is, it too becomes impassable.
			// This fixes cornering.
			Pair *diff = [Pair pair:(pair.x-key.x) second:(pair.y-key.y)];
			if(diff.x != 0 &&  diff.y != 0) {
				if([self terrainAtGridCoordinate:[Pair pair:pair.x-diff.x second:pair.y]] == TERR_IMPASS)
					continue;
				if([self terrainAtGridCoordinate:[Pair pair:pair.x second:pair.y-diff.y]] == TERR_IMPASS)
					continue;
			}
			
			AStarPair *aStarPair = [openList objectForKey:pair];
			
			// If the grid is not in open list then calculate it's F, G, and H value and add it to the open list.
			if (!aStarPair) {
				
				aStarPair = [AStarPair aStarPairWithPair:pair];
				
				// If the adjacent node is diagnal from current node then add DIAG_MOVECOST
				// else it is assume to be adjacent to the current node then add ADJ_MOVECOST
				if(element.x * element.y != 0) 
					aStarPair.g = lowestFNode.g + DIAG_MOVECOST;
				else
					aStarPair.g = lowestFNode.g + ADJ_MOVECOST;
				
				// Calculate the manhattan distance between this node and the end node
				aStarPair.h = [Pair manhattanDistance:pair withPair:dest] * ADJ_MOVECOST;
				
				// Use euclidean distance instead.
				// aStarPair.h = [Pair euclideanDistance:pair withPair:dest] * ADJ_MOVECOST;
				
				// Set the adjacent node's parent to current node
				aStarPair.parent = lowestFNode;
				
				// Add it to the open list.
				[openList setObject:aStarPair forKey:pair];
#if DEBUG_PATHFINDING				
				NSLog(@"Check %@ - Created %@", element, aStarPair);
#endif				
			}
			else {
				// If the adjacent node is diagnal from current node then add DIAG_MOVECOST
				// else it is assume to be adjacent to the current node then add ADJ_MOVECOST
#if DEBUG_PATHFINDING
				NSLog(@"Check %@ - Exists %@", element, pair);
#endif
				NSInteger tempG = 0;
				if(element.x * element.y != 0) 
					tempG = lowestFNode.g + DIAG_MOVECOST;
				else
					tempG = lowestFNode.g + ADJ_MOVECOST;
				// If the path through the current node to this particular adjacent square is
				// cheaper (see if the G score is lower using this path)
				if(aStarPair.g > tempG) {
					// Set this adjacent square's parent to be the current node and set the new G
					aStarPair.g = tempG;
					aStarPair.parent = lowestFNode;
				}
			}
		}
	}
	
#if DEBUG_SHOWPATHSCORES
	int count = 0;
	for (Pair *p in closeList) {
		AStarPair *a = [closeList objectForKey:p];
		[(GameLayer *)self.parent debugGridInfo:a count:count++];
	}
#endif
	
	if (path)
		return path;
	else
		return nil;
}

- (void) dealloc
{
	[mapImage release];
	[terrain release];
	[mapObjects release];
	[adjArray release];
	
	_grid = nil;
	
	[super dealloc];
}

@end
