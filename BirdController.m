//
//  BirdController.m
//  Ginko
//
//  Created by jrk on 06.04.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "BirdController.h"
#import "GameInfo.h"

@implementation BirdController
@synthesize destPoint;

- (id) initWithSprite: (Sprite *) spriteToControll colorPrefix: (NSString *)colorPrefix
{
	self = [super initWithSprite: spriteToControll];
	if (self)
	{
		isMoving = NO;
		spriteFrame = 0;
		frameThreshold = 0;
		initialTexture = [spriteToControll texture];
//		if (colorPrefix == nil)
		{
			frame0 = [[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:@"bird0.png"]] retain];
			frame1 = [[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:@"bird1.png"]] retain];
			frame2 = [[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:@"bird2.png"]] retain];
			frame3 = [[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:@"bird3.png"]] retain];
		}
/*		else
		{
			NSString *fname0 = [NSString stringWithFormat:@"%@bird0.png",colorPrefix];
			NSString *fname1 = [NSString stringWithFormat:@"%@bird1.png",colorPrefix];
			NSString *fname2 = [NSString stringWithFormat:@"%@bird2.png",colorPrefix];
			
			GameInfo *gi = [GameInfo sharedInstance];
			NSString *path0 = [gi pathForGraphicsFile:fname0];
			NSString *path1 = [gi pathForGraphicsFile:fname1];
			NSString *path2 = [gi pathForGraphicsFile:fname2];
			
			TextureMgr *mg = [TextureMgr sharedTextureMgr];
			
			frame0 = [mg addImage: path0];
			[frame0 retain];

			frame1 = [mg addImage: path1];
			[frame1 retain];

			frame2 = [mg addImage: path2];
			[frame2 retain];

		}*/
		[controlledSprite setTexture: frame0];
		
		idleFlapTime = ((rand()%8000) / 1000.0f);
		idleTurnTime = ((rand()%8000) / 1000.0f);
		turnThreshold = flapThreshold = 0.0f;
		
		printf("flap: %f, %f\n",idleFlapTime, idleTurnTime);
		
	}
	
	return self;
}

- (void) update
{
	[super update];

	//printf("%f,%f vs. %f,%f\n",[controlledSprite position].x,[controlledSprite position].y,[player position].x,[player position].y);
	//gridPosition = cpv([controlledSprite position].x/32,[controlledSprite position].y/32);
	gridPosition = cpv(-1,-1);
	struct timeval now;
	float dt = [[Director sharedDirector] deltaTime];
	
	if (!isMoving)
	{
		Sprite *player = (Sprite*)[[controlledSprite parent] getChildByTag: 200];
		cpVect diff = cpvsub([controlledSprite position], [player position]);
		float dist = cpvlength(diff);
		
//		printf("%f: %f,%f\n",dist,diff.x,diff.y);
		flapThreshold += dt;
		if (flapThreshold >= idleFlapTime)
		{
			idleFlapTime = ((rand()%8000) / 1000.0f);
			flapThreshold = 0.0f;
			spriteFrame ++;
			if (spriteFrame > 0)
			{
				spriteFrame = 0;
			}
			
		}
		
		turnThreshold += dt;
		if (turnThreshold >= idleTurnTime)
		{
			idleTurnTime = ((rand()%8000) / 1000.0f);
			turnThreshold = 0.0f;
			[controlledSprite setScaleX: -[controlledSprite scaleX]];
			
		}
		
		if (dist <= 60.0f)
		{
			isMoving = YES;
			destPoint.x = destPoint.x * [controlledSprite scaleX];
			//flyaction = [MoveTo actionWithDuration: 10.0f position: destPoint];
	//		flyaction = [MoveBy actionWithDuration: 10.0f position: destPoint];
			
			float time = (rand()%5) + 5.0f;
			flyaction = [MoveBy actionWithDuration: time position: cpv(0.0,700.0)];
			//[flyaction retain];
			[controlledSprite runAction: flyaction];
			frameThreshold = 0.0f;
			return;
		}
	}
	else
	{
		
		
		frameThreshold += dt;
		if (frameThreshold > 0.15)
		{
			frameThreshold = 0.0f;
			spriteFrame ++;
			if (spriteFrame > 3)
			{
				spriteFrame = 1;
				//frameAdd = -1;
			}
			
		}
	}
	
			if (spriteFrame == 0)
			[controlledSprite setTexture: frame0];
			if (spriteFrame == 1)
			[controlledSprite setTexture: frame1];
			if (spriteFrame == 2)
			[controlledSprite setTexture: frame2];
			if (spriteFrame == 3)
				[controlledSprite setTexture: frame3];
			
	
	//NSLog(@"sprite controller %@ grid positon: %f,%f",self ,gridPosition.x, gridPosition.y);
}

- (void) dealloc
{
	[controlledSprite setTexture: initialTexture];
	//[flyaction stop];
//	[controlledSprite stopAction: flyaction];
	[controlledSprite stopAllActions];
	
	[frame0 release];
	[frame1 release];
	[frame2 release];
	NSLog(@"bird controller dealloc");
	[super dealloc];
}

@end
