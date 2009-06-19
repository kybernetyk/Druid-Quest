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
		
		
		MenuItem *continue_ = [MenuItemImage itemFromNormalImage:[[GameInfo sharedInstance] pathForGraphicsFile: @"menu_resume.png"] 
												selectedImage:[[GameInfo sharedInstance] pathForGraphicsFile: @"menu_resume_a.png"] 
													   target:self 
													 selector:@selector(continueGame:)];
		

		MenuItem *exit_ = [MenuItemImage itemFromNormalImage:[[GameInfo sharedInstance] pathForGraphicsFile: @"menu_exit.png"] 
												   selectedImage:[[GameInfo sharedInstance] pathForGraphicsFile: @"menu_exit_a.png"] 
														  target:self 
														selector:@selector(exitToMainMenu:)];
		
		
        Menu *menu = [Menu menuWithItems: continue_, exit_,nil];
		
		//[Menu menuWithItems:start, help, nil];
        
		[menu alignItemsVertically];
		
		[self addChild: menu];
	}
	
	return self;
}

- (void) dealloc
{
	//NSLog(@"pause menu layer dealloc");

	[self removeAllChildrenWithCleanup: YES];
	
	[super dealloc];
}

- (void) continueGame: (id) sender
{
//	[[parent parent] startSinglePlayerGame];
//	NSLog(@"continue");
	[[GameInfo sharedInstance] setIsPaused: NO];
	//[[Director sharedDirector] resume];
	[[Director sharedDirector] popScene];
}

- (void) exitToMainMenu: (id) sender
{
	//[[parent parent] showHelp];
//	NSLog(@"exit to main menu!");
	[[Director sharedDirector] popScene];
	[[Director sharedDirector] replaceScene: [MenuScene node]];
}

@end
