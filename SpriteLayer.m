//
//  SpriteLayer.m
//  Ginko
//
//  Created by jrk on 26.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "SpriteLayer.h"
#import "GameInfo.h"
#import "SpriteController.h"
#import "AngularBlockController.h"

@implementation SpriteLayer
@synthesize playerController;

enum spriteTags 
{
	kPlayerSprite = 200
};

#pragma mark -- init / dealloc
- (id) initWithLevelFile: (NSString *) filename
{
	self = [super init];
	if (self)
	{
		spriteControllers = [[NSMutableArray alloc] init];
		
		id node = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"player.png"]];
		[node setPosition: cpv(32*4,32*4)];
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
	[spriteControllers addObject: abc];

	}
	
	return self;
}

- (void) draw
{
	[super draw];
	
	[playerController update];
	for (id spriteController in spriteControllers)
	{
		[spriteController update];
	}
}


- (void) dealloc
{
	NSLog(@"Sprite Layer dealloc");

	id node = [self getChildByTag: kPlayerSprite];
	[self removeChild: node cleanup: YES];
	[node release];

	[self removeAllChildrenWithCleanup: YES];
	
	for (id spriteContoller in spriteControllers)
	{
		[spriteContoller release];
	}
	
	[spriteControllers removeAllObjects];
	[spriteControllers release];
	
	[playerController release];
	
	[super dealloc];
}

#pragma mark -- pathfinding

//globale fieldcopy - cause passing pointer to multidimensional arrays sucks in C
SpriteController *fieldcopy[16][11];

//casts a ray along (direction) starting at _position
//if it finds a block that adds just a waypoint and not a final point
//it sets bContinue to YES, sets the _position to the found block and the blocks bounce vector as the new direction
//the pathfinding loop will call this method then again with these modified values
//it sucks but hey ...
- (NSValue *) getWaypointByCastingRayFrom: (cpVect *) _position withDirection: (cpVect *) direction continuePointer: (BOOL *) bContinue
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
		if (xPos < 0 || xPos >= 15)
			break;
		if (yPos < 0 || yPos >= 10)
			break;
		
		if (fieldcopy[xPos][yPos] != nil)
		{
			SpriteController *c = fieldcopy[xPos][yPos];
	//		NSLog(@"%i,%i, hit object: %@",xPos,yPos,c);
			cpVect bounce = [c bounceVector: *direction];
			if (bounce.x == 0.0f && bounce.y == 0.0f)
			{
				//NSLog(@"got no bounce vector back!");
				cpVect ret = cpv((xPos-xAdd)*32,(yPos-yAdd)*32);
				//NSLog(@"our final vector is: %i,%i",xPos-xAdd,yPos-yAdd);
				*bContinue = NO;
				NSValue *v = [NSValue valueWithCGPoint: ret];
				return v;
			}
			else
			{
				//NSLog(@"got bounce vector back! let's rock!");
				cpVect ret = cpv(xPos*32,yPos*32);
				*bContinue = YES;
				direction->x = bounce.x;
				direction->y = bounce.y;
				_position->x = xPos;
				_position->y = yPos;
				NSValue *v = [NSValue valueWithCGPoint: ret];
				return v;
			}
		}
		
		
	}
	
	//player will die ... he shot himself to the border lol
	cpVect ret = cpv((xPos)*32,(yPos)*32);
	//NSLog(@"die die die: %i,%i",xPos,yPos);
	*bContinue = NO;
	NSValue *v = [NSValue valueWithCGPoint: ret];
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
