//
//  TargetedAction.h
//  PrototypeZero
//
//  Created by Paul Vishayanuroj on 2/6/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@interface TargetedAction : CCActionInterval
{
	/**
	 The "real" target of the action
	 */
	id forcedTarget;
	
	/**
	 The actual action that will be run
	 */
	CCFiniteTimeAction* action_;
	
}

+ (id) actionWithTarget:(id)target actionIn:(CCFiniteTimeAction*)action;

- (id) initWithTarget:(id)target actionIn:(CCFiniteTimeAction*)daction;

@end
