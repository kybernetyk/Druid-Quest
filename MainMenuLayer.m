//
//  MainMenuLayer.m
//  Ginko
//
//  Created by jrk on 24.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "MainMenuLayer.h"
#import "cocos2d.h"
#import "HighScoresScene.h"
#import "GameInfo.h"

@implementation MainMenuLayer
enum MainMenuLayerTags
{
	kMainMenu
};


- (id) init 
{
    self = [super init];
    if (self) 
	{
		
		[MenuItemFont setFontSize:20];
        [MenuItemFont setFontName:@"Helvetica"];

		/*MenuItem *start = [MenuItemFont itemFromString:@"[ Start Game ]"
												target:self
											  selector:@selector(startSinglePlayerGame:)];*/
		MenuItem *start = [MenuItemImage itemFromNormalImage:[[GameInfo sharedInstance] pathForGraphicsFile: @"menu_play.png"] 
											   selectedImage:[[GameInfo sharedInstance] pathForGraphicsFile: @"menu_play_a.png"] 
													  target:self 
													selector:@selector(startSinglePlayerGame:)];
		
		MenuItem *resume = [MenuItemImage itemFromNormalImage:[[GameInfo sharedInstance] pathForGraphicsFile: @"menu_resume.png"] 
											   selectedImage:[[GameInfo sharedInstance] pathForGraphicsFile: @"menu_resume_a.png"] 
													  target:self 
													selector:@selector(resumeSinglePlayerGame:)];

		
		MenuItem *scores = [MenuItemImage itemFromNormalImage:[[GameInfo sharedInstance] pathForGraphicsFile: @"menu_scores.png"] 
											   selectedImage:[[GameInfo sharedInstance] pathForGraphicsFile: @"menu_scores_a.png"] 
													  target:self 
													selector:@selector(highscores:)];
		
		MenuItem *help = [MenuItemImage itemFromNormalImage:[[GameInfo sharedInstance] pathForGraphicsFile: @"menu_help.png"] 
											   selectedImage:[[GameInfo sharedInstance] pathForGraphicsFile: @"menu_help_a.png"] 
													  target:self 
													selector:@selector(help:)];
		
		 Menu *menu = [Menu menuWithItems: start, resume, help, scores,nil];
		
/*		MenuItem *exit = [MenuItemImage itemFromNormalImage:[[GameInfo sharedInstance] pathForGraphicsFile: @"menu_play.png"] 
											   selectedImage:[[GameInfo sharedInstance] pathForGraphicsFile: @"menu_play.png"] 
													  target:self 
													selector:@selector(startSinglePlayerGame:)];*/
		
		
		//MenuItem *nothing = [MenuItemFont itemFromString:@"   " target: nil selector: nil];
		
/*		MenuItem *resume = [MenuItemFont itemFromString:@"[ Resume Game ]"
												target:self
											  selector:@selector(resumeSinglePlayerGame:)];
		
		MenuItem *nothing3 = [MenuItemFont itemFromString:@"   " target: nil selector: nil];
		
		
        MenuItem *help = [MenuItemFont itemFromString:@"[ Help ]"
											   target:self
											 selector:@selector(help:)];

		MenuItem *nothing2 = [MenuItemFont itemFromString:@"   " target: nil selector: nil];
		
		MenuItem *scores = [MenuItemFont itemFromString:@"[ High Scores ]"
											   target:self
											 selector:@selector(highscores:)];
		
		
        Menu *menu = [Menu menuWithItems: start,nothing, resume, nothing3, help, nothing2, scores,nil];*/
		
		//[Menu menuWithItems:start, help, nil];
        [menu alignItemsVertically];

		
		[self addChild: menu z: 0 tag: kMainMenu];
		
		MenuItem *musicon = [MenuItemImage itemFromNormalImage:[[GameInfo sharedInstance] pathForGraphicsFile: @"music_play.png"] 
												 selectedImage:[[GameInfo sharedInstance] pathForGraphicsFile: @"music_play.png"] 
														target: nil
													  selector:@selector(toggleMusic:)];
		
		MenuItem *musicoff = [MenuItemImage itemFromNormalImage:[[GameInfo sharedInstance] pathForGraphicsFile: @"music_pause.png"] 
												  selectedImage:[[GameInfo sharedInstance] pathForGraphicsFile: @"music_pause.png"] 
														 target: nil 
													   selector:@selector(toggleMusic:)];
		
		
		
		MenuItemToggle *tog = nil;
		
		if ([[[UIApplication sharedApplication] delegate] isMusicPlaybackEnabled])
		{	
			tog = [MenuItemToggle itemWithTarget: self selector:@selector (toggleMusic:) items: musicoff, musicon, nil];
		}
		else 
		{
			tog = [MenuItemToggle itemWithTarget: self selector:@selector (toggleMusic:) items: musicon, musicoff, nil];
		}
		
		
		[menu addChild: tog];
		[tog setPosition: cpv (-96,80)];
		//[tog setPosition: cpv(480-160,320-96)];
		
		//[self addChild: tog z: 10 tag: 0xcafe];
		
		
	}
	
	return self;
}

- (void) toggleMusic: (id) sender
{
	id del = [[UIApplication sharedApplication] delegate];
	
	if ([del isMusicPlaybackEnabled])
	{
		[del setIsMusicPlaybackEnabled: NO];
		[del stopMusicPlayback];
	}
	else 
	{
		[del setIsMusicPlaybackEnabled: YES];
		[del playMenuMusic];
	}
	
}


- (void) dealloc
{
	NSLog(@"mainmenu layer dealloc");
	[self removeChildByTag: kMainMenu cleanup: YES];
	[[self getChildByTag: kMainMenu] release];
	[super dealloc];
}

- (void) startSinglePlayerGame: (id) sender
{
	NSString *s = @"mode";
	[s retain];
	[s release];
	
	[[parent parent] startSinglePlayerGame];
}

- (void) resumeSinglePlayerGame: (id) sender
{
	[[parent parent] resumeSinglePlayerGame];
}


- (void) help: (id) sender
{
	[[parent parent] showHelp];
}

- (void) highscores: (id) sender
{
	[[Director sharedDirector] pushScene: [HighScoresScene node]];
}

@end
