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
@synthesize controlledSprite;
@synthesize gridPosition;
@synthesize isMoving;

#pragma mark -- init / dealloc
- (id) initWithSprite: (Sprite *) spriteToControll
{
	self = [super initWithSprite: spriteToControll];
	if (self)
	{
		isMoving = NO;
		spriteFrame = 0;
		frameThreshold = 0;
		frame0 = [[spriteToControll texture] retain];
		frame1 = [[[TextureMgr sharedTextureMgr] addImage: [[GameInfo sharedInstance] pathForGraphicsFile:@"player1.png"]] retain];
		rotadd = 0.0;
		
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
	[frame0 release];
	[frame1 release];
	NSLog(@"player controller dealloc");
	[super dealloc];
}
#pragma mark gameLogic
- (void) update
{
	//gridPosition = cpv([controlledSprite position].x/32,[controlledSprite position].y/32);
	[super update];

	
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
		if (frameThreshold > 0.05)
		{
			frameThreshold = 0.0f;
			if (++spriteFrame > 1)
			{
				spriteFrame = 0;
			}
			
			if (spriteFrame == 0)
				[controlledSprite setTexture: frame0];
			if (spriteFrame == 1)
				[controlledSprite setTexture: frame1];
				
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
