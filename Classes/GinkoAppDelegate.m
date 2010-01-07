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
#import "cocoslive.h"

@implementation GinkoAppDelegate

@synthesize window;
@synthesize isMusicPlaybackEnabled;

- (void) playMenuMusic
{
	if (!isMusicPlaybackEnabled)
	{
		whichMusicIsPlaying = kGinkoMusicNone;
		return;
	}

	if (whichMusicIsPlaying == kGinkoMusicMenuTheme)
		return;
	whichMusicIsPlaying = kGinkoMusicMenuTheme;
	[audioplayer stop];
	[audioplayer release];
	audioplayer = nil;
	
	NSError *error;
	NSURL *url = [NSURL  fileURLWithPath: [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"m4a"] ];

	audioplayer = [[AVAudioPlayer alloc] initWithContentsOfURL: url error: &error];
	[audioplayer setNumberOfLoops: -1]; //repeat bitch
	NSLog(@"avp: %@ error: %@",audioplayer, error);
	//NSLog(@"starting music: %i",[audioplayer play]);
		[audioplayer play];
}

- (void) playGameMusic
{
	if (!isMusicPlaybackEnabled)
	{
		whichMusicIsPlaying = kGinkoMusicNone;
		return;
	}
	
	if (whichMusicIsPlaying == kGinkoMusicGameTheme)
		return;
	whichMusicIsPlaying = kGinkoMusicGameTheme;
	
	[audioplayer stop];
	[audioplayer release];
	audioplayer = nil;

	NSError *error;
	NSURL *url = [NSURL  fileURLWithPath: [[NSBundle mainBundle] pathForResource:@"game" ofType:@"m4a"] ];

	audioplayer = [[AVAudioPlayer alloc] initWithContentsOfURL: url error: &error];
	[audioplayer setNumberOfLoops: -1]; //repeat bitch
	NSLog(@"avp: %@ error: %@",audioplayer, error);
	//NSLog(@"starting music: %i",[audioplayer play]);
	[audioplayer play];
}

- (void) playScoreMusic
{
	//don't play music if turned off
	//set music playing to none in case the user wants to restart the shit
	if (!isMusicPlaybackEnabled)
	{
		whichMusicIsPlaying = kGinkoMusicNone;
		return;
	}

	whichMusicIsPlaying = kGinkoMusicScoreTheme;
	[audioplayer stop];
	[audioplayer release];
	audioplayer = nil;
	
	
	NSError *error;
	NSURL *url = [NSURL  fileURLWithPath: 	 [[NSBundle mainBundle] pathForResource:@"score" ofType:@"m4a"] ];

	audioplayer = [[AVAudioPlayer alloc] initWithContentsOfURL: url error: &error];
	[audioplayer setNumberOfLoops: -1]; //repeat bitch
	
	NSLog(@"avp: %@ error: %@",audioplayer, error);
	//NSLog(@"starting music: %i",[audioplayer play]);
	[audioplayer play];
}

- (void) stopMusicPlayback
{
	[audioplayer stop];
	[audioplayer release];
	audioplayer = nil;
	whichMusicIsPlaying = kGinkoMusicNone;
}

- (void) setIsMusicPlaybackEnabled:(BOOL) isIt
{
	isMusicPlaybackEnabled = isIt;
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
	[defs setBool: isMusicPlaybackEnabled forKey: @"play music"];
}

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{   
	/*
	NSMutableDictionary *d = [NSMutableDictionary dictionary];
	
	float rating = 1000;
	
	
	int minutes = 20;
	int hours = 0;
	int seconds = 0;
	
	if (seconds >= 60)
		seconds = seconds%60;
	
	if (minutes >= 60)
		minutes = minutes%60;
	

	id rolf = [ScoreServerPost serverWithGameName:@"Druid Quest" gameKey:@"3f3ef753f1cda7c134640a5bc7eefcaa" delegate: nil];
	NSString *timeString = [NSString stringWithFormat:@"%.2i:%.2i:%.2i",hours,minutes,seconds];
	[d setObject: @"Druid Quest" forKey:@"cc_playername"];
	[d setObject:[NSNumber numberWithFloat:rating] forKey:@"cc_score"];
	[d setObject:[NSNumber numberWithInt:(int)rating] forKey:@"usr_rating"];
	[d setObject:timeString forKey:@"usr_time"];
	[d setObject:[NSNumber numberWithInt:(int) 100] forKey:@"usr_steps"];
	[rolf sendScore: d];
	
	rolf = [ScoreServerPost serverWithGameName:@"Druid Quest" gameKey:@"3f3ef753f1cda7c134640a5bc7eefcaa" delegate: nil];
	
	d = [NSMutableDictionary dictionary];
	[d setObject: @"a" forKey:@"cc_playername"];
	[d setObject:[NSNumber numberWithFloat:900] forKey:@"cc_score"];
	[d setObject:[NSNumber numberWithInt:(int)900] forKey:@"usr_rating"];
	[d setObject:timeString forKey:@"usr_time"];
	[d setObject:[NSNumber numberWithInt:(int) 100] forKey:@"usr_steps"];
	d = [NSDictionary dictionaryWithDictionary: d];
	[rolf sendScore: d];
	
	rolf = [ScoreServerPost serverWithGameName:@"Druid Quest" gameKey:@"3f3ef753f1cda7c134640a5bc7eefcaa" delegate: nil];

	d = [NSMutableDictionary dictionary];
	[d setObject: @"Game" forKey:@"cc_playername"];
	[d setObject:[NSNumber numberWithFloat:800] forKey:@"cc_score"];
	[d setObject:[NSNumber numberWithInt:(int)800] forKey:@"usr_rating"];
	[d setObject:timeString forKey:@"usr_time"];
	[d setObject:[NSNumber numberWithInt:(int) 100] forKey:@"usr_steps"];
	d = [NSDictionary dictionaryWithDictionary: d];
	[rolf sendScore: d];
	
	rolf = [ScoreServerPost serverWithGameName:@"Druid Quest" gameKey:@"3f3ef753f1cda7c134640a5bc7eefcaa" delegate: nil];

	d = [NSMutableDictionary dictionary];
	[d setObject: @"by" forKey:@"cc_playername"];
	[d setObject:[NSNumber numberWithFloat:700] forKey:@"cc_score"];
	[d setObject:[NSNumber numberWithInt:(int)700] forKey:@"usr_rating"];
	[d setObject:timeString forKey:@"usr_time"];
	[d setObject:[NSNumber numberWithInt:(int) 100] forKey:@"usr_steps"];
	d = [NSDictionary dictionaryWithDictionary: d];
	[rolf sendScore: d];

	rolf = [ScoreServerPost serverWithGameName:@"Druid Quest" gameKey:@"3f3ef753f1cda7c134640a5bc7eefcaa" delegate: nil];

	d = [NSMutableDictionary dictionary];
	[d setObject: @"Flux Forge" forKey:@"cc_playername"];
	[d setObject:[NSNumber numberWithFloat:600] forKey:@"cc_score"];
	[d setObject:[NSNumber numberWithInt:(int)600] forKey:@"usr_rating"];
	[d setObject:timeString forKey:@"usr_time"];
	[d setObject:[NSNumber numberWithInt:(int) 100] forKey:@"usr_steps"];
	d = [NSDictionary dictionaryWithDictionary: d];
	[rolf sendScore: d];
	
	
	
	return;
	*/
	NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];

	
	NSDictionary *thedefs = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool: YES] forKey: @"play music"];

	[defs registerDefaults: thedefs];

	
	[self setIsMusicPlaybackEnabled: [defs boolForKey:@"play music"]];
	[self playMenuMusic];
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
	
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window retain];
	
	[window setUserInteractionEnabled:YES];
	[window setMultipleTouchEnabled:YES];
	
	
//	[Director useFastDirector];
	
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
	
	
	
	// Make this interesting.  
	splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];  
	splashView.image = [UIImage imageNamed:@"Default.png"];  
	[window addSubview:splashView];  
	[window bringSubviewToFront:splashView];  
	[UIView beginAnimations:nil context:nil];  
	[UIView setAnimationDuration:1.5];  
	[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:window cache:YES];  
	[UIView setAnimationDelegate:self];   
	[UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];  
	splashView.alpha = 0.0;  
	splashView.frame = CGRectMake(-60, -85, 440, 635);  
	[UIView commitAnimations];  
	
	
	
	[[Director sharedDirector] runWithScene: [IntroScene node]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	//NSLog(@"level: %i\nscore: %i\n",[[GameInfo sharedInstance] currentLevel], [[GameInfo sharedInstance] score]);
	
	if ([[GameInfo sharedInstance] currentLevel] > 1)
		[[GameInfo sharedInstance] saveToFile];
	
	//NSLog(@"will terminate biatch");
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[TextureMgr sharedTextureMgr] removeAllTextures];
}

- (void)dealloc 
{
	[audioplayer stop];
	[audioplayer release];
	audioplayer = nil;
	
	
    [window release];
    [super dealloc];
}

- (void) showHighscoreInput: (id) sender
{
	[nameEnterViewController setGameOverScene: sender];
	[window addSubview: [nameEnterViewController view]];
}

@end
