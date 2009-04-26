//
//  FinishController.m
//  Ginko
//
//  Created by jrk on 29.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "FinishController.h"
#import "GameInfo.h"


@implementation FinishController
@synthesize animationSprite;

- (void) setAnimationSprite: (Sprite *)anim
{
	animationSprite = anim;
	initialTexture =  [anim texture];
}

- (id) initWithSprite: (Sprite *) spriteToControll
{
	self = [super initWithSprite: spriteToControll];
	if (self)
	{
		spriteFrame = 0;
		frameThreshold = 0;

		frame0 = [[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:@"finish_anim0.png"]] retain];
		frame1 = [[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:@"finish_anim1.png"]] retain];
		frame2 = [[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:@"finish_anim2.png"]] retain];
		frame3 = [[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:@"finish_anim3.png"]] retain];
		frame4 = [[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:@"finish_anim4.png"]] retain];
		frame5 = [[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:@"finish_anim5.png"]] retain];
		frame6 = [[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:@"finish_anim6.png"]] retain];

	}
	
	return self;
}

- (void) dealloc
{
	[animationSprite setTexture: initialTexture];
	
	
	[frame0 release];
	[frame1 release];
	[frame2 release];
	[frame3 release];
	[frame4 release];
	[frame5 release];
	[frame6 release];
		[super dealloc];
}
		

- (cpVect) bounceVector: (cpVect) attackVector
{
	return cpv(1.0,1.0);
}

- (void) update
{
	[super update];

	
	float dt = [[Director sharedDirector] deltaTime];
	frameThreshold += dt;
	if (frameThreshold >= 0.08)
	{
		spriteFrame ++;
		if (spriteFrame > 6)
		{
			spriteFrame = 0;
		}
		frameThreshold = 0;
	}
//	printf("LOLO\n");		
	if (spriteFrame == 0)
		[animationSprite setTexture: frame0];
	if (spriteFrame == 1)
		[animationSprite setTexture: frame1];
	if (spriteFrame == 2)
		[animationSprite setTexture: frame2];
	if (spriteFrame == 3)
		[animationSprite setTexture: frame3];
	if (spriteFrame == 4)
		[animationSprite setTexture: frame4];
	if (spriteFrame == 5)
		[animationSprite setTexture: frame5];
	if (spriteFrame == 6)
		[animationSprite setTexture: frame6];
}

@end
