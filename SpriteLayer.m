//
//  SpriteLayer.m
//  Ginko
//
//  Created by jrk on 26.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "SpriteLayer.h"
#import "GameInfo.h"
#import "SpriteController.h"
#import "AngularBlockController.h"
#import "Waypoint.h"
#import "BlockFactory.h"


@implementation SpriteLayer
@synthesize playerController;

enum spriteTags 
{
	kPlayerSprite = 200
};
SpriteController *fieldcopy[32][32];

#pragma mark -- init / dealloc
- (id) initWithLevelFile: (NSString *) filename
{
	NSAssert(filename,@"Filename may not be nil!");
	
	self = [super init];
	if (self)
	{
		memset(fieldcopy,0x00,32*32*sizeof(SpriteController *));
		
		spriteControllers = [[NSMutableArray alloc] init];
		sprites = [[NSMutableArray alloc] init];
		//NSString *p = [[NSBundle mainBundle] pathForResource:@"map1" ofType:@"plist"];
	//	NSLog(@"%@",p);
		
		NSDictionary *mapInfo = [NSDictionary dictionaryWithContentsOfFile: filename];
	//	NSLog(@"dict: %@",mapInfo);
		
		NSAssert1(mapInfo,@"Error! Map File %@ not found!",filename);
		
		[[GameInfo sharedInstance] setLevelGridWidth: [[mapInfo objectForKey:@"MapGridWidth"] intValue]];
		[[GameInfo sharedInstance] setLevelGridHeight: [[mapInfo objectForKey:@"MapGridHeight"] intValue]];
		
		NSArray *mapEntities = [mapInfo objectForKey:@"Entities"];
		if (!mapEntities)
		{
			NSLog(@"map %@ corrupt! no entities found!",filename);
			exit(24);
		}
		
		for (NSDictionary *entDict in mapEntities)
		{
			int _entType = [[entDict objectForKey:@"type"] intValue];
			int _entXPos = [[entDict objectForKey:@"gridPositionX"] intValue];
			int _entYPos = [[entDict objectForKey:@"gridPositionY"] intValue];
			
			id controller = nil;
			id node = nil;
			
			NSDictionary *nodecon = [BlockFactory createBlockControllerPair:_entType positionX:_entXPos positionY:_entYPos];
			[nodecon release];

			controller = [nodecon objectForKey:@"controller"];
			node = [nodecon objectForKey:@"node"];
//			NSLog(@"nodecon retaincount: %i",[nodecon retainCount]);
			
			if (controller)
			{	
				if (_entType == kPlayer)
				{
					playerController = controller;
					//NSLog(@"playerController retaincount: %i",[playerController retainCount]);
				}
				else
				{
					[spriteControllers addObject: controller];
				}
			}
			
			if (node)
			{
				if (_entType == kPlayer)
				{
					[self addChild: node z: 10 tag: kPlayerSprite];
				}
				else
				{
					[self addChild: node z: 0];
				}
				
			//	NSLog(@"adding to sprites: %@ = %x",node,node);
				[sprites addObject: node];
			}
			
			if (_entType == kFinish)
			{
				[[GameInfo sharedInstance] setFinishPosition: cpv(_entXPos,_entYPos)];
			}

			
			node = nil;	
		}
		
		
/*		[node setPosition: cpv(32*4,32*4)];
		[self addChild: node z: 0 tag: kPlayerSprite];

		playerController = [[PlayerController alloc] initWithSprite: node];
		//[spriteControllers addObject: playerController];
		
		
		node = [Sprite spriteWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"block_1.png"]];
		[node setPosition: cpv(32*8,32*8)];
		[self addChild: node z: 0];

		SpriteController *blockController = [[SpriteController alloc] initWithSprite: node];
		[spriteControllers addObject: blockController];
		
		node = [Sprite spriteWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"block_2.png"]];
		[node setPosition: cpv(32*8,32*4)];
		[self addChild: node z: 0];
		
		AngularBlockController *abc = [[AngularBlockController alloc] initWithSprite: node];
		[abc setNormalVector: cpv(-1.0,1.0)];
		[spriteControllers addObject: abc];

		node = [Sprite spriteWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"block_1.png"]];
		[node setPosition: cpv(32*1,32*4)];
		[self addChild: node z: 0];
		
		blockController = [[SpriteController alloc] initWithSprite: node];
		[spriteControllers addObject: blockController];
		

		node = [Sprite spriteWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"block_4.png"]];
		[node setPosition: cpv(32*1,32*7)];
		[self addChild: node z: 0];
		
		abc = [[AngularBlockController alloc] initWithSprite: node];
		[abc setNormalVector: cpv(1.0,-1.0)];
	[spriteControllers addObject: abc];*/

	}
	
	return self;
}

- (void) draw
{
	[super draw];

	memset(fieldcopy,0x00,32*32*sizeof(SpriteController *));
	[playerController update];
	for (id spriteController in spriteControllers)
	{
	//	NSLog(@"updating: %@",spriteController);
		[spriteController update];
	}
}


- (void) dealloc
{
	NSLog(@"Sprite Layer dealloc");
	memset(fieldcopy,0x00,32*32*sizeof(SpriteController *));
	
//	id node = [self getChildByTag: kPlayerSprite];
//	[self removeChild: node cleanup: YES];
//	[node release];

	
	[self removeAllChildrenWithCleanup: YES];
	
	for (id spriteContoller in spriteControllers)
	{
		[spriteContoller release];
	}
	
	
	[spriteControllers removeAllObjects];
	[spriteControllers release];
	spriteControllers = nil;

	for (id sprite in sprites)
	{
		[sprite release];
	}
	[sprites removeAllObjects];
	[sprites release];
	


	
//	NSLog(@"playerController rataincount: %i",[playerController retainCount]);
	[playerController release];
	
	playerController = nil;
	
	[super dealloc];
}

#pragma mark -- pathfinding

//globale fieldcopy - cause passing pointer to multidimensional arrays sucks in C


//casts a ray along (direction) starting at _position
//if it finds a block that adds just a waypoint and not a final point
//it sets bContinue to YES, sets the _position to the found block and the blocks bounce vector as the new direction
//the pathfinding loop will call this method then again with these modified values
//it sucks but hey ...
- (Waypoint *) getWaypointByCastingRayFrom: (cpVect *) _position withDirection: (cpVect *) direction continuePointer: (BOOL *) bContinue
{
	int xAdd = direction->x;
	int yAdd = direction->y;
	
	int startX = _position->x;
	int startY = _position->y;
	
	int xPos = startX;
	int yPos = startY;
	
//	NSLog(@"sx: %i sy: %i xA: %i yA: %i",startX,startY,xAdd,yAdd);
	
	while (1)
	{
		xPos += xAdd;
		yPos += yAdd;
		if (xPos < 0 || xPos >= [[GameInfo sharedInstance] levelGridWidth])
			break;
		if (yPos < 0 || yPos >= [[GameInfo sharedInstance] levelGridHeight])
			break;
		
		if (fieldcopy[xPos][yPos] != nil)
		{
			SpriteController *c = fieldcopy[xPos][yPos];
			cpVect bounce = [c bounceVector: *direction];
			
			//fuehrt uns das ins ziel?
			if (xPos == [[GameInfo sharedInstance] finishPosition].x &&
				yPos == [[GameInfo sharedInstance] finishPosition].y)
			{
				cpVect ret = cpv(xPos*32,yPos*32);
				*bContinue = NO;
				Waypoint *v = [[[Waypoint alloc] init] autorelease];

				[v setLocation: ret];
				[v setAssignedObject: c];
				return v;
			}

			//nullvector - bitte vor diesem feld stehen bleiben
			if (bounce.x == 0.0f && bounce.y == 0.0f)
			{
				//NSLog(@"got no bounce vector back!");
				cpVect ret = cpv((xPos-xAdd)*32,(yPos-yAdd)*32);
				//cpVect ret = cpv(xPos*32,yPos*32);
				//NSLog(@"our final vector is: %i,%i",xPos-xAdd,yPos-yAdd);
				*bContinue = NO;
				//NSValue *v = [NSValue valueWithCGPoint: ret];
				Waypoint *v = [[[Waypoint alloc] init] autorelease];
				[v setLocation: ret];
				[v setAssignedObject: c];
				return v;
			}
			else //ansonsten auf dieses feld bewegen und naechsten wegpunkt holen
			{
				//NSLog(@"got bounce vector back! let's rock!");
				cpVect ret = cpv(xPos*32,yPos*32);
				*bContinue = YES;
				direction->x = bounce.x;
				direction->y = bounce.y;
				_position->x = xPos;
				_position->y = yPos;
//				NSValue *v = [NSValue valueWithCGPoint: ret];
				Waypoint *v = [[[Waypoint alloc] init] autorelease];
				[v setLocation: ret];
				[v setAssignedObject: c];
				
				return v;
			}
		}
		
		
	}
	
	//player will die ... he shot himself to the border lol
	cpVect ret = cpv((xPos)*32,(yPos)*32);
	NSLog(@"die die die: %i,%i",xPos,yPos);
	*bContinue = NO;
//	NSValue *v = [NSValue valueWithCGPoint: ret];
	Waypoint *v = [[[Waypoint alloc] init] autorelease];
	[v setLocation: ret];
	[v setAssignedObject: nil];
	
	return v;
}

//returns a NSArray filled with waypoints for a given spritecontroller to follow
//will only take 1 component vectors ... eg. not 1,1 or something ... just 1,0 ... 0,1 ... -1,0 ... 0,-1
//startPosition is in grid resolution. eg. worldx/32 worldy/32 ... direction vector is a normalized vector.
- (NSArray *) getPathForPosition: (cpVect) startPosition andVector: (cpVect) directionVector
{
	if (abs(directionVector.x) > 0 && abs(directionVector.y) > 0)
	{
		NSLog(@"uh - you may only use 1part vectors lol. like (1|0) ... (1|1) is bad!");
		exit(44);
	}
	
	//empties teh fieldcopy
	memset(fieldcopy,nil,32*32);
	//render our sprite controllers by their gridPositions in this array
	//for fake tilemap access ...
	for (id spriteController in spriteControllers)
	{
	//	NSLog(@"%@: pos: (%f,%f)",spriteController,[spriteController gridPosition].x,[spriteController gridPosition].y);
		int x = [spriteController gridPosition].x;
		int y = [spriteController gridPosition].y;
		
		fieldcopy[x][y] = spriteController;
		
	//	NSLog(@"%i,%i: %@",x,y,fieldcopy[x][y]);
	}
	
	NSMutableArray *path = [NSMutableArray arrayWithCapacity: 12];
	[path retain];
	
	cpVect currentPos = startPosition;
	cpVect dir = directionVector;
	BOOL bContinue = true;

	//this is against infinite looping
	//this can happen when you get some blocks whose bounce vectors build a looping path
	//this should propably never happen ... but who knows
	int loopCount = 0; 

	//run loop as long as bContinue is YES
	//or our loopCount is below 10
	//or we get a nil waypoint back
	do
	{
		id waypoint = [self getWaypointByCastingRayFrom: &currentPos withDirection: &dir continuePointer: &bContinue];

		
		if (waypoint == nil)
			break;
		[waypoint retain];
		
		[path addObject: waypoint];
	//	NSLog(@"waypoint: %@ | continue: %i",waypoint, bContinue);
		if (bContinue == NO)
			break;
		if (loopCount++ > 10)
		{	
			NSLog(@"\n-----\nInfinite Loop in getPathForPosition: ...\n");
			break;
		}
		
	} while (1);
	
	//NSLog(@"%@",fieldcopy[0][0]);
	
	//NSLog(@"our path: %@",path);
	return path;
}

@end
