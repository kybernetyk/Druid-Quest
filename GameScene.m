//
//  GameScene.m
//  Ginko
//
//  Created by jrk on 24.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "cocos2d.h"
#import "GameScene.h"
#import "GameBackgroundLayer.h"
#import "ControllerCrossLayer.h"
#import "GameInfo.h"
#import "SpriteLayer.h"
#import "PlayerController.h"
#import "MenuScene.h"

@implementation GameScene

//#define LEVEL_WIDTH 720
//#define LEVEL_HEIGHT 480

enum GameSceneLayerTags 
{
	kBackgroundLayer = 20,
	kControllerCrossLayer,
	kSpriteLayer,
	kCameraLayer
};



- (id) init
{
	self = [super init];
	if (self)
	{
//		NSLog(@"self retaincount: %i",[self retainCount]);
		NSLog(@"gameScene init");
		[self loadScene];

//		NSLog(@"self retaincount: %i",[self retainCount]);		
	}
	
	return self;
}

- (void) dealloc
{

	[self unloadScene];

	NSLog(@"game scene dealloc");
	[super dealloc];
}

- (void) onEnter
{
	[super onEnter];
 	[[Director sharedDirector] addEventHandler: self];
}

- (void) onExit
{
	[super onExit];
	
//	[self unloadScene];
	[[Director sharedDirector] removeEventHandler: self];
}

#pragma mark -- main loop
-(void) draw
{
//	Layer *cameraLayer = [self getChildByTag: kCameraLayer];
	//[cameraLayer setRotation: [cameraLayer rotation]+1.0f];

	//NSLog(@"%i",[self retainCount]);
	
	
//	NSLog(@"playerController retaincount: %i",[playerController retainCount]);
}

#pragma mark -- loading / unloading / reseting
- (void) resetScene
{
	[self unloadScene];
	[self loadScene];
}

- (void) loadNextLevel
{
	id _nextScene = nil;
	[[GameInfo sharedInstance] setCurrentLevel: [[GameInfo sharedInstance] currentLevel] + 1];

	if ([[GameInfo sharedInstance] currentLevel] > [[GameInfo sharedInstance] lastLevel])
	{
		_nextScene = [MenuScene node];
	}
	else
	{
		_nextScene = [GameScene node];
	}


	
//	[[Director sharedDirector] replaceScene: gs];
	
	//NSLog(@"gameScene retaincount: %i",[self retainCount]);
	
	
//	[[Director sharedDirector] replaceScene: [FadeBLTransition transitionWithDuration:5.0 scene: gs]];
	[[Director sharedDirector] replaceScene: 	[FadeTransition transitionWithDuration:0.6 scene:_nextScene withColorRGB:0x000000]];

	//[[Director sharedDirector] replaceScene: [SlideInLTransition transitionWithDuration:2.0 scene: gs]];
}

- (void) loadScene
{
	NSLog(@"gameScene loadScene");
	id cameraLayer = [[Layer alloc] init];
	[self addChild: cameraLayer z: 0 tag: kCameraLayer];
	[cameraLayer setPosition: cpv(0,0)];
	//[cameraLayer setPosition: cpv (480/2,320/2)];

	id node = [[GameBackgroundLayer alloc] init];
	[cameraLayer addChild: node z: -1 tag: kBackgroundLayer];
	//[node setPosition:cpv (960/2,640/2)];
	//[node setPosition:cpv(720/2,480/2)];
	[node setPosition:cpv([[GameInfo sharedInstance] worldWidth]/2,[[GameInfo sharedInstance] worldHeight]/2)];

//	float world_w = 960.0f;
	//float world_w = 720.0f;
	float world_w = [[GameInfo sharedInstance] worldWidth];
	
	float screen_w = 480.0f;

	
	node = [[ControllerCrossLayer alloc] init];
	[node setPosition:cpv(480/2,320/2)];
	[self addChild: node z: 5 tag: kControllerCrossLayer];
	
	node = [[SpriteLayer alloc] initWithLevelFile: [[GameInfo sharedInstance] currentMapFilename]];
	[node setPosition: cpv(+16,+16)];
	[cameraLayer addChild: node z: 1 tag: kSpriteLayer];
	
	//get the player node from spritelayer
	playerController = [node playerController];




	Camera *c = [cameraLayer camera];
	[c restore];
	
	float x,y,z;
	[c eyeX:&x eyeY:&y eyeZ:&z];
//	NSLog(@"init cam: %f,%f,%f",x,y,z);
	
	[[GameInfo sharedInstance] setMinZoom: z];
	[[GameInfo sharedInstance] setMaxZoom: z*(world_w/screen_w)];//(3.0/2.0)];
	[[GameInfo sharedInstance] setZoom: z];
	//[[GameInfo sharedInstance] setZoom: z*1.50];
	[self checkCameraBounds];
}

// o m f g - es klappt. aber warum?
- (void) checkCameraBounds
{
	float zoomratio = [[GameInfo sharedInstance] minZoom] / [[GameInfo sharedInstance] zoom];
	id cameraLayer = [self getChildByTag: kCameraLayer];
	Camera *c = [cameraLayer camera];
	float x,y,z;
	[c eyeX:&x eyeY:&y eyeZ:&z];
	z = [[GameInfo sharedInstance] zoom];
	[c setEyeX: x eyeY:y eyeZ: z];
	
	[c eyeX:&x eyeY:&y eyeZ:&z];
	z = [[GameInfo sharedInstance] minZoom];

	[c setEyeX: x eyeY:y eyeZ: z];
	z = [[GameInfo sharedInstance] zoom];
	[c setEyeX: x eyeY:y eyeZ: z];
	
	//NSLog(@"cam: %f,%f,%f",x,y,z);
	float min_y = (z*1.1566f)/2.0;
	float min_x = min_y/1.5;

	
	//WHAT THE FUCK?!
	//WHAT IS THIS SHIT
	//warum klappt das? >.<
	//vermutung: es hat irgendwas mit der verschissenen umrechnung der kamera
	//in die koordinaten zu tun. x/y ist bei der kamera vertauscht >.<
	//also nehmen wir von y ein stueck weg und packen es nach x
	//wobei das stueck je nach zoom variiert
	//THAT'S JUST WRONG :(
//	NSLog(@"diff: %f",(min_y - min_x));
	float diff = (min_y - min_x)*(1.0-zoomratio);
 	min_x += diff;
	min_y -= diff;

	float img_width = [[GameInfo sharedInstance] worldWidth];
	float img_height = [[GameInfo sharedInstance] worldHeight];

	//fuer 960x640 |optimal zoom 0.5 
	float y_mirror = img_height / 2 + 80; // = 400
	float x_mirror = img_width / 2 - 80; // = 400
	
	float max_x = (x_mirror - min_x) + x_mirror;
	float max_y = (y_mirror - min_y) + y_mirror;
	
	[c eyeX:&x eyeY:&y eyeZ:&z];
	if (x < min_x)
		x = min_x;
	if (y < min_y)
		y = min_y;
	if (x > max_x)
		x = max_x;
	if (y > max_y)
		y = max_y;
	[c setEyeX: x eyeY:y eyeZ: z];

	
	[c centerX:&x centerY:&y centerZ:&z];
	if (x < min_x)
		x = min_x;
	if (y < min_y)
		y = min_y;
	if (x > max_x)
		x = max_x;
	if (y > max_y)
		y = max_y;
	[c setCenterX:x centerY:y centerZ: z];

}

- (void) unloadScene
{
	NSLog(@"gameScene unload");
	id cameraLayer = [self getChildByTag: kCameraLayer];
	//NSLog(@"kCameraLayer %@ refcount: %i",cameraLayer,[cameraLayer retainCount]);
	
	id node = [cameraLayer getChildByTag: kBackgroundLayer];
//	NSLog(@"kBackgroundLayer %@ refcount: %i",node,[node retainCount]);
	[cameraLayer removeChild: node cleanup: YES];

	[node release];

	node = [cameraLayer getChildByTag: kSpriteLayer];
//	NSLog(@"kSpriteLayer %@ refcount: %i",node,[node retainCount]);
	[cameraLayer removeChild: node cleanup: YES];
	[node release];

	[self removeChild: cameraLayer cleanup: YES];
	[cameraLayer release];

	node = [self getChildByTag: kControllerCrossLayer];
//	NSLog(@"kControllerCrossLayer %@ refcount: %i",node,[node retainCount]);
	[self removeChild: node cleanup: YES];
	[node release];

	[self removeAllChildrenWithCleanup: YES];
	
	playerController = nil;
}

//unloads and releases scene - before switching to new scene plox
- (void) destroyScene
{
	[self unloadScene];
	[self release];
}

#define DICKE_FINGER_TAP_TOLLERANZ 16

#pragma mark -- zooming and bounds checking
- (void) moveCameraBy: (float) x y: (float) y
{
	float addX = x;
	float addY = y;
	
	Layer *cameraLayer = (Layer*)[self getChildByTag: kCameraLayer];
	float z;
	Camera *c = [cameraLayer camera];

	[c eyeX:&x eyeY:&y eyeZ:&z];
	x += addX;
	y += addY;
	[c setEyeX:x eyeY:y eyeZ:z];
	
	[c centerX:&x centerY:&y centerZ:&z];
	x += addX;
	y += addY;
	[c setCenterX: x centerY:y centerZ:z];
	
	//bounds check
	[self checkCameraBounds];
	
}

- (void) zoomCameraBy: (float)zoomAmmount zoomCenter: (cpVect)center
{
//	NSLog(@"zoom amm: %f",zoomAmmount);
	float movedZ = zoomAmmount;
	float zoom = [[GameInfo sharedInstance] zoom];
	zoom += movedZ;
	if (zoom <= [[GameInfo sharedInstance] minZoom])
		zoom = [[GameInfo sharedInstance] minZoom];
	if (zoom >= [[GameInfo sharedInstance] maxZoom])
		zoom = [[GameInfo sharedInstance] maxZoom];
	
	//zoom anpassen, wenn in zoom bounds
	[[GameInfo sharedInstance] setZoom: zoom ];

	//offset wo der mittelpunkt des zooms sein soll
	//standard oben rechts
	float addX = -movedZ;
	float addY = -movedZ;
	
	//je nach in welchem quadrant der zoom geschieht,
	//wird ein anderer quadrant gezoomt
	if (center.x < 480.0/2.0)
		addX = movedZ;
	if (center.y < 320.0/2.0)
		addY = movedZ;
	
	//ausser der spieler will die mitte
	//ausser der spieler will die mitte
	//dann wird kein zoom offset gesetzt >.<
	if (center.x > ((480.0/2.0)-40) && center.x < ((480.0/2.0)+40))
		addX = 0.0f;
	if (center.y > ((320.0/2.0)-40) && center.y < ((320.0/2.0)+40))
		addY = 0.0f;
	
	//kamera auf den zoom mittelpunkt bewegen
	
	[self moveCameraBy: addX y: addY];
	

	
	
}



#pragma mark -- TouchEventsDelegate implementation
- (CGFloat)distanceBetweenTwoPoints:(CGPoint)fromPoint toPoint:(CGPoint)toPoint 
{
    float x = toPoint.x - fromPoint.x;
    float y = toPoint.y - fromPoint.y;
    
    return sqrt(x * x + y * y);
}

//achtung: redundanz zwischen mayActivateCross und mayMovePlayer ???
BOOL mayMovePlayer = YES;
BOOL mayMoveCamera = YES;
BOOL mayActivateCross = YES;

- (BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *myTouch =  [touches anyObject];
	CGPoint location = [myTouch locationInView: [myTouch view]];
	location = [[Director sharedDirector] convertCoordinate: location];

	mayActivateCross = NO;

	NSSet *allTouches = [event allTouches];
	id crosslayer = [self getChildByTag: kControllerCrossLayer];
	mayMoveCamera = YES;
	

	//checken ob der user den spieler bewegen will (abfrage == true)
	//oder ob er aufs spielfeld getappt hat, um das feld zu bewegen (abfrage == false)
	if (CGRectContainsPoint (CGRectMake(32.0f, 288.0f-DICKE_FINGER_TAP_TOLLERANZ, 416.0f, 32.0f+DICKE_FINGER_TAP_TOLLERANZ),location))
	{
		[crosslayer highlightUpperCross: YES];
		mayMoveCamera = NO;
		mayActivateCross = YES;
	}
	if (CGRectContainsPoint (CGRectMake(0.0f, 0.0f, 416.0f, 32.0f+DICKE_FINGER_TAP_TOLLERANZ),location))
	{
		[crosslayer highlightLowerCross: YES];
		mayMoveCamera = NO;
		mayActivateCross = YES;
	}
	if (CGRectContainsPoint (CGRectMake(0.0f, 32.0f, 32.0f+DICKE_FINGER_TAP_TOLLERANZ, 256.0f),location))
	{
		[crosslayer highlightLeftCross: YES];
		mayMoveCamera = NO;
		mayActivateCross = YES;
	}
	if (CGRectContainsPoint (CGRectMake(448.0f-DICKE_FINGER_TAP_TOLLERANZ, 32.0f, 32.0f+DICKE_FINGER_TAP_TOLLERANZ, 256.0f),location))
	{
		[crosslayer highlightRightCross: YES];
		mayMoveCamera = NO;
		mayActivateCross = YES;
	}

	//zwei mal auf die gleiche stelle getappt?
	//dann camerazoom + move zuruecksetzen
	if ([myTouch tapCount] >= 2 && mayActivateCross == NO)
	{
		//id cameraLayer = [self getChildByTag: kCameraLayer];
		//Camera *c = [cameraLayer camera];
		//[c restore];
		int zoom = [[GameInfo sharedInstance] zoom];
		int maxz = [[GameInfo sharedInstance] maxZoom];
//		int minz = [[GameInfo sharedInstance] minZoom];
		
		//maximal reingezoomt und tapp?
		//dann auf volle sicht rauszoomen
		//if (zoom == minz)
		
		//alternative
		//wenn ich reingezoomt bin, egal wie viel, dann rauszoomen
		
		if (zoom != maxz)
		{
			NSLog(@"zooming out: %f,%f",location.x,location.y);
			[self zoomCameraBy: +2500.0f zoomCenter: location]; //zoom in maximal
		}
		else //sonst auf maximale vergroesserung reinzoomen
		{
			NSLog(@"zooming in: %f,%f",location.x,location.y);
			[self zoomCameraBy: -2500.0f zoomCenter: location]; //zoom in maximal
		}
	}
	
	//mehr als ein finger aufm feld?
	//dann kreuz ausmachen und die aktivierung verbieten
	//und der spieler darf auch nicht bewegt werden
	//der user will offensichtlich multitouchen (zoomen)
	if ([allTouches count] != 1)
	{	
		mayMovePlayer = NO;
		mayActivateCross = NO;
		[crosslayer highlightUpperCross: NO];
		[crosslayer highlightRightCross: NO];
		[crosslayer highlightLowerCross: NO];
		[crosslayer highlightLeftCross: NO];
		
	}
	else
	{	
		mayMovePlayer = YES;
		//der spieler darf bewegt werden
		//ob er dann aber endgueltig bewegt wird, haengt noch von mayActivateCross ab
	}
	
	
	return kEventHandled;
}


- (BOOL)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{  
	UITouch *myTouch =  [touches anyObject];
	CGPoint location = [myTouch locationInView: [myTouch view]];
	location = [[Director sharedDirector] convertCoordinate: location];
	


	NSSet *allTouches = [event allTouches];
	id crosslayer = [self getChildByTag: kControllerCrossLayer];
	
	//mehr als ein finger auf dem feld? steuerkreuz deaktivieren
	if ([allTouches count] != 1)
	{

		[crosslayer highlightUpperCross: NO];
		[crosslayer highlightRightCross: NO];
		[crosslayer highlightLowerCross: NO];
		[crosslayer highlightLeftCross: NO];
	}
	
	//nur ein finger aufm feld und das kreuz darf aktiviert werden?
	//dann lassen wirs leuchten
	if ([allTouches count] == 1 && mayActivateCross)
	{
		
		if (CGRectContainsPoint (CGRectMake(32.0f, 288.0f-DICKE_FINGER_TAP_TOLLERANZ, 416.0f, 32.0f+DICKE_FINGER_TAP_TOLLERANZ),location))
		{
			[crosslayer highlightUpperCross: YES];
			return kEventHandled;
		}
		else
			[crosslayer highlightUpperCross: NO];

		if (CGRectContainsPoint (CGRectMake(0.0f, 0.0f, 416.0f, 32.0f+DICKE_FINGER_TAP_TOLLERANZ),location))
		{	
			[crosslayer highlightLowerCross: YES];
			return kEventHandled;
		}
		else
			[crosslayer highlightLowerCross: NO];

		if (CGRectContainsPoint (CGRectMake(0.0f, 32.0f, 32.0f+DICKE_FINGER_TAP_TOLLERANZ, 256.0f),location))
		{
			[crosslayer highlightLeftCross: YES];
			return kEventHandled;
		}
		else
			[crosslayer highlightLeftCross: NO];
		if (CGRectContainsPoint (CGRectMake(448.0f-DICKE_FINGER_TAP_TOLLERANZ, 32.0f, 32.0f+DICKE_FINGER_TAP_TOLLERANZ, 256.0f),location))
		{
			[crosslayer highlightRightCross: YES];
			return kEventHandled;
		}
		else
			[crosslayer highlightRightCross: NO];
	}

    
	UIView *v = [[[allTouches allObjects] objectAtIndex:0] view];
	
	//swipe & zoom
    switch ([allTouches count])
    {
        case 1: 
		{ //Move
			if (!mayMoveCamera)
				return kEventHandled;
			
			UITouch *myTouch = [[allTouches allObjects] objectAtIndex:0];
            CGPoint actualPosition = [myTouch locationInView:v];
			CGPoint prevPosition = [myTouch previousLocationInView: v];
			
			actualPosition = [[Director sharedDirector] convertCoordinate: actualPosition];
			prevPosition = [[Director sharedDirector] convertCoordinate: prevPosition];
			
			float movedX = actualPosition.x - prevPosition.x;
			float movedY = prevPosition.y - actualPosition.y;
			[self moveCameraBy: -movedX y: movedY];

			
			return kEventHandled;
        } break;
        case 2: 
		{ //Zoom

            UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
            UITouch *touch2 = [[allTouches allObjects] objectAtIndex:1];
            
            //Calculate the distance between the two fingers.
            CGFloat finalDistance = [self distanceBetweenTwoPoints:[[Director sharedDirector] convertCoordinate:[touch1 locationInView:v]]
                                                           toPoint:[[Director sharedDirector] convertCoordinate:[touch2 locationInView:v]]];

            
			CGFloat initialDistance =  [self distanceBetweenTwoPoints:[[Director sharedDirector] convertCoordinate:[touch1 previousLocationInView:v]]
										toPoint:[[Director sharedDirector] convertCoordinate:[touch2 previousLocationInView:v]]];

			
            float movedZ = initialDistance - finalDistance;
            

			//wo ist der mittelpunkt zwischen unseren fingern?
			cpVect p1 = [[Director sharedDirector] convertCoordinate:[touch1 locationInView:v]];
			cpVect p2 = [[Director sharedDirector] convertCoordinate:[touch2 locationInView:v]];
			cpVect diffv = cpvsub(p2, p1);
			cpVect center = cpv(p1.x+diffv.x/2.0f,p1.y+diffv.y/2.0f);
			
			
			int zoom = [[GameInfo sharedInstance] zoom];
			//int maxz = [[GameInfo sharedInstance] maxZoom];
			int minz = [[GameInfo sharedInstance] minZoom];

			
			//wir zoomen rein
			//ausser wir sind schon maximal reingezoomt
			if (movedZ < 0)
			{
				if (minz != zoom)
					[self zoomCameraBy: movedZ zoomCenter: center];
			}
			else
			{	
				[self zoomCameraBy: movedZ zoomCenter: center];
			}
			
			return kEventHandled;
        } break;
    }
	
	
	
	return kEventHandled;
}



- (BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//	NSLog(@"touches ended");
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView: [touch view]];
	NSSet *allTouches = [event allTouches];
	//NSLog(@"touches ended fingers: %i",[allTouches count]);
	
	//NSLog(@"touchup: %@",touch);
	location = [[Director sharedDirector] convertCoordinate: location];

	id crosslayer = [self getChildByTag: kControllerCrossLayer];

	//waren 2 finger aktiv? dann das kreuz deaktiviern
	if ([allTouches count] != 1)
	{
		[crosslayer highlightUpperCross: NO];
		[crosslayer highlightLowerCross: NO];
		[crosslayer highlightLeftCross: NO];
		[crosslayer highlightRightCross: NO];
		mayMovePlayer = NO;
		return kEventHandled;
	}
	
	if (mayMovePlayer == NO)
		return kEventHandled;
	if (mayActivateCross == NO)
		return kEventHandled;

	
	//player movement
	if (CGRectContainsPoint (CGRectMake(32.0f, 288.0f-DICKE_FINGER_TAP_TOLLERANZ, 416.0f, 32.0f+DICKE_FINGER_TAP_TOLLERANZ),location))
	{
		[crosslayer highlightUpperCross: NO];
		if ([playerController isMoving])
			return kEventHandled;

		id cameraLayer = [self getChildByTag: kCameraLayer];
		id spriteLayer = [cameraLayer getChildByTag: kSpriteLayer];
		NSArray *path = [spriteLayer getPathForPosition: [playerController gridPosition] andVector: cpv(0.0,1.0)];
		//NSLog(@"%@",path);
		[playerController moveAlongPath: path];
		return kEventHandled;
	}
	if (CGRectContainsPoint (CGRectMake(0.0f, 0.0f, 416.0f, 32.0f+DICKE_FINGER_TAP_TOLLERANZ),location))
	{
		[crosslayer highlightLowerCross: NO];
		if ([playerController isMoving])
			return kEventHandled;

		id cameraLayer = [self getChildByTag: kCameraLayer];
		id spriteLayer = [cameraLayer getChildByTag: kSpriteLayer];
		NSArray *path = [spriteLayer getPathForPosition: [playerController gridPosition] andVector: cpv(0.0,-1.0)];
		[playerController moveAlongPath: path];
		
		/*float x,y,z;
		 Camera *c = [cameraLayer camera];
		 [c eyeX:&x eyeY:&y eyeZ:&z];
		 NSLog(@"cam: %f,%f,%f",x,y,z);
		 [c setEyeX: x eyeY:y eyeZ: z + 20.0];*/
		return kEventHandled;
		
	}
	if (CGRectContainsPoint (CGRectMake(0.0f, 32.0f, 32.0f+DICKE_FINGER_TAP_TOLLERANZ, 256.0f),location))
	{
		[crosslayer highlightLeftCross: NO];
		if ([playerController isMoving])
			return kEventHandled;

		id cameraLayer = [self getChildByTag: kCameraLayer];
		id spriteLayer = [cameraLayer getChildByTag: kSpriteLayer];
		
		/*Layer *cl = (Layer*)cameraLayer;
		 cpVect pos = [cl position];
		 pos.x += 20.0f;
		 [cameraLayer setPosition: pos];*/
		
		NSArray *path = [spriteLayer getPathForPosition: [playerController gridPosition] andVector: cpv(-1.0,0.0)];
		//NSLog(@"%@",path);
		[playerController moveAlongPath: path];
		return kEventHandled;
	}
	if (CGRectContainsPoint (CGRectMake(448.0f-DICKE_FINGER_TAP_TOLLERANZ, 32.0f, 32.0f+DICKE_FINGER_TAP_TOLLERANZ, 256.0f),location))
	{
		[crosslayer highlightRightCross: NO];
		if ([playerController isMoving])
			return kEventHandled;
		
		id cameraLayer = [self getChildByTag: kCameraLayer];
		id spriteLayer = [cameraLayer getChildByTag: kSpriteLayer];
		NSArray *path = [spriteLayer getPathForPosition: [playerController gridPosition] andVector: cpv(1.0,0.0)];
	//	NSLog(@"%@",path);
		[playerController moveAlongPath: path];
		return kEventHandled;
	}
	
	
	
	
	return kEventHandled;
}

- (BOOL)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"touches cancelled");
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView: [touch view]];
	
	//translate location to landscape mode
	location = [[Director sharedDirector] convertCoordinate: location];
	
	return kEventHandled;
	
}



@end
