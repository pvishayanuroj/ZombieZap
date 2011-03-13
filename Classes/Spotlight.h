//
//  Spotlight.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/11/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class MutableTextureExtension;

@interface Spotlight : NSObject {

	NSMutableArray *pixels_;
	
	CGFloat radius_;
	
	CGPoint position_;
	
}

@property (nonatomic, readonly) NSArray *pixels;
@property (nonatomic, readonly) CGFloat radius;
@property (nonatomic, readonly) CGPoint position;

+ (id) spotlight:(CGPoint)pos radius:(CGFloat)radius texture:(MutableTextureExtension *)texture;

- (id) initSpotlight:(CGPoint)pos radius:(CGFloat)radius texture:(MutableTextureExtension *)texture;

- (void) addPixel:(CGPoint)pos alpha:(GLubyte)alpha;

@end
