//
//  GreenLaser.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "TrackingTurret.h"


@interface GreenLaser : TrackingTurret {
    
}

+ (id) greenLaserWithPos:(Pair *)pos;

- (id) initGreenLaserWithPos:(Pair *)pos;

@end
