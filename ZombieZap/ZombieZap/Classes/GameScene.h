//
//  GameScene.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 1/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class Spotlight;
@class BuildLayer;

@interface GameScene : CCScene {

	Spotlight *s1, *s2, *s3;
	
}

- (void) addButtons:(BuildLayer *)buildLayer;

- (void) animationLoader:(NSString *)unitListName spriteSheetName:(NSString *)spriteSheetName;

@end
