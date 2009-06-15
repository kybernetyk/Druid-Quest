//
//  TeleporterController.m
//  Ginko
//
//  Created by jrk on 15.06.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "TeleporterController.h"
#import "GameInfo.h"

@implementation TeleporterController
@synthesize linkedTeleport;

- (id) initWithSprite: (Sprite *) spriteToControll
{
	self = [super initWithSprite: spriteToControll];
	if (self)
	{
		spriteFrame = 0;
		frameThreshold = 0;
		
		frame0 = [[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:@"teleporter_1.png"]] retain];
		frame1 = [[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:@"teleporter_2.png"]] retain];
		frame2 = [[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:@"teleporter_3.png"]] retain];
		frame3 = [[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:@"teleporter_4.png"]] retain];
		frame4 = [[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:@"teleporter_5.png"]] retain];
		linkedTeleport = nil;
	}
	
	return self;
}

- (void) dealloc
{
	[controlledSprite setTexture: initialTexture];
	
	[frame0 release];
	[frame1 release];
	[frame2 release];
	[frame3 release];
	[frame4 release];
	[super dealloc];
}


- (cpVect) bounceVector: (cpVect) attackVector
{
	return cpv(-1.0,-1.0);
}

- (void) update
{
	[super update];
	
	
	float dt = [[Director sharedDirector] deltaTime];
	frameThreshold += dt;
	if (frameThreshold >= 0.08)
	{
		spriteFrame ++;
		if (spriteFrame > 4)
		{
			spriteFrame = 0;
		}
		frameThreshold = 0;
	}
	//	printf("LOLO\n");		
	if (spriteFrame == 0)
		[controlledSprite setTexture: frame0];
	if (spriteFrame == 1)
		[controlledSprite setTexture: frame1];
	if (spriteFrame == 2)
		[controlledSprite setTexture: frame2];
	if (spriteFrame == 3)
		[controlledSprite setTexture: frame3];
	if (spriteFrame == 4)
		[controlledSprite setTexture: frame4];
}

@end
