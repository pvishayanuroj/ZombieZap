//
//  Quad.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Quad : NSObject {

	NSInteger x_;
	
	NSInteger y_;
	
	NSInteger z_;	
	
	NSInteger w_;		
	
}

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;
@property (nonatomic, assign) NSInteger z;
@property (nonatomic, assign) NSInteger w;

+ (id) quad:(NSInteger)a b:(NSInteger)b c:(NSInteger)c d:(NSInteger)d;

- (id) initQuad:(NSInteger)a b:(NSInteger)b c:(NSInteger)c d:(NSInteger)d;	

@end
