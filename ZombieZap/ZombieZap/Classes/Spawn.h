//
//  Spawn.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/6/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class Pair;

@interface Spawn : CCNode {

	Pair *startPos_;
	
	Pair *objective_;
}

@property(nonatomic, readonly) Pair *startPos;
@property(nonatomic, readonly) Pair *objective;

+ (id) spawn:(CGFloat)interval location:(Pair *)location obj:(Pair *)obj pathNum:(NSUInteger)pathNum;

- (id) initSpawn:(CGFloat)interval location:(Pair *)location obj:(Pair *)obj pathNum:(NSUInteger)pathNum;

@end
