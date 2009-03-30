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
	}
	
	return self;
}

- (void) dealloc
{
	NSLog(@"player controller dealloc");
	[super dealloc];
}
#pragma mark gameLogic

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

		//next calc from current waypoint position
		currentPosition = waypointPosition;
		
		float len = cpvlength(distance);
		float time = 1.5f/296.0f*len;
		
		//NSLog(@"waypoint: (%f,%f) - %@",[waypoint location].x,[waypoint location].y,[[waypoint assignedObject] controlledSprite]);
		
		id action = [MoveTo actionWithDuration: time position: waypointPosition];
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
