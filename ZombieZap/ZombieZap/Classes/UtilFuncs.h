//
//  UtilFuncs.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 5/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

@interface UtilFuncs : NSObject {
    
}

/** 
    Angle from point a to point b. Returns values between -pi/2 and 3*pi/2 increasing in a CCW direction. 
    The right is considered 0 degrees. 
 */
+ (CGFloat) getAngleFrom:(CGPoint)a to:(CGPoint)b;

/** Returns the Euclidean distance between two points */
+ (CGFloat) euclideanDistance:(CGPoint)a b:(CGPoint)b;

/** Returns the Euclidean distance between two points without square rooting */
+ (CGFloat) distanceNoRoot:(CGPoint)a b:(CGPoint)b;

@end
