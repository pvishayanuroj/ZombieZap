//
//  Light.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Tower.h"
#import "WireDelegate.h"

@class Spotlight;

@interface Light : Tower <WireDelegate> {

	Spotlight *spotlight_;
	
	CGFloat radius_;

}

@property (nonatomic, readonly) Spotlight *spotlight;

+ (id) lightWithPos:(Pair *)startPos radius:(CGFloat)radius;

+ (id) lightWithPos:(Pair *)startPos radius:(CGFloat)radius spot:(Spotlight *)spot;

- (id) initLightWithPos:(Pair *)startPos radius:(CGFloat)radius;

- (id) initLightWithPos:(Pair *)startPos radius:(CGFloat)radius spot:(Spotlight *)spot;

- (void) takeDamage:(CGFloat)damage;

- (void) lightDeath;

- (void) powerOn;

- (void) powerOff;

@end
