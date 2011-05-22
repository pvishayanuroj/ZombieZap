//
//  TrackingTurret.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 4/20/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Turret.h"


@interface TrackingTurret : Turret {

	CGFloat rotationSpeed_;
	
	CGFloat turretRotation_;	
	
	BOOL isLinedUp_;	
	
    NSString *spriteFileName_;
    
	NSInteger spriteFacing_;
	
	NSUInteger spriteRotationInterval_;	
	
	NSMutableArray *sprites_;
	
}

+ (id) trackingTurretWithPos:(Pair *)startPos filename:(NSString *)filename;

- (id) initTrackingTurretWithPos:(Pair *)startPos filename:(NSString *)filename;

- (void) update:(ccTime)dt;

- (void) trackingRoutine;

- (void) spriteSelectionRoutine; 

- (void) attackingRoutine;

@end
