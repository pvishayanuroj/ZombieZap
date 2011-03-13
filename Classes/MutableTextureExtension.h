//
//  MutableTextureExtension.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/11/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CCTexture2DMutable.h"
#import "cocos2d.h"

@interface MutableTextureExtension : CCTexture2DMutable {
	
}

//- (id) initWithImage:(UIImage *)image

- (void) drawCircleAt:(CGPoint)origin radius:(NSUInteger)radius color:(ccColor4B)color;
- (void) drawCircleAt:(CGPoint)origin radius:(NSUInteger)radius alpha:(GLubyte)alpha;
- (void) drawFilledCircleAt:(CGPoint)origin radius:(NSUInteger)radius;
- (void) drawBresenhamCircleAt:(CGPoint)origin radius:(NSUInteger)radius color:(ccColor4B)color;
- (void) drawFilledBresenhamCircleAt:(CGPoint)origin radius:(NSUInteger)radius color:(ccColor4B)color;
- (void) drawFilledBresenhamCircleAt:(CGPoint)origin radius:(NSUInteger)radius alpha:(GLubyte)alpha;
- (void) drawHorizontalLine:(NSInteger)x1 x2:(NSInteger)x2 y:(NSInteger)y color:(ccColor4B)color;
- (void) drawHorizontalLine:(NSInteger)x1 x2:(NSInteger)x2 y:(NSInteger)y alpha:(GLubyte)alpha;
- (void) drawOpacityGradientAt:(CGPoint)origin innerR:(NSUInteger)innerR outerR:(NSUInteger)outerR innerT:(GLubyte)innerT outerT:(GLubyte)outerT;

@end
