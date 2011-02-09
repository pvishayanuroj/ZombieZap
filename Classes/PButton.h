//
//  PButton.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 1/23/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"


@interface PButton : CCNode <CCTargetedTouchDelegate> {

	CCSprite *sprite;
	
	CCSprite *placementSprite;
	
}

+ (id) pButton;

- (id) initPButton;

@end
