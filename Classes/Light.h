//
//  Light.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Tower.h"

@class Spotlight;

@interface Light : Tower {

	Spotlight *spotlight_;

}

@property (nonatomic, readonly) Spotlight *spotlight;

+ (id) lightWithPos:(Pair *)startPos spot:(Spotlight *)spot;

- (id) initLightWithPos:(Pair *)startPos spot:(Spotlight *)spot;

- (void) takeDamage:(CGFloat)damage;

- (void) lightDeath;

@end
