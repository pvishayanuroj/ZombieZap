//
//  DataManager.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 4/25/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "DataManager.h"

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
	
	}
	return self;
}

- (void) dealloc
{
	
	[super dealloc];
}

@end
