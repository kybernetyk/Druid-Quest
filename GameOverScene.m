//
//  GameOverScene.m
//  Ginko
//
//  Created by jrk on 04.06.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "GameOverScene.h"
#import "MenuScene.h"
#import "GameInfo.h"
#import "cocoslive.h"
#import "GinkoAppDelegate.h"

@implementation GameOverScene


- (id) init
{
	self = [super init];
	if (self)
	{
		background = [Sprite spriteWithFile: [[GameInfo sharedInstance] pathForGraphicsFile: @"end_bg.png"]];
		[background setPosition: cpv(480/2,320/2)];

		//assigns - retains also cause of NSArray
		[self addChild: background];

		
		NSString *goText = [NSString stringWithFormat:@"%@\n\n%@",[self congratulationsString], @"Fetching Scores ..."];
		
		textLabel = [Label labelWithString: goText dimensions:CGSizeMake(300,240) alignment:UITextAlignmentLeft fontName:@"Helvetica" fontSize:14];
		textLabel.position = cpv(180,150);
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
		
	//	id rolf = [ScoreServerRequest serverWithGameName:@"DuduDash" delegate: self];
	//	[rolf requestScores: kQueryFlagIgnore limit: 5 offset: 0 flags: kQueryFlagIgnore];

		[self fetchHighscores];
		
		//[[Director sharedDirector] addEventHandler: self];
	}
	
	return self;
}

- (void) fetchHighscores
{
	NSLog(@"fetching scores ...");
	
	id rolf = [ScoreServerRequest serverWithGameName:@"DuduDash" delegate: self];
	[rolf requestScores: kQueryAllTime limit: 5 offset: 0 flags: kQueryFlagIgnore];

}

- (void) dealloc
{
	NSLog(@"Game Over scene dealloc");
	
	[self removeAllChildrenWithCleanup: YES];
	//[background release];
	[super dealloc];	
}

- (void) proceedToHighscoreSubmit: (id) sender
{
	[[[UIApplication sharedApplication] delegate] showHighscoreInput: self];
}

- (void) proceedToMainMenuScene: (id) sender
{
	[[Director sharedDirector] removeEventHandler: self];
	[[Director sharedDirector] replaceScene: [MenuScene node]];
	//[self release];	
}

- (NSString *) congratulationsString
{
	float rating = 1.0/([[GameInfo sharedInstance] time] + [[GameInfo sharedInstance] score]) * 300000.0f;
	NSString *ret = [NSString stringWithFormat:@"Congratulations!\nYou have found your way back!\n\nYour Score is: %i", (int)rating];

	return ret;
}

- (NSString *) worldWideHighscoreString
{
	NSString *ret = @"Online Scores:\n1800\t\tRolf\n1700\t\tOmfg\n1600\t\tBernd\n1500\t\thans\n1400\t\tigoR";
	
	
	
	return ret;
}

- (void) postHighScoresToServer
{
	id rolf = [ScoreServerPost serverWithGameName:@"DuduDash" gameKey:@"1d7d54ed0c9ca9cc7f35e6e3e7abc8fc" delegate: self];
	NSMutableDictionary *d = [NSMutableDictionary dictionary];
	
	float rating = 1.0/([[GameInfo sharedInstance] time] + [[GameInfo sharedInstance] score]) * 300000.0f;
	int minutes = [[GameInfo sharedInstance] time]/60;
	int hours = [[GameInfo sharedInstance] time]/60/60;
	int seconds = [[GameInfo sharedInstance] time];
	
	if (seconds >= 60)
		seconds = seconds%60;
	
	if (minutes >= 60)
		minutes = minutes%60;
	
	
	NSString *timeString = [NSString stringWithFormat:@"%.2i:%.2i:%.2i",hours,minutes,seconds];
	
	[d setObject:@"omegaman" forKey:@"cc_playername"];
	[d setObject:[NSNumber numberWithFloat:rating] forKey:@"cc_score"];
	[d setObject:[NSNumber numberWithInt:(int)rating] forKey:@"usr_rating"];
	[d setObject:timeString forKey:@"usr_time"];
	[d setObject:[NSNumber numberWithInt:(int)[[GameInfo sharedInstance] score]] forKey:@"usr_steps"];
	
	
	
	d = [NSDictionary dictionaryWithDictionary: d];
	[rolf sendScore: d];
}



-(void) scoreRequestOk:(id) sender
{
	NSMutableString *scoresString = [NSMutableString string];
	NSArray *scoresArray = [sender parseScores];
	
	[scoresString appendString:@"Online Scores:\n"];
	
	for (NSDictionary *scoreEntry in scoresArray)
	{
		[scoresString appendFormat:@"%i\t\t%@\n",[[scoreEntry valueForKey:@"usr_rating"] intValue],[scoreEntry valueForKey:@"cc_playername"]];
	}
		
	NSString *goText = [NSString stringWithFormat:@"%@\n\n%@",[self congratulationsString], scoresString];
	[textLabel setString: goText];

	
	//create submit scores button - we're online!
	MenuItem *submitScoresItem = [MenuItemFont itemFromString:@"[ Submit Score ]"
													   target:self
													 selector:@selector(proceedToHighscoreSubmit:)];
	Menu *menu = [Menu menuWithItems: submitScoresItem, nil];
	[menu alignItemsVertically];
	menu.position = cpv(100,25);
	[self addChild: menu];
	
	
}

-(void) scoreRequestFail:(id) sender
{
	NSLog(@"score req failed!");


	NSString *goText = [NSString stringWithFormat:@"%@\n\n%@",[self congratulationsString], @"Error fetching online scores ..."];
	
	[textLabel setString: goText];
	
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
