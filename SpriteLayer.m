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
#import "BirdController.h"
#import "FinishController.h"
#import "TeleporterController.h"

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
	srand(time(0));
	self = [super init];
	if (self)
	{
		memset(fieldcopy,0x00,32*32*sizeof(SpriteController *));

		/* CREATE EMPTY MAP + LOAD MAP FILE */
		spriteControllers = [[NSMutableArray alloc] init];
		sprites = [[NSMutableArray alloc] init];
		NSDictionary *mapInfo = [NSDictionary dictionaryWithContentsOfFile: filename];
		NSAssert1(mapInfo,@"Error! Map File %@ not found!",filename);
		
		[[GameInfo sharedInstance] setLevelGridWidth: [[mapInfo objectForKey:@"MapGridWidth"] intValue]];
		[[GameInfo sharedInstance] setLevelGridHeight: [[mapInfo objectForKey:@"MapGridHeight"] intValue]];
		
		int mapw = [[GameInfo sharedInstance] worldWidth];
		int maph = [[GameInfo sharedInstance] worldHeight];
		
		BOOL isSmallLevel = YES;
		
		if (mapw == 720 && maph == 480)
			isSmallLevel = NO;
		
		/* END LOAD MAP FILE */
		
		TeleporterController *teleportOne = nil;
		TeleporterController *teleportTwo = nil;
		
		/* CREATE SPRITES AND THEIR CONTROLLERS */
		NSArray *mapEntities = [mapInfo objectForKey:@"Entities"];
		if (!mapEntities)
		{
			NSLog(@"map %@ corrupt! no entities found!",filename);
			exit(24);
		}
		int birdSet = 0;
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
			
			if (controller)
			{	
				if (_entType == kPlayer)
				{
					playerController = controller;
					
					/*Sprite *playerShadow = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"player_shadow.png"]];
					PlayerShadowController *psc = [[PlayerShadowController alloc] initWithSprite: playerShadow];
					[psc setPlayerSprite: node];
					
					[spriteControllers addObject: psc];
					
					
					[self addChild: playerShadow z:-1];
					[sprites addObject: playerShadow];
					*/
					//NSLog(@"playerController retaincount: %i",[playerController retainCount]);
				}
				else if (_entType == kTeleporter)
				{
				//	NSLog(@"TELEPORTER! %@",controller);
					if (teleportOne && teleportTwo)
					{
						NSLog(@"ERROR! MORE THAN TWO TELEPORTERS IN LEVEL!!");
						exit (98);
					}
						
					if (teleportOne == nil)
					{
						teleportOne = controller;
					}
					else if (teleportTwo == nil)
					{
						teleportTwo = controller;
					}
					
					[spriteControllers addObject: controller];
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
					[self addChild: node z: 5 tag: kPlayerSprite];
					
					//Sprite *playerShadow = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"player_shadow.png"]];
					
					//[playerShadow setPosition: cpv(24,4)];
					//[node addChild: playerShadow z:-10];
					
					//[sprites addObject: playerShadow];
				}
				else
				{
					[self addChild: node z: 0];
					BOOL createBird = NO;

					if (rand()%100 <= 20)
						createBird = YES;
						
					if (_entType == kSimpleBlock && birdSet < 5 && createBird)
					{
						Sprite *bird = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"bird0.png"]];
						[self addChild: bird z: 9];
						cpVect p = [(Sprite*)node position];
						p.x -= 16;
						
						p.x += rand()%32;
						p.y += 12;
						
						[sprites addObject: bird];
					
						[bird setPosition: p];
						
						NSString *pref = nil;
						
						BirdController *bc = [[BirdController alloc] initWithSprite: bird colorPrefix: pref];
						[spriteControllers addObject: bc];

						[bc setDestPoint: cpv(p.x, 700)];
						
						birdSet++;
					}
					
				}
				
			//	NSLog(@"adding to sprites: %@ = %x",node,node);
				[sprites addObject: node];
			}
			
			if (_entType == kFinish)
			{
				[[GameInfo sharedInstance] setFinishPosition: cpv(_entXPos,_entYPos)];
				
				
				Sprite *finish_anim = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"finish_anim0.png"]];
				[finish_anim setPosition: [(Sprite*)node position]];
				[self addChild: finish_anim z: -6];
				[sprites addObject: finish_anim];

				FinishController *fc = (FinishController *)controller;
				[fc setAnimationSprite: finish_anim];

			}

			if (_entType == kSimpleBlock)
			{
	//			shadow_block_1_1.png
				
				Sprite *_shadow = nil;
				if ([[node lolFilename] isEqualToString: [[GameInfo sharedInstance] pathForGraphicsFile:@"block_1_1.png"]])
					_shadow = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"shadow_block_1_1.png"]];
				else
					_shadow = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"shadow_block_1_2.png"]];
				
		//		NSLog(@"lolfilename: %@",[node lolFilename]);
				
				//[flower setPosition: cpv((rand()%13)*32+32,(rand()%8)*32+32)];
				cpVect po = [((Sprite *)node) position];
				po.x += 8;
				po.y -= 8;
				
				[_shadow setPosition: po];
				
				[self addChild: _shadow z:-4];
				[sprites addObject: _shadow];
				
			}
			
			
			node = nil;	
		}
		/* END CREATING SPRITES AND CONTROLLERS*/

		
		/* CONNECT TELEPORTERS */
		if ((teleportOne != nil && teleportTwo == nil) ||
			(teleportOne == nil && teleportTwo != nil))
		{
			NSLog(@"Error! Only one teleporter was found!");
			exit(97);
		}
		
			
		if (teleportOne && teleportTwo)
		{
		//	NSLog(@"Linking %@ and %@",teleportOne, teleportTwo);
			[teleportOne setLinkedTeleport: teleportTwo];
			[teleportTwo setLinkedTeleport: teleportOne];
		}
			
		/* END CONNECTING TELEPORTERS */
		
		

		/* CREATE GROUND CLUTTER AND DECO */
		if (isSmallLevel)
		{
			for (int i = 0; i < 1; i++)
			{
				Sprite *ground = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"ground.png"]];
				
				[ground setPosition: cpv((rand()%12)*32+48,(rand()%7)*32+48)];
				[self addChild: ground z:-7];
				[sprites addObject: ground];
			}
			
			for (int i = 0; i < 1; i++)
			{
				Sprite *ground = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"ground2.png"]];
				
				[ground setPosition: cpv((rand()%12)*32+48,(rand()%7)*32+48)];
				[self addChild: ground z:-7];
				[sprites addObject: ground];
			}
			
			for (int i = 0; i < 1; i++)
			{
				Sprite *ground = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"ground3.png"]];
				
				[ground setPosition: cpv((rand()%12)*32+48,(rand()%7)*32+48)];
				[self addChild: ground z:-7];
				[sprites addObject: ground];
			}
			
			for (int i = 0; i < 3; i++)
			{
				Sprite *flower = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"flower.png"]];
				
				[flower setPosition: cpv((rand()%13)*32+32,(rand()%8)*32+32)];
				[self addChild: flower z:-5];
				[sprites addObject: flower];
				
				
			}
			
			for (int i = 0; i < 3; i++)
			{
				Sprite *flower = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"flower2.png"]];
				
				[flower setPosition: cpv((rand()%13)*32+32,(rand()%8)*32+32)];
				[self addChild: flower z:-5];
				[sprites addObject: flower];
			}
			
			for (int i = 0; i < 5; i++)
			{
				Sprite *gravel = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"gravel.png"]];
				
				[gravel setPosition: cpv((rand()%13)*32+32,(rand()%8)*32+32)];
				[self addChild: gravel z:-6];
				[sprites addObject: gravel];
			}
			
			Sprite *border = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"small_border.png"]];
			[border setPosition: cpv(240-16,160-16)];
			[self addChild: border z:8];
			[sprites addObject: border];
		
			Sprite *sunshine = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"rays_small.png"]];
			[sunshine setPosition: cpv(240-32,160+19)];
			[self addChild: sunshine z:10];
			[sprites addObject: sunshine];
		}
		else
		{
			for (int i = 0; i < 2; i++)
			{
				Sprite *ground = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"ground.png"]];
				
				[ground setPosition: cpv((rand()%19)*32+48,(rand()%12)*32+48)];
				[self addChild: ground z:-7];
				[sprites addObject: ground];
			}
			
			for (int i = 0; i < 2; i++)
			{
				Sprite *ground = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"ground2.png"]];
				
				[ground setPosition: cpv((rand()%19)*32+48,(rand()%12)*32+48)];
				[self addChild: ground z:-7];
				[sprites addObject: ground];
			}
			
			for (int i = 0; i < 2; i++)
			{
				Sprite *ground = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"ground3.png"]];
				
				[ground setPosition: cpv((rand()%19)*32+48,(rand()%12)*32+48)];
				[self addChild: ground z:-7];
				[sprites addObject: ground];
			}
			
			for (int i = 0; i < 6; i++)
			{
				Sprite *flower = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"flower.png"]];
				
				[flower setPosition: cpv((rand()%20)*32+32,(rand()%13)*32+32)];
				[self addChild: flower z:-5];
				[sprites addObject: flower];
				
				
			}
			
			for (int i = 0; i < 6; i++)
			{
				Sprite *flower = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"flower2.png"]];
				
				[flower setPosition: cpv((rand()%20)*32+32,(rand()%13)*32+32)];
				[self addChild: flower z:-5];
				[sprites addObject: flower];
			}
			
			for (int i = 0; i < 10; i++)
			{
				Sprite *gravel = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"gravel.png"]];
				
				[gravel setPosition: cpv((rand()%20)*32+32,(rand()%13)*32+32)];
				[self addChild: gravel z:-6];
				[sprites addObject: gravel];
			}
			
			Sprite *border = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"medium_border.png"]];
			[border setPosition: cpv(360-16,240-16)];
			[self addChild: border z:8];
			[sprites addObject: border];
			
			Sprite *sunshine = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"rays_medium.png"]];
			[sunshine setPosition: cpv(360-32,240+19)];
			[self addChild: sunshine z:10];
			[sprites addObject: sunshine];
			
		}
		/* END CREATE GROUND CLUTTER AND DECO */
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
//	NSLog(@"Sprite Layer dealloc");
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
		[sprite stopAllActions];
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
- (NSArray *) getWaypointByCastingRayFrom: (cpVect *) _position withDirection: (cpVect *) direction continuePointer: (BOOL *) bContinue
{
	int xAdd = direction->x;
	int yAdd = direction->y;
	
	int startX = _position->x;
	int startY = _position->y;
	
	int xPos = startX;
	int yPos = startY;
	
//	NSLog(@"sx: %i sy: %i xA: %i yA: %i",startX,startY,xAdd,yAdd);
	NSMutableArray *retPoints = [NSMutableArray array];
	[retPoints retain];
	
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
				[v setIsTeleport: NO];

				[v setLocation: ret];
				[v setAssignedObject: c];
				[retPoints addObject: v];
				
				return retPoints;
		//		return v;
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
				[v setIsTeleport: NO];
				[v setLocation: ret];
				[v setAssignedObject: c];
				[retPoints addObject: v];
				
								return retPoints;
				//return v;
			}
			//teleporter
			else if (bounce.x == -1.0f && bounce.y == -1.0f)
			{
				TeleporterController *tc = (TeleporterController *)c;
				TeleporterController *linkedTeleport = [tc linkedTeleport];
				
				if (linkedTeleport == nil)
				{
					NSLog(@"OMG TELEPORT WAS NOT LINKED! ERROR!");
					exit(99);
				}
				
				//cpVect ret = cpv ([linkedTeleport gridPosition].x * 32, [linkedTeleport gridPosition].y * 32);
				
				cpVect ret = cpv((xPos)*32,(yPos)*32);
				
				Waypoint *v = [[[Waypoint alloc] init] autorelease];
				[v setIsTeleport: NO];
				[v setLocation: ret];
				[v setAssignedObject: c];
				[retPoints addObject: v];
			
				v = [[[Waypoint alloc] init] autorelease];
				[v setIsTeleport: YES];
				[v setLocation: cpv ([linkedTeleport gridPosition].x * 32, [linkedTeleport gridPosition].y * 32)];
				[v setAssignedObject: c];
				[retPoints addObject: v];
				
				_position->x = [linkedTeleport gridPosition].x;
				_position->y = [linkedTeleport gridPosition].y;
				bContinue = YES;
				
				return retPoints;
				
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
				[v setIsTeleport: NO];
				[v setLocation: ret];
				[v setAssignedObject: c];
				[retPoints addObject: v];
				
				return retPoints;
				//return v;
			}
		}
		
		
	}
	
	//player will die ... he shot himself to the border lol
	cpVect ret = cpv((xPos)*32,(yPos)*32);
	//NSLog(@"die die die: %i,%i",xPos,yPos);
	*bContinue = NO;
//	NSValue *v = [NSValue valueWithCGPoint: ret];
	Waypoint *v = [[[Waypoint alloc] init] autorelease];
	[v setLocation: ret];
	[v setAssignedObject: nil];
	[retPoints addObject: v];
	
	return retPoints;
	//return v;
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
		
		if (x != -1 && y != -1)
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
		id waypoints = [self getWaypointByCastingRayFrom: &currentPos withDirection: &dir continuePointer: &bContinue];
		for (id waypoint in waypoints)
		{
			[waypoint retain];
			
			[path addObject: waypoint];
			
		}
		[waypoints release];
		
		//		if (waypoints == nil)
//			break;
		if (bContinue == NO)
			break;
		if (loopCount++ > 10)
		{	
			NSLog(@"\n-----\nInfinite Loop in getPathForPosition: ...\n");
			break;
		}
		
		
	} while (1);
	
	//NSLog(@"%@",fieldcopy[0][0]);
/*	NSLog(@"our path: ");
	for (id waypoint in path)
	{
		NSLog(@"%f,%f",[waypoint location].x,[waypoint location].y);
	}*/
	return path;
}

@end
