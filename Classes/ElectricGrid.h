//
//  ElectricGrid.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 3/16/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

@class Pair;
@class Wire;

@interface ElectricGrid : NSObject {

	NSMutableDictionary *wires_;
	
}

+ (ElectricGrid *) electricGrid;

- (BOOL) addWireAtGrid:(Pair *)p wire:(Wire *)w;

- (BOOL) wireAtGrid:(Pair *)p;

- (void) updateWireAtGrid:(Pair *)p;

@end
