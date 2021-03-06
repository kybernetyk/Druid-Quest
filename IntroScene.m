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
#import <AVFoundation/AVAudioPlayer.h>

unsigned long totalbytesused = 0;

@implementation IntroScene
#define LOADING_BAR_X 480/2
#define LOADING_BAR_Y 40
#define LOADING_TAG 12

- (void) preloadingFinished
{
	NSString *s = @"surprise";
	[s retain];
	[s release];
	
	
	NSLog(@"Preloaded %@ bytes",[NSNumber numberWithLong: totalbytesused]);
	
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
	id tex = [[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:spriteFileName]];
	[tex retain];
	
	//	kTexture2DPixelFormat_Automatic = 0,
//	kTexture2DPixelFormat_RGBA8888,
//	kTexture2DPixelFormat_RGB565,
//	kTexture2DPixelFormat_A8,
//	
	
	if ([tex pixelFormat] == kTexture2DPixelFormat_RGBA8888)
		totalbytesused += ([tex pixelsWide] * [tex pixelsWide] * 4);
	else if ([tex pixelFormat] == kTexture2DPixelFormat_RGB565)
		totalbytesused += ([tex pixelsWide] * [tex pixelsWide] * 2);
	
	_preloadCounter ++;
	if (_preloadCounter >= [preloadArray count])
	{	
		[self preloadingFinished];
		return;
	}

	float perc = (float)_preloadCounter/(float)[preloadArray count];

	
	if (perc >= 0.75 && prevPercent != 0.75)
	{
	//NSLog(@"perc: %f",perc);
		prevPercent = 0.75;
		[self removeChild:loadingBar cleanup:YES];
		
		loadingBar = [Sprite spriteWithFile: [[GameInfo sharedInstance] pathForGraphicsFile: @"loading_bar_75.png"]];
		[loadingBar setPosition: cpv(LOADING_BAR_X,LOADING_BAR_Y)];
		[self addChild: loadingBar];
	}
	if (perc >= 0.50 && perc < 0.75 && prevPercent != 0.50)
	{
		//	NSLog(@"perc: %f",perc);
		prevPercent = 0.50f;
		[self removeChild:loadingBar cleanup:YES];
		
		loadingBar = [Sprite spriteWithFile: [[GameInfo sharedInstance] pathForGraphicsFile: @"loading_bar_50.png"]];
		[loadingBar setPosition: cpv(LOADING_BAR_X,LOADING_BAR_Y)];
		[self addChild: loadingBar];
	}
	if (perc >= 0.25 && perc < 0.50 && prevPercent != 0.25)
	{
		//	NSLog(@"perc: %f",perc);
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
		
/*		OSStatus AudioQueueNewOutput (
									  const AudioStreamBasicDescription   *inFormat,
									  AudioQueueOutputCallback            inCallbackProc,
									  void                                *inUserData,
									  CFRunLoopRef                        inCallbackRunLoop,
									  CFStringRef                         inCallbackRunLoopMode,
									  UInt32                              inFlags,
									  AudioQueueRef                       *outAQ
									  );*/
		
//		AudioQueueRef aqref;
		
		
//		AudioQueueNewOutput (

		
		background = [Sprite spriteWithFile: [[GameInfo sharedInstance] pathForGraphicsFile: @"intro_1.png"]];
		[background setPosition: cpv(480/2,320/2)];

		loadingBar = [Sprite spriteWithFile: [[GameInfo sharedInstance] pathForGraphicsFile: @"loading_bar_0.png"]];
		[loadingBar setPosition: cpv(LOADING_BAR_X,LOADING_BAR_Y)];

		
		//assigns - retains also cause of NSArray
		[self addChild: background];
		[self addChild: loadingBar];
		
		
		
		id loading = [Sprite spriteWithFile: [[GameInfo sharedInstance] pathForGraphicsFile: @"loading.png"]];
		[loading setPosition:cpv(240, 80)];
		//[loading setOpacity: 1.0f];
		[self addChild: loading z: 10 tag:LOADING_TAG];
		
		
		//retained >.<
		[[Director sharedDirector] addEventHandler: self];
		
		//NSLog(@"pre caching ...");
		
		isPreloading = YES;
		_preloadCounter = 0;
		prevPercent = 0.0f;
		preloadArray = [NSArray arrayWithObjects:
						@"block_1_1.png",
						@"block_1_2.png",
						@"shadow_block_1_1.png",
						@"shadow_block_1_2.png",						
						@"block_2.png",
						@"block_3.png",
						@"block_4.png",
						@"block_5.png",
						@"cross_down.png",
						@"cross_left.png",
						@"cross_right.png",
						@"cross_up.png",
						@"horiz_cross_back.png",
						@"player0.png",
						@"player1.png",
						@"player2.png",
						@"player3.png",						
						@"player4.png",
						@"player5.png",
						@"player6.png",						
						@"bird0.png",
						@"bird1.png",
						@"bird2.png",
						@"bird3.png",
						@"menu_bg.png",
						@"end_bg.png",
						@"flower.png",
						@"flower2.png",
						@"gravel.png",
						@"ground.png",
						@"ground2.png",
						@"ground3.png",
						@"menu.png",
						@"menu_scroll.png",
						@"menu_exit.png",
						@"menu_help.png",
						@"menu_play.png",
						@"menu_resume.png",
						@"menu_scores.png",
						@"menu_exit_a.png",
						@"menu_help_a.png",
						@"menu_play_a.png",
						@"menu_resume_a.png",
						@"menu_scores_a.png",
						@"small_border.png",
						@"small_background.png",
						@"medium_border.png",
						@"medium_background.png",
						@"rays_small.png",
						@"rays_medium.png",
						@"vert_cross_back.png",
						@"player_shadow.png",
						@"finish_anim0.png",
						@"finish_anim1.png",
						@"finish_anim2.png",
						@"finish_anim3.png",
						@"finish_anim4.png",
						@"finish_anim5.png",
						@"finish_anim6.png",
						@"teleporter_1.png",
						@"teleporter_2.png",
						@"teleporter_3.png",
						@"teleporter_4.png",
						@"teleporter_5.png",						
						
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
	//NSLog(@"intro scene dealloc");
	

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
//	[[Director sharedDirector] replaceScene: [MenuScene node]];
	
	[[Director sharedDirector] replaceScene: [FadeTransition transitionWithDuration:0.6 scene: [MenuScene node] withColorRGB:0xffffff]];
	
	//[self release];	
}

#pragma mark -- TouchEventsDelegate implementation
- (BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//NSLog(@"touches began %@", self);
	UITouch *myTouch =  [touches anyObject];
	CGPoint location = [myTouch locationInView: [myTouch view]];
	//	NSLog(@"touchBegan at: %f, %f",location.x,location.y);
	location = [[Director sharedDirector] convertCoordinate: location];


	return kEventHandled;
}

- (BOOL)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{  
	//NSLog(@"touches moved");
	UITouch *myTouch =  [touches anyObject];
	CGPoint location = [myTouch locationInView: [myTouch view]];
	location = [[Director sharedDirector] convertCoordinate: location];
	
	return kEventHandled;
}

- (BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//NSLog(@"touches ended");
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
	//NSLog(@"touches cancelled");
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView: [touch view]];
	
	//translate location to landscape mode
	location = [[Director sharedDirector] convertCoordinate: location];
	
	return kEventHandled;
	
}


@end
