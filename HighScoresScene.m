//
//  HighScoresScene.m
//  Ginko
//
//  Created by jrk on 06.06.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "HighScoresScene.h"
#import "MenuScene.h"
#import "GameInfo.h"
#import "cocoslive.h"
#import "GinkoAppDelegate.h"


@implementation HighScoresScene
- (id) init
{
	self = [super init];
	if (self)
	{
		Sprite *background = [Sprite spriteWithFile: [[GameInfo sharedInstance] pathForGraphicsFile: @"menu_bg.png"]];
		[background setPosition: cpv(480/2,320/2)];
		[self addChild: background];

		Label *label = [Label labelWithString:@"World Wide High Scores" fontName:@"Helvetica" fontSize: 20.0f];
		label.position = cpv(240, 300);
		[self addChild: label];
		
		
		NSString *goText = [NSString stringWithFormat: @"Fetching Scores ..."];
		
		textLabel = [Label labelWithString: goText dimensions:CGSizeMake(300,240) alignment:UITextAlignmentCenter fontName:@"Helvetica" fontSize:14];
		textLabel.position = cpv(240,150);
		[self addChild:textLabel];
		
		
		
		
		[MenuItemFont setFontSize:20];
        [MenuItemFont setFontName:@"Helvetica"];
		
		
		MenuItem *returnToMainMenu = [MenuItemFont itemFromString:@"[ Main Menu ]"
														   target:self
														 selector:@selector(proceedToMainMenuScene:)];
        Menu *menu2 = [Menu menuWithItems: returnToMainMenu, nil];
		[menu2 alignItemsVertically];
		menu2.position = cpv(380,25);
		[self addChild: menu2];
		
		[self fetchHighscores];
	}
	
	return self;
}

- (void) dealloc
{
	NSLog(@"High Scores scene dealloc");
	
	[self removeAllChildrenWithCleanup: YES];
	//[background release];
	[super dealloc];	
}



- (void) fetchHighscores
{
	NSLog(@"fetching scores ...");
	
	NSString *goText = [NSString stringWithFormat: @"Updating Scores ..."];
	[textLabel setString: goText];
	
	
	id rolf = [ScoreServerRequest serverWithGameName:@"DuduDash" delegate: self];
	[rolf requestScores: kQueryAllTime limit: 10 offset: 0 flags: kQueryFlagIgnore];
	
}

- (void) proceedToMainMenuScene: (id) sender
{
	[[Director sharedDirector] removeEventHandler: self];
	//[[Director sharedDirector] replaceScene: [MenuScene node]];
	[[Director sharedDirector] popScene];
	
	//[self release];	
}



-(void) scoreRequestOk:(id) sender
{
	NSMutableString *scoresString = [NSMutableString string];
	NSArray *scoresArray = [sender parseScores];
	
	//[scoresString appendString:@"Online Scores:\n"];
	
	int i = 1;
	for (NSDictionary *scoreEntry in scoresArray)
	{
		[scoresString appendFormat:@"%i. %i\t\t%@\n",i++,[[scoreEntry valueForKey:@"usr_rating"] intValue],[scoreEntry valueForKey:@"cc_playername"]];
	}
	
	NSString *goText = [NSString stringWithFormat: scoresString];
	[textLabel setString: goText];
	
	
}

-(void) scoreRequestFail:(id) sender
{
	NSLog(@"score req failed!");
	
	
	NSString *goText = [NSString stringWithFormat: @"Error fetching online scores ..."];
	
	[textLabel setString: goText];

}

- (NSString *) worldWideHighscoreString
{
	return @"lol";
	
}
@end
