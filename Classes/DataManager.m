//
//  DataManager.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 4/25/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "DataManager.h"
#import "GameManager.h"
#import "HUDLayer.h"

// For singleton
static DataManager *_dataManager = nil;

@implementation DataManager

+ (DataManager *) dataManager
{
	if (!_dataManager)
		_dataManager = [[self alloc] init];
	
	return _dataManager;
}

+ (id) alloc
{
	NSAssert(_dataManager == nil, @"Attempted to allocate a second instance of a Data Manager singleton.");
	return [super alloc];
}

+ (void) purgeDataManager
{
	[_dataManager release];
	_dataManager = nil;
}

- (id) init
{
	if ((self = [super init]))
	{
		hudLayer_ = nil;
		
		powerDraw_ = 2;
		parts_ = 0;
		power_ = 0;
		maxPower_ = 50;
		fullGenCharge_ = 0.5f;
		
	}
	return self;
}

- (void) dealloc
{
	[hudLayer_ release];
	
	[super dealloc];
}

- (void) registerHUDLayer:(HUDLayer *)hudLayer
{
	NSAssert(hudLayer_ == nil, @"Trying to register a HUD Layer when one already exists");
	
	hudLayer_ = hudLayer;
	[hudLayer_ retain];
}

- (void) startUpdates
{
	[self schedule:@selector(updateGenSpeed:) interval:2.0/60.0];				
	[self schedule:@selector(updateGenCharge:) interval:5.0/60.0];		
	[self schedule:@selector(updatePowerDraw:) interval:60.0/60.0];				
}

- (void) updateGenSpeed:(ccTime)dt
{
	genSpeed_ = [[GameManager gameManager] getGeneratorSpeed];

	
	NSAssert(hudLayer_ != nil, @"Trying to set speed without a registered HUD Layer");	
	[hudLayer_ setGeneratorSpeed:genSpeed_];
}

- (void) updateGenCharge:(ccTime)dt
{
	power_ += (genSpeed_ * fullGenCharge_);
	
	if (power_ > maxPower_) {
		power_ = maxPower_;
	}
	
	NSAssert(hudLayer_ != nil, @"Trying to set power without a registered HUD Layer");
	[hudLayer_ setPower:power_ powerDraw:powerDraw_];
}

- (void) updatePowerDraw:(ccTime)dt
{
	power_ -= powerDraw_;
	
	if (power_ < 0) {
		power_ = 0;
	}
	
	NSAssert(hudLayer_ != nil, @"Trying to set power without a registered HUD Layer");
	[hudLayer_ setPower:power_ powerDraw:powerDraw_];
}

- (void) addPowerDraw:(CGFloat)amt
{
	powerDraw_ += amt;
}

- (void) subPowerDraw:(CGFloat)amt
{
	powerDraw_ -= amt;
}


@end
