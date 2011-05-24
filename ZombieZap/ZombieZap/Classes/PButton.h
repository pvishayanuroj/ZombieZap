//
//  PButton.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 1/23/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

enum {
	kCurrentSprite
};

@class Pair;

@interface PButton : CCNode <CCTargetedTouchDelegate> {

	CCSprite *sprite_;
	
	CCSprite *placementSprite_;
	
	CCSprite *toggledSprite_;	
	
	CGPoint placementSpriteDrawOffset_;
	
	BOOL placementAdded_;
	
	BuildButtonType buttonType_;
	
	BOOL allowable_;
}

@property (nonatomic, assign) CGPoint placementSpriteDrawOffset;

+ (id) pButton:(NSString *)buttonImage placementImage:(NSString *)placementImage buttonType:(BuildButtonType)buttonType;

+ (id) pButton:(NSString *)buttonImage placementImage:(NSString *)placementImage toggledImage:(NSString *)toggledImage buttonType:(BuildButtonType)buttonType;

- (id) initPButton:(NSString *)buttonImage placementImage:(NSString *)placementImage buttonType:(BuildButtonType)buttonType;

- (id) initPButton:(NSString *)buttonImage placementImage:(NSString *)placementImage toggledImage:(NSString *)toggledImage buttonType:(BuildButtonType)buttonType;

- (void) buildAction:(Pair *)location;

- (void) changeToToggled;

- (void) changeToNormal;

@end
