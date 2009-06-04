//
//  PlayerController.m
//  Ginko
//
//  Created by jrk on 25.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "PlayerController.h"
#import "Waypoint.h"
#import "GameInfo.h"
#import "GameScene.h"

@implementation PlayerController
//@synthesize controlledSprite;
//@synthesize gridPosition;
@synthesize isMoving;

#pragma mark -- init / dealloc
- (id) initWithSprite: (Sprite *) spriteToControll
{
	self = [super initWithSprite: spriteToControll];
	if (self)
	{
		isMoving = NO;
		spriteFrame = 1;
		frameThreshold = 0;
		initialTexture = [spriteToControll texture];
		frame0 = [[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:@"player0.png"]] retain];
		frame1 = [[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:@"player1.png"]] retain];
		frame2 = [[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:@"player2.png"]] retain];
		frame3 = [[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:@"player3.png"]] retain];
		frame4 = [[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:@"player4.png"]] retain];
		frame5 = [[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:@"player5.png"]] retain];
		frame6 = [[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:@"player6.png"]] retain];
		
//		playerShadow = [[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:@"player_shadow.png"]] retain];
		
		rotadd = 0.0;
		frameAdd = 1;
		lastX = [controlledSprite position].x / 32;
		lastY = [controlledSprite position].y / 32;
		

		
		if( gettimeofday( &lastUpdated, NULL) != 0 ) {
			NSException* myException = [NSException
										exceptionWithName:@"GetTimeOfDay"
										reason:@"GetTimeOfDay abnormal error"
										userInfo:nil];
			@throw myException;
		}
		
	}
	
	return self;
}

- (void) dealloc
{
	[controlledSprite setTexture: initialTexture];
	
	[controlledSprite stopAllActions];
	[frame0 release];
	[frame1 release];
	[frame2 release];
	[frame3 release];
	[frame4 release];
	[frame5 release];
	[frame6 release];
	

	
	NSLog(@"player controller dealloc");
	[super dealloc];
}
#pragma mark gameLogic
- (void) update
{
	//gridPosition = cpv([controlledSprite position].x/32,[controlledSprite position].y/32);
	[super update];
	int curx = [controlledSprite position].x / 32;
	if (curx != lastX)
	{
		lastX = curx;
		[[GameInfo sharedInstance] setScore: [[GameInfo sharedInstance] score] + 1];
	}
	
	int cury = [controlledSprite position].y / 32;
	if (cury != lastY)
	{
		lastY = cury;
		[[GameInfo sharedInstance] setScore: [[GameInfo sharedInstance] score] + 1];
	}
	
	
	struct timeval now;
	
	if( gettimeofday( &now, NULL) != 0 ) {
		NSException* myException = [NSException
									exceptionWithName:@"GetTimeOfDay"
									reason:@"GetTimeOfDay abnormal error"
									userInfo:nil];
		@throw myException;
	}
	

	float dt;
	
	dt = (now.tv_sec - lastUpdated.tv_sec) + (now.tv_usec - lastUpdated.tv_usec) / 1000000.0f;
	dt = MAX(0,dt);
	lastUpdated = now;	
	
	if (isMoving)
	{	
		frameThreshold += dt;
		if (frameThreshold > 0.10)
		{
			frameThreshold = 0.0f;
			spriteFrame += frameAdd;
			if (spriteFrame > 6)
			{
				spriteFrame = 0;
				//frameAdd = -1;
			}
			if (spriteFrame < 0)
			{
				spriteFrame = 0;
				frameAdd = 1;
			}
			
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
			if (spriteFrame == 5)
				[controlledSprite setTexture: frame5];
			if (spriteFrame == 6)
				[controlledSprite setTexture: frame6];
			
			
			
			//printf("frame: %i\n",spriteFrame);
		}
	}
	else
	{
		spriteFrame = 0;
		[controlledSprite setTexture: frame0];
		
	}
	

	


}

#pragma mark private managment funcs
- (void) _movementActionEnded
{
	isMoving = NO;
//	[controlledSprite setRotation: [controlledSprite rotation]-90];
	[controlledSprite stopAllActions];	
	[self update];
	//NSLog(@"%f,%f",gridPosition.x,gridPosition.y);
	

	//player dies :(
	//not the perfect place for this ... as there might be deadly blocks later
	if (((int)gridPosition.x) < 0 || ((int)(gridPosition.x)) >= [[GameInfo sharedInstance] levelGridWidth] ||
		((int)gridPosition.y) < 0 || ((int)(gridPosition.y)) >= [[GameInfo sharedInstance] levelGridHeight] )
	{
		NSLog(@"O M F G DIE DIE DIE DIE DI DEE DEDEDEDE NOOOOOOOOOOOOOOOOOO");
		GameScene *currentScene = [[Director sharedDirector] runningScene];
		[currentScene resetScene];
	}
	
	if (gridPosition.x == [[GameInfo sharedInstance] finishPosition].x &&
		gridPosition.y == [[GameInfo sharedInstance] finishPosition].y)
	{
		NSLog(@"WIN WIN WIN! %i",[self retainCount]);
		
		GameScene *currentScene = [[Director sharedDirector] runningScene];

		[currentScene loadNextLevel];
//		[[Director sharedDirector] pause];
	}
	
}


- (void) moveAlongPath: (NSArray *) path
{
	if (isMoving)
	{	
		for (NSValue *waypoint in path)
		{
			[waypoint release];
		}
		
		[path release];
		return;
	}
//	NSLog(@"path length: %i",[path count]);
	if ([path count] <= 0)
		return;
	
	isMoving = YES;
	lastX = [controlledSprite position].x / 32;
	lastY = [controlledSprite position].y / 32;
	
	Sequence *tmpseq = [Sequence actions:[MoveBy actionWithDuration: 0.01 position: cpvzero],nil];
	CGPoint currentPosition = [controlledSprite position];
	for (Waypoint *waypoint in path)
	{
		//geschwindigkeit festlegen mit der wir uns bewegen
		//damit nicht alles 2 sekunden dauert, sondern je nach laenge schneller geht
		CGPoint waypointPosition = [waypoint location];
		CGPoint distance = cpvsub(waypointPosition,currentPosition);

		printf("dist: %f,%f\n",distance.x,distance.y);
		//next calc from current waypoint position
		currentPosition = waypointPosition;
		
		float len = cpvlength(distance);
		float time = 1.5f/296.0f*len;
		
		printf("TIME: %f\n",time);
//		time = 1.0f;
		
		//NSLog(@"waypoint: (%f,%f) - %@",[waypoint location].x,[waypoint location].y,[[waypoint assignedObject] controlledSprite]);
		
		id action = nil;
		//rechts
		if (distance.x > 0.0)
		{	
			action = [RotateTo actionWithDuration: 0.25 angle: 90.0f];
			tmpseq = [Sequence actionOne: tmpseq two: action];
		}

		//links
		if (distance.x  < 0.0)
		{	
			action = [RotateTo actionWithDuration: 0.25 angle: -90.0f];
			tmpseq = [Sequence actionOne: tmpseq two: action];
		}
		
		//oben
		if (distance.y > 0.0)
		{	
			action = [RotateTo actionWithDuration: 0.25 angle: 0.0f];
			tmpseq = [Sequence actionOne: tmpseq two: action];
		}
		

		//unten
		if (distance.y < 0.0)
		{	
			action = [RotateTo actionWithDuration: 0.25 angle: 180.0f];
			tmpseq = [Sequence actionOne: tmpseq two: action];
		}
		
		
		action = [MoveTo actionWithDuration: time position: waypointPosition];
		tmpseq = [Sequence actionOne: tmpseq two: action];
		[waypoint release];
	}
//	NSLog(@"retcount: %i",[self retainCount]);
	id fc = [CallFunc actionWithTarget: self selector: @selector(_movementActionEnded)];
	tmpseq = [Sequence actionOne: tmpseq two: fc];
	//NSLog(@"retcount: %i",[self retainCount]);
	
	[controlledSprite runAction: tmpseq];
	[path release];
}


@end


@implementation PlayerShadowController
@synthesize playerSprite;

- (void) update
{
	float rot =	[playerSprite rotation];
	
	
	[controlledSprite setRotation: rot];
	
	cpVect pos = [playerSprite position];
	pos.x += 12;
	pos.y -= 6;
	
	[controlledSprite setPosition: pos];
}


@end
