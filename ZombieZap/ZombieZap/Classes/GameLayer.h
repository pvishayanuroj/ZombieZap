//
//  GameLayer.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 2/9/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class Pair;

@interface GameLayer : CCLayer {

	CGPoint layerPosStart;
	CGPoint finger1Start;
	
}

- (void) debugGridInfo:(Pair *)p count:(NSInteger)count;

@end
