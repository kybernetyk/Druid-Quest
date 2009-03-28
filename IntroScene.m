//
//  IntroScene.m
//  Ginko
//
//  Created by jrk on 24.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "IntroScene.h"
#import "MenuScene.h"

@implementation IntroScene

- (id) init
{
	self = [super init];
	if (self)
	{
		background = [[Sprite alloc] initWithFile: @"mockup.png"];
		[background setPosition: cpv(480/2,320/2)];

		//assigns
		[self addChild: background];
		
		//retained >.<
		[[Director sharedDirector] addEventHandler: self];
	}
	
	return self;
}

- (void) dealloc
{
	NSLog(@"intro scene dealloc");
	
	[super dealloc];
	[background release];
}

-(void) draw
{
	//NSLog(@"%i",[self retainCount]);
}


- (void) proceedToMainMenuScene
{
	[[Director sharedDirector] removeEventHandler: self];
	[[Director sharedDirector] replaceScene: [[MenuScene alloc] init]];
	[self release];	
}

#pragma mark -- TouchEventsDelegate implementation
- (BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"touches began %@", self);
	UITouch *myTouch =  [touches anyObject];
	CGPoint location = [myTouch locationInView: [myTouch view]];
	//	NSLog(@"touchBegan at: %f, %f",location.x,location.y);
	location = [[Director sharedDirector] convertCoordinate: location];


	return kEventHandled;
}

- (BOOL)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{  
	NSLog(@"touches moved");
	UITouch *myTouch =  [touches anyObject];
	CGPoint location = [myTouch locationInView: [myTouch view]];
	location = [[Director sharedDirector] convertCoordinate: location];
	
	return kEventHandled;
}

- (BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"touches ended");
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView: [touch view]];
	
	//translate location to landscape mode
	location = [[Director sharedDirector] convertCoordinate: location];
	
	[self proceedToMainMenuScene];
	
	return kEventHandled;
}

- (BOOL)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"touches cancelled");
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView: [touch view]];
	
	//translate location to landscape mode
	location = [[Director sharedDirector] convertCoordinate: location];
	
	return kEventHandled;
	
}


@end
