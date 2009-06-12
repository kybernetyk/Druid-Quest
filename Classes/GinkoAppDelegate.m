//
//  GinkoAppDelegate.m
//  Ginko
//
//  Created by jrk on 24.03.09.
//  Copyright flux forge 2009. All rights reserved.
//

#import "GinkoAppDelegate.h"
#import "cocos2d.h"
#import "IntroScene.h"
#import "GameInfo.h"

@implementation GinkoAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application 
{    
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
	
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window retain];
	
	[window setUserInteractionEnabled:YES];
	[window setMultipleTouchEnabled:YES];
	
	//[FastDirector sharedDirector];
	[[Director sharedDirector] setPixelFormat: kRGBA8];
	[[Director sharedDirector] attachInWindow:window];


	[[Director sharedDirector] setLandscape: YES];
	[[Director sharedDirector] setDisplayFPS: NO];
	[[Director sharedDirector] setAnimationInterval:1.0/30];
	
	
	
	
    // Override point for customization after application launch
//	nameEnterViewController = nil;
	nameEnterViewController = [[NameEnterViewController alloc] initWithNibName: @"NameEnterViewController" bundle: nil];
	
	[window makeKeyAndVisible];
	[[Director sharedDirector] runWithScene: [IntroScene node]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	NSLog(@"level: %i\nscore: %i\n",[[GameInfo sharedInstance] currentLevel], [[GameInfo sharedInstance] score]);
	
	if ([[GameInfo sharedInstance] currentLevel] > 1)
		[[GameInfo sharedInstance] saveToFile];
	
	NSLog(@"will terminate biatch");
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[TextureMgr sharedTextureMgr] removeAllTextures];
}

- (void)dealloc 
{
    [window release];
    [super dealloc];
}

- (void) showHighscoreInput: (id) sender
{
	[nameEnterViewController setGameOverScene: sender];
	[window addSubview: [nameEnterViewController view]];
}

@end
