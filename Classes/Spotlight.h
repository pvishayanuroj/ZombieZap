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

	unsigned char *pixels_;
	
	CGFloat radius_;
	
	CGPoint position_;
	
	CGPoint pixelsOffset_;
	
	NSUInteger pixelsYSize_;
	
	NSUInteger pixelsSize_;
	
}

@property (nonatomic, readonly) unsigned char *pixels;
@property (nonatomic, readonly) NSUInteger pixelsSize;
@property (nonatomic, readonly) NSUInteger pixelsYSize;
@property (nonatomic, readonly) CGPoint pixelsOffset;
@property (nonatomic, readonly) CGFloat radius;
@property (nonatomic, readonly) CGPoint position;

+ (id) spotlight:(CGPoint)pos radius:(CGFloat)radius texture:(MutableTextureExtension *)texture;

- (id) initSpotlight:(CGPoint)pos radius:(CGFloat)radius texture:(MutableTextureExtension *)texture;

- (void) addPixel:(CGPoint)pos alpha:(GLubyte)alpha;

@end
