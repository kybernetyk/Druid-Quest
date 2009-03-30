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
	
	[FastDirector sharedDirector];
	[[Director sharedDirector] attachInWindow:window];


	[[Director sharedDirector] setLandscape: YES];
	[[Director sharedDirector] setDisplayFPS: YES];
	[[Director sharedDirector] setAnimationInterval:1.0/60];
	
	
	
    // Override point for customization after application launch
    [window makeKeyAndVisible];
	
	
	
	[[Director sharedDirector] runWithScene: [IntroScene node]];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[TextureMgr sharedTextureMgr] removeAllTextures];
}

- (void)dealloc {
    [window release];
    [super dealloc];
}


@end