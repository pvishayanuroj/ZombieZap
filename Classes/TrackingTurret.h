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
	
	NSInteger spriteFacing_;
	
	NSUInteger spriteRotationInterval_;	
	
	NSMutableArray *sprites_;
	
}

+ (id) trackingTurretWithPos:(Pair *)startPos;

- (id) initTrackingTurretWithPos:(Pair *)startPos;

- (void) update:(ccTime)dt;

- (void) trackingRoutine;

- (void) spriteSelectionRoutine; 

- (void) attackingRoutine;

/** Angle from point a to point b. Returns values between -pi/2 and 3*pi/2 increasing in a CCW direction. The right is considered 0 degrees. */
- (CGFloat) getAngleFrom:(CGPoint)a to:(CGPoint)b;

@end
