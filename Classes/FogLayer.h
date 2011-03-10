//
//  FogLayer.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/8/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class CCMutableTexture2D;

@interface FogLayer : CCLayer {

	CCSprite *fog_;
	
	CCMutableTexture2D *mutableFog_;
	
	CCMutableTexture2D *blackFrame_;
	
	CCMutableTexture2D *tempTexture_;
	
}

- (void) drawCircleAt:(CGPoint)origin radius:(NSUInteger)radius color:(ccColor4B)color texture:(CCMutableTexture2D *)texture;
- (void) drawCircleAt:(CGPoint)origin radius:(NSUInteger)radius alpha:(unsigned char)alpha texture:(CCMutableTexture2D *)texture;
- (void) drawFilledCircleAt:(CGPoint)origin radius:(NSUInteger)radius texture:(CCMutableTexture2D *)texture;
- (void) drawBresenhamCircleAt:(CGPoint)origin radius:(NSUInteger)radius color:(ccColor4B)color texture:(CCMutableTexture2D *)texture;
- (void) drawFilledBresenhamCircleAt:(CGPoint)origin radius:(NSUInteger)radius color:(ccColor4B)color texture:(CCMutableTexture2D *)texture;
- (void) drawFilledBresenhamCircleAt:(CGPoint)origin radius:(NSUInteger)radius alpha:(unsigned char)alpha texture:(CCMutableTexture2D *)texture;
- (void) drawHorizontalLine:(NSInteger)x1 x2:(NSInteger)x2 y:(NSInteger)y color:(ccColor4B)color texture:(CCMutableTexture2D *)texture;
- (void) drawHorizontalLine:(NSInteger)x1 x2:(NSInteger)x2 y:(NSInteger)y alpha:(unsigned char)alpha texture:(CCMutableTexture2D *)texture;
- (void) drawOpacityGradientAt:(CGPoint)origin innerR:(NSUInteger)innerR outerR:(NSUInteger)outerR innerT:(NSUInteger)innerT outerT:(NSUInteger)outerT texture:(CCMutableTexture2D *)texture;
- (void) drawSpotlight:(CGPoint)origin radius:(NSUInteger)radius;
- (void) drawSpotlight2:(CGPoint)origin radius:(NSUInteger)radius;
- (void) updateFog;

@end
