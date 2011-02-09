//
//  ZombieZapAppDelegate.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 2/8/11.
//  Copyright Paul Vishayanuroj 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface ZombieZapAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
