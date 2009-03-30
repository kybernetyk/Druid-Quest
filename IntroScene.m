//
//  IntroScene.m
//  Ginko
//
//  Created by jrk on 24.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "IntroScene.h"
#import "MenuScene.h"
#import "GameInfo.h"

@implementation IntroScene
#define LOADING_BAR_X 480/2
#define LOADING_BAR_Y 40
#define LOADING_TAG 12

- (void) preloadingFinished
{
	isPreloading = NO;
	[self removeChildByTag: LOADING_TAG cleanup: YES];
	
	[self removeChild:loadingBar cleanup:YES];
	prevPercent = 100.0f;
	loadingBar = [Sprite spriteWithFile: [[GameInfo sharedInstance] pathForGraphicsFile: @"loading_bar_100.png"]];
	[loadingBar setPosition: cpv(LOADING_BAR_X,LOADING_BAR_Y)];
	[self addChild: loadingBar];
	
	id action1 = [FadeIn actionWithDuration: 0.5];
	id action2 = [FadeOut actionWithDuration: 0.5];
	id seq = [Sequence actions: action1,action2,nil];
	id rep = [RepeatForever actionWithAction: seq];
	
	id tap_the_screen = [Sprite spriteWithFile: [[GameInfo sharedInstance] pathForGraphicsFile: @"tap_the_screen.png"]];
	[tap_the_screen setPosition:cpv(240, 80)];
	[tap_the_screen setOpacity: 1.0f];
	[self addChild: tap_the_screen];
	[tap_the_screen runAction: rep];
	
	
}

- (void) preloadNextResource
{
	NSString *spriteFileName = [preloadArray objectAtIndex: _preloadCounter];
	NSLog(@"loading %@ ...",[[GameInfo sharedInstance] pathForGraphicsFile:spriteFileName]);
	[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:spriteFileName]];
	
	_preloadCounter ++;
	if (_preloadCounter >= [preloadArray count])
	{	
		[self preloadingFinished];
		return;
	}

	float perc = (float)_preloadCounter/(float)[preloadArray count];

	
	if (perc >= 0.75 && prevPercent != 0.75)
	{
	NSLog(@"perc: %f",perc);
		prevPercent = 0.75;
		[self removeChild:loadingBar cleanup:YES];
		
		loadingBar = [Sprite spriteWithFile: [[GameInfo sharedInstance] pathForGraphicsFile: @"loading_bar_75.png"]];
		[loadingBar setPosition: cpv(LOADING_BAR_X,LOADING_BAR_Y)];
		[self addChild: loadingBar];
	}
	if (perc >= 0.50 && perc < 0.75 && prevPercent != 0.50)
	{
			NSLog(@"perc: %f",perc);
		prevPercent = 0.50f;
		[self removeChild:loadingBar cleanup:YES];
		
		loadingBar = [Sprite spriteWithFile: [[GameInfo sharedInstance] pathForGraphicsFile: @"loading_bar_50.png"]];
		[loadingBar setPosition: cpv(LOADING_BAR_X,LOADING_BAR_Y)];
		[self addChild: loadingBar];
	}
	if (perc >= 0.25 && perc < 0.50 && prevPercent != 0.25)
	{
			NSLog(@"perc: %f",perc);
		prevPercent = 0.25f;
		[self removeChild:loadingBar cleanup:YES];
		
		loadingBar = [Sprite spriteWithFile: [[GameInfo sharedInstance] pathForGraphicsFile: @"loading_bar_25.png"]];
		[loadingBar setPosition: cpv(LOADING_BAR_X,LOADING_BAR_Y)];
		[self addChild: loadingBar];
	}
	

//	id fc = [CallFunc actionWithTarget: self selector: @selector(preloadNextResource)];
//	[self runAction: fc];

	id bla = [IntervalAction actionWithDuration: 0.05f];
	id fc = [CallFunc actionWithTarget: self selector: @selector(preloadNextResource)];
	id seq = [Sequence actions: bla,fc,nil];
	[self runAction: seq];
	
	
}

- (id) init
{
	self = [super init];
	if (self)
	{
		background = [Sprite spriteWithFile: [[GameInfo sharedInstance] pathForGraphicsFile: @"intro_1.png"]];
		[background setPosition: cpv(480/2,320/2)];

		loadingBar = [Sprite spriteWithFile: [[GameInfo sharedInstance] pathForGraphicsFile: @"loading_bar_0.png"]];
		[loadingBar setPosition: cpv(LOADING_BAR_X,LOADING_BAR_Y)];

		
		//assigns - retains also cause of NSArray
		[self addChild: background];
		[self addChild: loadingBar];
		
		
		
		id loading = [Sprite spriteWithFile: [[GameInfo sharedInstance] pathForGraphicsFile: @"loading.png"]];
		[loading setPosition:cpv(240, 80)];
//		[loading setOpacity: 1.0f];
		[self addChild: loading z: 0 tag:LOADING_TAG];
		
		
		//retained >.<
		[[Director sharedDirector] addEventHandler: self];
		
		NSLog(@"pre caching ...");
		
		isPreloading = YES;
		_preloadCounter = 0;
		prevPercent = 0.0f;
		preloadArray = [NSArray arrayWithObjects:@"medium_background.png",
						@"block_1.png",
						@"block_2.png",
						@"block_3.png",
						@"block_4.png",
						@"block_5.png",
						@"cross_down.png",
						@"cross_left.png",
						@"cross_right.png",
						@"cross_up.png",
						@"horiz_cross_back.png",
						@"large_background.png",
						@"player.png",
						@"small_background.png",
						@"vert_cross_back.png",
						nil];
		[preloadArray retain];
		id bla = [IntervalAction actionWithDuration: 0.05f];
		id fc = [CallFunc actionWithTarget: self selector: @selector(preloadNextResource)];
		id seq = [Sequence actions: bla,fc,nil];
		[self runAction: seq];

		

		
		//		node = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:spriteFileName]];
	}
	
	return self;
}

- (void) dealloc
{
	NSLog(@"intro scene dealloc");
	

	[preloadArray release];
	[super dealloc];
	//[background release];
}

-(void) draw
{
	//NSLog(@"%i",[self retainCount]);
}


- (void) proceedToMainMenuScene
{
	[[Director sharedDirector] removeEventHandler: self];
	[[Director sharedDirector] replaceScene: [MenuScene node]];
	//[self release];	
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
	
	if (!isPreloading)
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
