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
	
	/** Sprite representing the generator */	
	CCSprite *sprite_;	
	
	/** Stores the previous frame's rotation, in degrees */
	CGFloat prevRotation_;
	
	/** Stores the rotation of the wheel before it was rotated, in degrees */
	CGFloat startRotation_;	
	
	/** How much angular momentum the wheel has, in degrees/unit time */		
	CGFloat angularMomentum_;	
	
	/** Maximum amount of rotation per frame */
	CGFloat maxR_;
	
	/** */
	CGFloat maxDeltaR_;	
	
	CGFloat prevDegrees_;
	
	/** Current rotation speed */	
	CGFloat currentSpeed_;
	
	/** When determining if a touch on the wheel is valid, this is the inner radius used */	
	CGFloat innerRadius_;
	
	/** When determining if a touch on the wheel is valid, this is the outer radius used */	
	CGFloat outerRadius_;
	
	/** Used to keep track of how long the player has been spinning the wheel in order to calculate angular momentum */			
	NSInteger touchTimer_;
	
	NSInteger touchHoldTimer_;
	
	/** True if only allowed to rotate in one direction */
	BOOL dirLock_;
}

@property (nonatomic, readonly) CGFloat currentSpeed;
@property (nonatomic, readonly) CGFloat currentSpeedPct;

+ (id) generator;

- (id) initGenerator;

@end
