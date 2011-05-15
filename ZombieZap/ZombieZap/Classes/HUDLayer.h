//
//  HUDLayer.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/2/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"


@interface HUDLayer : CCLayer {

	CCLabelAtlas *genRateLabel_;
	
	CCLabelTTF *powerLabel_;
	
	CCLabelTTF *partsLabel_;
	
}

- (void) setGeneratorSpeed:(CGFloat)speed;

- (void) setPower:(CGFloat)power powerDraw:(CGFloat)powerDraw;

- (void) setParts:(NSInteger)parts;

@end
