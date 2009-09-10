//
//  HelpMenuLayer.m
//  Ginko
//
//  Created by jrk on 24.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "HelpMenuLayer.h"


@implementation HelpMenuLayer

enum HelpMenuLayerTags {
	kBackgroundImage,
	kHelpMenu
};


- (id) init
{
	self = [super init];
	
	if (self)
	{
//		Sprite *backgroundImage = [Sprite spriteWithFile: @"help_background.png"];
//		[backgroundImage setPosition:cpv(480/2, 320/2)];
		
		//assign
		//[self addChild:backgroundImage z: 0 tag: kBackgroundImage];
		
		
/*		MenuItem *ret = [MenuItemFont itemFromString:@"Return"
												target:self
											  selector:@selector(showMainMenu:)];
		
		
		
        Menu *menu = [Menu menuWithItems: ret, nil];*/
		
		//[Menu menuWithItems:start, help, nil];
       // [menu alignItemsVertically];
		
//		[menu setPosition: cpv(420,300)];
		
		
//		[self addChild: menu z: 0 tag: kHelpMenu];
		
		Label *name = [Label labelWithString:@"Help\rUse the arrows on the edge of the screen\rto navigate through the labyrinth.\r\rMove the druid to the magic stone\rto reach the next level.\r\rAvoid getting lost in the woods.\r\rMaster all levels to help\rthe druid find his way back home!"
								  dimensions:CGSizeMake(480,320) alignment:UITextAlignmentCenter fontName:@"Helvetica" fontSize:14];
		
		[name setPosition: cpv(240,100)];
		
		[self addChild:name];
		
	}
	
	return self;
}

- (void) showMainMenu: (id) sender
{
	[parent switchTo: 0];
}

@end
