//
//  MenuScene.m
//  Ginko
//
//  Created by jrk on 24.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "GameScene.h"
#import "GameInfo.h"
#import "MenuScene.h"
#import "MenuBackgroundLayer.h"
#import "MainMenuLayer.h"
#import "HelpMenuLayer.h"


@implementation MenuScene

enum MenuSceneNodeTags 
{
	kMenuBackgroundLayer,
	kMainMenuLayer
};

- (id) init
{
	NSLog(@"MenuScene Init");
	self = [super init];
	if (self)
	{
		MenuBackgroundLayer *layer = [MenuBackgroundLayer node];
		[layer setPosition: cpv(480/2, 320/2)];
		
		//assign
		[self addChild: layer z: 0 tag: kMenuBackgroundLayer];
		
		MainMenuLayer *mml = [MainMenuLayer node];
		HelpMenuLayer *hml = [HelpMenuLayer node];
		

		MultiplexLayer *mplex = [MultiplexLayer layerWithLayers: mml,hml,nil];
		[mplex setPosition: cpv(0,0)];
		
		[self addChild:mplex z:1 tag: kMainMenuLayer];
		
		//retain
		[[Director sharedDirector] addEventHandler: self];
		
		
	}
	
	return self;
}

- (void) dealloc
{
	NSLog(@"menuscene dealloc");
	[self removeAllChildrenWithCleanup: YES];
//	[[self getChildByTag: kMenuBackgroundLayer] release];
//	[[self getChildByTag: kMainMenuLayer] release];
	
	[super dealloc];
}

-(void) draw
{
	//NSLog(@"hai menuscene %i",[self retainCount]);
}

# pragma mark -- menu called actions
- (void) startSinglePlayerGame
{
	NSLog(@"start single player game lol");
	
	[[GameInfo sharedInstance] reset];
	
	[[Director sharedDirector] removeEventHandler: self];
	//[[Director sharedDirector] replaceScene: [[GameScene alloc] init]];
	
	[[Director sharedDirector] replaceScene: [GameScene node]];
	//[self release];	
}

- (void) showMainMenu
{
	[[self getChildByTag: kMainMenuLayer] switchTo: 0];
}


- (void) showHelp
{
	[[self getChildByTag: kMainMenuLayer] switchTo: 1];
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

