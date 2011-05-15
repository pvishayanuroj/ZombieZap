//
//  ZombieEyes.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 4/8/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "ZombieEyes.h"
#import "GameManager.h"

@implementation ZombieEyes

+ (id) zombieEyesWithPos:(CGPoint)start
{
	return [[[self alloc] initZombieEyesWithPos:start] autorelease];
}

- (id) initZombieEyesWithPos:(CGPoint)start
{
	if ((self = [super init])) {
		
		sprite_ = [[CCSprite spriteWithFile:@"zombie_eyes.png"] retain];
		[self addChild:sprite_];
		
		self.position = start;
		
		[self schedule:@selector(update:) interval:1.0/60.0];				

	}
	return self;
}

- (void) update:(ccTime)dt
{
	if ([[GameManager gameManager] isPointLit:self.position]) {
		sprite_.visible = NO;
	}
	else {
		sprite_.visible = YES;
	}
}

- (void) dealloc
{
	//NSLog(@"Zombie eyes dealloc'd");
	
	[sprite_ release];
	
	[super dealloc];
}

@end
