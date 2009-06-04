//
//  PauseMenuLayer.m
//  Ginko
//
//  Created by jrk on 07.04.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "PauseMenuLayer.h"
#import "MenuScene.h"
#import "GameScene.h"
#import "GameInfo.h"

@implementation PauseMenuLayer
- (id) init 
{
    self = [super init];
    if (self) 
	{
		[MenuItemFont setFontSize:20];
        [MenuItemFont setFontName:@"Helvetica"];
		
		MenuItem *continue_ = [MenuItemFont itemFromString:@"[ Continue ]"
												target:self
											  selector:@selector(continueGame:)];

		MenuItem *nothing = [MenuItemFont itemFromString:@"   " target: nil selector: nil];
		
        MenuItem *exit_ = [MenuItemFont itemFromString:@"[ Main Menu ]"
											   target:self
											 selector:@selector(exitToMainMenu:)];
		
        Menu *menu = [Menu menuWithItems: continue_, nothing,exit_,nil];
		
		//[Menu menuWithItems:start, help, nil];
        
		[menu alignItemsVertically];
		
		[self addChild: menu];
	}
	
	return self;
}

- (void) dealloc
{
	NSLog(@"pause menu layer dealloc");

	[self removeAllChildrenWithCleanup: YES];
	
	[super dealloc];
}

- (void) continueGame: (id) sender
{
//	[[parent parent] startSinglePlayerGame];
	NSLog(@"continue");
	[[GameInfo sharedInstance] setIsPaused: NO];
	//[[Director sharedDirector] resume];
	[[Director sharedDirector] popScene];
}

- (void) exitToMainMenu: (id) sender
{
	//[[parent parent] showHelp];
	NSLog(@"exit to main menu!");
	[[Director sharedDirector] popScene];
	[[Director sharedDirector] replaceScene: [MenuScene node]];
}

@end
