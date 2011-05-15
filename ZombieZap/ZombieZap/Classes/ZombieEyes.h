//
//  ZombieEyes.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 4/8/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"


@interface ZombieEyes : CCNode {

	CCSprite *sprite_;
	
}

+ (id) zombieEyesWithPos:(CGPoint)start;

- (id) initZombieEyesWithPos:(CGPoint)start;

@end
