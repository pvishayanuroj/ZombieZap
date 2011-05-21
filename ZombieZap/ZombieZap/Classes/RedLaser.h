//
//  RedLaser.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "TrackingTurret.h"


@interface RedLaser : TrackingTurret {
    
}

+ (id) redLaserWithPos:(Pair *)pos;

- (id) initRedLaserWithPos:(Pair *)pos;

@end
