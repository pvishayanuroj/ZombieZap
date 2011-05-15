//
//  Constants.h
//  PrototypeOne
//
//  Created by Paul Vishayanuroj & Jamorn Ho on 6/4/10.
//  Copyright 2010 Paul Vishayanuroj & Jamorn Ho. All rights reserved.
//

/**
	FOR DEBUG: How many blocks there are left to right
 */
#define GRIDX 8

/**
	FOR DEBUG: How many blocks there are top to bottom
 */
#define GRIDY 8

/**
	The movement cost associated with moving sideways or up or down
 */
#define ADJ_MOVECOST 10

/**
	The movement cost associated with moving diagonally
 */
#define DIAG_MOVECOST 14

/**
	Radius of the most used spotlight, used for precomputation
 */
#define SPOTLIGHT_RADIUS 100

#define SPOTLIGHT_SIDE SPOTLIGHT_RADIUS*2 + 1

/**
	What size the HUD button scales to when clicked
 */
#define HUDBUTTON_SCALETO 0.8f

/**
	How close the unit HUD starts when appearing
 */
#define HUD_NEAROFFSET 5

/**
	How far away the unit HUD appears
 */
#define HUD_FAROFFSET 40

/**
	How fast the unit HUD opens
 */
#define HUD_TOGGLESPEED 0.2f

/**
	How small the buttons scale down to when closing the HUD
 */
#define HUD_TOGGLESCALE 0.2f