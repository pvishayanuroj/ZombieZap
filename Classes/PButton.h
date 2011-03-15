//
//  PButton.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 1/23/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"
#import "enums.h"

@class Pair;

@interface PButton : CCNode <CCTargetedTouchDelegate> {

	CCSprite *sprite_;
	
	CCSprite *placementSprite_;
	
	BOOL placementAdded_;
	
	BuildButtonType buttonType_;
	
	BOOL allowable_;
}

+ (id) pButton:(NSString *)buttonImage placementImage:(NSString *)placementImage buttonType:(BuildButtonType)buttonType;

- (id) initPButton:(NSString *)buttonImage placementImage:(NSString *)placementImage buttonType:(BuildButtonType)buttonType;

- (void) buildAction:(Pair *)location;

@end
