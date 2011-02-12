//
//  Generator.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 1/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

struct ZGPoint {
	CGFloat rot;
	CGFloat dist;
};
typedef struct ZGPoint ZGPoint;

@interface Generator : CCNode <CCTargetedTouchDelegate> {
	
	/**
	 In degrees
	 */
	CGFloat prevRotation;
	
	CGFloat storedRotation;
	
	CGFloat maxDeltaR;
	
	CGFloat avgSpeed;
	
	CGFloat innerRadius;
	
	CGFloat outerRadius;
	
	CGFloat angularMomentum;
	
	CGFloat startRotation;
	
	NSInteger touchTimer;
	
	NSUInteger sampleSize;
	
	BOOL dirLock;
	
	CCSprite *sprite;
	
	int counter;
	
	CGFloat storedSpeeds[60];
	
}

+ (id) generator;

- (id) initGenerator;

@end
