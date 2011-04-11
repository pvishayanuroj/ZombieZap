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
	TERR_PASS = 1,
	TERR_NOBUILD = 2
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
	B_TASER = 2,
	B_TEST1 = 3,
	B_TEST2 = 4
} BuildButtonType;

typedef enum {
	D_VERTICAL,
	D_HORIZONTAL
} DirectionType;

typedef enum {
	S_UP = 0,
	S_UPRIGHT = 1,
	S_RIGHT = 2,
	S_DOWNRIGHT = 3,
	S_DOWN = 4,
	S_DOWNLEFT = 5,
	S_LEFT = 6,
	S_UPLEFT = 7
} SpriteOrientation;

enum {
	W_UP = 1,
	W_DOWN = 2,
	W_LEFT = 4,
	W_RIGHT = 8
};

enum {
	kWire = 1,
	kTower = 2,
	kZombie = 3,
	kDamage = 4,
	kHome = 10	
};

enum {
	kGameLayer = 0,
	kFogLayer = 1,
	kEyesLayer = 2,
	kBuildLayer = 3,
	kGeneratorLayer = 4
};