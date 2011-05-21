//
//  Rail.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "TrackingTurret.h"


@interface Rail : TrackingTurret {
    
}

+ (id) railWithPos:(Pair *)pos;

- (id) initRailWithPos:(Pair *)pos;

@end
