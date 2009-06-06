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

		MenuItem *start = [MenuItemFont itemFromString:@"[ Start Game ]"
												target:self
											  selector:@selector(startSinglePlayerGame:)];

		MenuItem *nothing = [MenuItemFont itemFromString:@"   " target: nil selector: nil];
		
        MenuItem *help = [MenuItemFont itemFromString:@"[ Help ]"
											   target:self
											 selector:@selector(help:)];

		MenuItem *nothing2 = [MenuItemFont itemFromString:@"   " target: nil selector: nil];
		
		MenuItem *scores = [MenuItemFont itemFromString:@"[ High Scores ]"
											   target:self
											 selector:@selector(highscores:)];
		
		
        Menu *menu = [Menu menuWithItems: start,nothing, help, nothing2, scores,nil];
		
		//[Menu menuWithItems:start, help, nil];
        [menu alignItemsVertically];
		
		[self addChild: menu z: 0 tag: kMainMenu];
	}
	
	return self;
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
	[[parent parent] startSinglePlayerGame];
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
