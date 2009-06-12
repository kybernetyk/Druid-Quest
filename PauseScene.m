//
//  PauseScene.m
//  Ginko
//
//  Created by jrk on 07.04.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "PauseScene.h"
#import "PauseBackgroundLayer.h"
#import "PauseMenuLayer.h"
#import "GameInfo.h"

@implementation PauseScene
- (id) init
{
	NSLog(@"MenuScene Init");
	self = [super init];
	if (self)
	{
		PauseBackgroundLayer *layer = [PauseBackgroundLayer node];
		[layer setPosition: cpv(480/2, 320/2)];
		[self addChild: layer];

		PauseMenuLayer *pml = [PauseMenuLayer node];
		[pml setPosition: cpv(0, 0)];
		[self addChild: pml];

		[[GameInfo sharedInstance] saveToFile];
	}
	return self;
}

@end
