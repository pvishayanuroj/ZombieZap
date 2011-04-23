//
//  UnitMenu.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 4/20/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "UnitMenu.h"
#import "Constants.h"
#import "Pair.h"

@implementation UnitMenu

+ (id) unitMenu
{
	return [[[self alloc] initUnitMenu] autorelease];	
}

+ (id) unitMenuWithHUDButtons:(NSArray *)buttons
{
	return [[[self alloc] initUnitMenuWithHUDButtons:buttons] autorelease];	
}

- (id) initUnitMenu
{
	if ((self = [super initWithItems:nil vaList:nil])) {
		hudStartPositions = [[NSMutableArray alloc] initWithCapacity:5];
		hudEndPositions = [[NSMutableArray alloc] initWithCapacity:5];
		
		position_ = CGPointZero;
		visible_ = NO;
	}
	return self;
}

- (id) initUnitMenuWithHUDButtons:(NSArray *)buttons
{
	if ((self = [self initUnitMenu])) {
		
		for (CCMenuItemImage *button in buttons) {
			button.scale = HUD_TOGGLESCALE;
			[self addChild:button];
		}
		
		[self repositionButtons];
	}
	return self;
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	CCMenuItem *item = [self itemForTouch:touch];
	
	if (item) {
		item.scale = HUDBUTTON_SCALETO;
		wasSelected = item; 
	}
	
	return [super ccTouchBegan:touch withEvent:event];
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CCMenuItem *item = [self itemForTouch:touch];
	
	// If we are moving off a button
	if (item == nil && wasSelected != nil) {
		wasSelected.scale = 1.0f;
		wasSelected = nil;
	}	
	// If we are moving onto a button
	if (item != nil && wasSelected == nil) {
		selectedItem_.scale = HUDBUTTON_SCALETO;
		wasSelected = selectedItem_;
	}
	
	[super ccTouchMoved:touch withEvent:event];
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	if (selectedItem_) {
		selectedItem_.scale = 1.0f;
	}
	[super ccTouchEnded:touch withEvent:event];
}

- (void) addHUDButton:(NSString *)normalImage selectedImage:(NSString *)selectedImage disabledImage:(NSString *)disabledImage target:(id)target selector:(SEL)callback str:(NSString *)str
{
	CCMenuItemImage *button = [CCMenuItemImage itemFromNormalImage:normalImage selectedImage:selectedImage disabledImage:disabledImage target:target selector:callback];
	[button setIsEnabled:NO];
	button.scale = HUD_TOGGLESCALE;
	
	[self addChild:button];
	
	[self repositionButtons];
}

- (void) repositionButtons
{
	CCArray *hudButtons = self.children;
	
	// Clear the HUD start and end positions
	[hudStartPositions removeAllObjects];
	[hudEndPositions removeAllObjects];
	
	// Corner case for one button (we don't want it on top, so force it to the right)
	if (hudButtons.count == 1) {
		CGFloat degree = 180;
		
		[hudStartPositions addObject:[self calculateHUDPosition:degree offset:HUD_NEAROFFSET]];
		[hudEndPositions addObject:[self calculateHUDPosition:degree offset:HUD_FAROFFSET]];
		
	}
	// If there are an even number of HUD buttons
	else if (hudButtons.count % 2 == 0) {
		for (int i = 0; i < hudButtons.count; i++) {
			Pair *startPos;
			Pair *endPos;
			// Create the first half of the positions
			if (i < hudButtons.count / 2) {
				CGFloat degree = (i * 360 / hudButtons.count);
				
				startPos = [self calculateHUDPosition:degree offset:HUD_NEAROFFSET];
				endPos = [self calculateHUDPosition:degree offset:HUD_FAROFFSET];
			}
			// Mirror the coordinates for the rest of the positions
			else {
				Pair *tempStartPos = [hudStartPositions objectAtIndex:(i - (hudButtons.count / 2))];
				Pair *tempEndPos = [hudEndPositions objectAtIndex:(i - (hudButtons.count / 2))];
				
				startPos = [Pair pair:(-1)*tempStartPos.x second:(-1)*tempStartPos.y];
				endPos = [Pair pair:(-1)*tempEndPos.x second:(-1)*tempEndPos.y];
			}
			
			[hudStartPositions addObject:startPos];
			[hudEndPositions addObject:endPos];
		}
	}
	// If there are an odd number of HUD buttons
	else {
		for (int i = 0; i < hudButtons.count; i++) {
			Pair *startPos;
			Pair *endPos;
			// Create the first half of the positions + 1 (for the top item)
			if (i < (hudButtons.count + 1) / 2) {
				CGFloat degree = (i * 360 / hudButtons.count) + 90;
				
				startPos = [self calculateHUDPosition:degree offset:HUD_NEAROFFSET];
				endPos = [self calculateHUDPosition:degree offset:HUD_FAROFFSET];
			}
			// Mirror the rest
			else {
				Pair *tempStartPos = [hudStartPositions objectAtIndex:(i - (hudButtons.count - i))];
				Pair *tempEndPos = [hudEndPositions objectAtIndex:(i - (hudButtons.count - i))];
				
				startPos = [Pair pair:(-1)*tempStartPos.x second:tempStartPos.y];
				endPos = [Pair pair:(-1)*tempEndPos.x second:tempEndPos.y];
			}
			
			// For odd number of HUD buttons, once you start mirroring
			// you need to insert the result at the front of the queue
			// to get the ordering correct
			if (i >= (hudButtons.count + 1) / 2 ) {
				[hudStartPositions insertObject:startPos atIndex:0];
				[hudEndPositions insertObject:endPos atIndex:0];
			}
			else {
				[hudStartPositions addObject:startPos];
				[hudEndPositions addObject:endPos];
			}
		}
	}
	
	for (int i = 0; i < hudButtons.count; i++) {
		// Set the button start positions.
		CCMenuItemImage *button = [hudButtons objectAtIndex:i];
		Pair *startPos = [hudStartPositions objectAtIndex:i];
		
		button.position = CGPointMake(startPos.x, startPos.y);
	}
}

- (Pair *) calculateHUDPosition:(CGFloat)degree offset:(NSUInteger)offset
{
	CGFloat radian = CC_DEGREES_TO_RADIANS(degree);
	
	CGFloat cosTheta = cos(radian);
	CGFloat sinTheta = sin(radian);
	
	NSInteger x = (-1)*((self.parent.contentSize.width / 2) + offset) * cosTheta;
	NSInteger y = ((self.parent.contentSize.height / 2) + offset) * sinTheta;
	
	return [Pair pair:x second:y];
}

- (void) toggleButtonsOnWithAnimation:(BOOL)animate
{
	// Already on
	if (self.visible) {
		return;
	}
	
	CCArray *buttons = self.children;	
	self.visible = YES;
	
	// With animation
	if (animate) {
		
		// Unhides the buttons, moves the buttons out, scales them up
		for (int i = 0; i < buttons.count; i++) {
			Pair *pair = [hudEndPositions objectAtIndex:i];
			CCMoveTo *moveAction = [CCMoveTo actionWithDuration:HUD_TOGGLESPEED position:CGPointMake(pair.x, pair.y)];
			CCScaleTo *scaleAction = [CCScaleTo actionWithDuration:HUD_TOGGLESPEED scale:1.0f];
			CCAction *spawn = [CCSpawn actionOne:moveAction two:scaleAction];
			
			[(CCMenuItemImage *)[buttons objectAtIndex:i] runAction:spawn];
		}
		
		for (CCMenuItem *button in self.children) {
			[button setIsEnabled:YES];
		}
	}
	// Else no animation
	else {
		for (int i = 0; i < buttons.count; i++) {
			CCMenuItem *button = [buttons objectAtIndex:i];
			Pair *p = [hudEndPositions objectAtIndex:i];
			button.position = CGPointMake(p.x, p.y);
			button.scale = 1.0f;
			[button setIsEnabled:YES];		
		}
	}
}

- (void) toggleButtonsOffWithAnimation:(BOOL)animate
{
	// Already off
	if (!self.visible) {
		return;
	}
	
	self.visible = NO;
	CCArray *buttons = self.children;	
	
	// With animation
	if (animate) {
		// Hides the buttons, moves them in, and scales them down
		for (int i = 0; i < buttons.count; i++) {
			Pair *pair = [hudStartPositions objectAtIndex:i];
			CCMoveTo *moveAction = [CCMoveTo actionWithDuration:HUD_TOGGLESPEED position:CGPointMake(pair.x, pair.y)];
			CCScaleTo *scaleAction = [CCScaleTo actionWithDuration:HUD_TOGGLESPEED scale:HUD_TOGGLESCALE];
			CCSpawn *spawn = [CCSpawn actionOne:moveAction two:scaleAction];
			CCCallFunc *callFunc = [CCCallFunc actionWithTarget:self selector:@selector(endToggleButtons:)];
			CCSequence *sequence = [CCSequence actionOne:spawn two:callFunc];
			
			[(CCMenuItemImage *)[buttons objectAtIndex:i] runAction:sequence];
		}		
		
		for (CCMenuItem *button in self.children) {
			[button setIsEnabled:NO];
		}		
	}
	// No animation
	else {
		for (int i = 0; i < buttons.count; i++) {
			CCMenuItem *button = [buttons objectAtIndex:i];
			[button setIsEnabled:NO];				
		}				
	}
}

- (void) endToggleButtons:(id)sender
{
	self.visible = NO;
}

- (CCMenuItem *) itemForTouch: (UITouch *) touch
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
	
	for( CCMenuItem* item in children_ ) {
		
		// ignore invisible and disabled items: issue #779, #866
		if ( [item visible] && [item isEnabled] ) {
			
			CGPoint local = [item convertToNodeSpace:touchLocation];
			
			CGRect r = [item rect];
			r.origin = CGPointZero;
			
			if( CGRectContainsPoint( r, local ) )
				return item;
		}
	}
	return nil;
}

- (void) dealloc
{
	[hudStartPositions release];
	[hudEndPositions release];
	[super dealloc];
}

@end
