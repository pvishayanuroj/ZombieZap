//
//  Pellet.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "TrackingTurret.h"


@interface Pellet : TrackingTurret {
    
}

+ (id) pelletWithPos:(Pair *)pos;

- (id) initPelletWithPos:(Pair *)pos;

- (void) getPlacement:(CGPoint)a b:(CGPoint)b deg:(CGFloat *)deg x:(NSInteger *)x y:(NSInteger *)y;

@end 
