//
//  ASNode.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 2/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Pair.h"


@interface ASNode : Pair {

	NSUInteger g_;
	
	NSUInteger h_;
	
	NSUInteger f_;
	
	ASNode *parent_;
	
}

+ (id) ASNodeWithPair:(Pair *)pair;

+ (id) ASNodeWithValues:(NSInteger)xVal yVal:(NSInteger)yVal g:(NSUInteger)g parent:(ASNode *)parent;

- (id) initASNode:(NSUInteger)xVal yVal:(NSUInteger)yVal g:(NSUInteger)g parent:(ASNode *)parent;

- (BOOL) coordinatesEqual:(Pair *)pair;

- (void) setH:(NSUInteger)value;

@property(nonatomic, assign) NSUInteger g;
@property(nonatomic, assign) NSUInteger h;
@property(nonatomic, assign) NSUInteger f;
@property(nonatomic, retain) ASNode *parent;

@end
