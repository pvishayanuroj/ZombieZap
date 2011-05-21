//
//  BlueLaser.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "TrackingTurret.h"


@interface BlueLaser : TrackingTurret {
    
}

+ (id) blueLaserWithPos:(Pair *)pos;

- (id) initBlueLaserWithPos:(Pair *)pos;

@end
