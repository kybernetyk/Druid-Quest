//
//  BirdController.h
//  Ginko
//
//  Created by jrk on 06.04.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpriteController.h"

@interface BirdController : SpriteController 
{
	BOOL isMoving;
	int		spriteFrame;
	struct  timeval lastUpdated;
	float	frameThreshold;	
	cpVect destPoint;
	float idleFlapTime;
	float idleTurnTime;
	float flapThreshold;
	float turnThreshold;
	
	id flyaction;
	id initialTexture;
	
	Texture2D *frame0, *frame1, *frame2;
}
@property (readwrite, assign) cpVect destPoint;
- (id) initWithSprite: (Sprite *) spriteToControll colorPrefix: (NSString *)colorPrefix;

@end
