//
//  Damage.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/16/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"


@interface Damage : CCNode {

	CCSprite *sprite_;
	
}

+ (id) damageFrom:(CGPoint)from to:(CGPoint)to;

- (id) initDamageFrom:(CGPoint)from to:(CGPoint)to;

- (CGFloat) getAngleFrom:(CGPoint)a to:(CGPoint)b;

@end
