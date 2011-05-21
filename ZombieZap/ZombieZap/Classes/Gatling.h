//
//  Gatling.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "TrackingTurret.h"


@interface Gatling : TrackingTurret {
    
}

+ (id) gatlingWithPos:(Pair *)pos;

- (id) initGatlingWithPos:(Pair *)pos;

@end
