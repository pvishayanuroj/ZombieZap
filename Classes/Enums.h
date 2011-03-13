//
//  Enums.h
//  PrototypeOne
//
//  Created by Paul Vishayanuroj & Jamorn Ho on 6/4/10.
//  Copyright 2010 Paul Vishayanuroj & Jamorn Ho. All rights reserved.
//

/**
	Terrain enums
 */
typedef enum {
	TERR_IMPASS = 0,
	TERR_LOW = 1,
	TERR_MID = 2,
	TERR_HIGH = 3
} TerrainType;

typedef enum {
	DIR_UP = 0,
	DIR_DOWN = 1,
	DIR_LEFT = 2,
	DIR_RIGHT = 3
} TileDirection;

typedef enum {
	ON_CLOSED = 0,
	ON_OPEN_NOADJUST = 1,
	ON_OPEN_ADJUST = 2,
	ON_NONE = 3
} ASNodeGroup;

typedef enum {
	B_WIRE = 0, 
	B_LIGHT = 1,
	B_TASER = 2
} BuildButtonType;