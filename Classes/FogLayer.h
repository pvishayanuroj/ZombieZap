//
//  FogLayer.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/8/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class CCMutableTexture2D;
@class MutableTextureExtension;
@class Spotlight;

struct ZZBox {
	NSInteger x1;
	NSInteger x2;
	NSInteger y1;
	NSInteger y2;
};
typedef struct ZZBox ZZBox;



@interface FogLayer : CCLayer {

	CCSprite *fog_;
	
	CCMutableTexture2D *mutableFog_;
		
	MutableTextureExtension *tempTexture_;
	
	GLubyte fogAlpha_;
	
	unsigned char changedAlphas_[1024][1024];
	
	unsigned char alphaTable_[256][256];
}

- (Spotlight *) drawSpotlight:(CGPoint)origin radius:(NSUInteger)radius;

- (void) removeSpotlight:(Spotlight *)spotlight;

- (void) updateFog;

@end
