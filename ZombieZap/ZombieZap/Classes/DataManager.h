//
//  DataManager.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 4/25/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class HUDLayer;

@interface DataManager : CCNode {

	HUDLayer *hudLayer_;
	
	CGFloat powerDraw_;
	
	CGFloat power_;
	
	CGFloat maxPower_;
	
	CGFloat fullGenCharge_;
	
	CGFloat genSpeed_;
	
	NSInteger parts_;
	
    NSMutableDictionary *techLevels_;
}

+ (DataManager *) dataManager;

+ (void) purgeDataManager;

- (void) registerHUDLayer:(HUDLayer *)hudLayer;

- (void) startUpdates;

@end
