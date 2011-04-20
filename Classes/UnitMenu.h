//
//  UnitMenu.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 4/20/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class Pair;

@interface UnitMenu : CCMenu {

	/** Starting positions for all the HUD buttons when it opens */
	NSMutableArray *hudStartPositions;
	
	/** Ending positions for all the HUD buttons when it opens */
	NSMutableArray *hudEndPositions;
	
	CCMenuItem *wasSelected;	
	
}

/**
 Roll our own init function to use instead of the default node method
 @returns Returns an autoreleased HUD layer
 */
+ (id) unitMenu;

/**
 Creates a HUD with all the buttons added
 @param buttons Array of CCMenuItemImage that the HUD will use
 @returns UnitHUDMenu object
 */
+ (id) unitMenuWithHUDButtons:(NSArray *)buttons;

/**
 Unit HUD layer init function
 @returns Returns an instance of the unit HUD layer
 */
- (id) initUnitMenu;

/**
 Initializes a HUD with all the buttons added
 @param buttons Array of CCMenuItemImage that the HUD will use
 @returns UnitHUDMenu object
 */
- (id) initUnitMenuWithHUDButtons:(NSArray *)buttons;

/**
 Used to dynamically add more buttons into the HUD, do not use for initialization, high overhead.
 @param normalImage HUD button image when it's normal
 @param selectedImage HUD button image when it's selected / pressed
 @param disabledImage HUD button image when it's disabled
 @param target Where the callback from the button should be called
 @param callback Selector that will becalled by the button
 @param str A place to store a string with the HUD button if need be (secondary attacks will need this)
 */
- (void) addHUDButton:(NSString *)normalImage selectedImage:(NSString *)selectedImage disabledImage:(NSString *)disabledImage target:(id)target selector:(SEL)callback str:(NSString *)str;

/**
 Repositions the buttons around the unit in a circle.
 */
- (void) repositionButtons;

/**
 Returns a pair of position used to position the HUD buttons based on the offset and the degree
 @param degree The degree around the unit that the HUD button will be positioned
 @param offset How far the button should be offset from the unit
 @returns The pair with the position that the HUD button should be positioned
 */
- (Pair *) calculateHUDPosition:(CGFloat)degree offset:(NSUInteger)offset;

/**
 Makes the buttons active or inactive. Should be called whenever the HUD is toggled
 */
- (void) toggleButtons:(BOOL)animate;

/**
 Returns the CCMenuItem that's under the touch position
 @param touch The location on the screen that the menu was tapped
 @returns The CCMenuItem under that touched location
 */
-(CCMenuItem *) itemForTouch:(UITouch *)touch;

@end
