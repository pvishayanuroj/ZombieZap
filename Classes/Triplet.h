//
//  Triplet.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/11/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Triplet : NSObject {

	NSInteger x_;
	
	NSInteger y_;
	
	NSInteger z_;	
	
}

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;
@property (nonatomic, assign) NSInteger z;

+ (id) triplet:(NSInteger)a b:(NSInteger)b c:(NSInteger)c;

- (id) initTriplet:(NSInteger)a b:(NSInteger)b c:(NSInteger)c;

@end
