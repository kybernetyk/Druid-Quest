//
//  PlayerController.h
//  Ginko
//
//  Created by jrk on 25.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SpriteController.h"

@interface PlayerController : SpriteController
{
	BOOL	isMoving;
	int		spriteFrame;
	struct  timeval lastUpdated;
	float	frameThreshold;
	float   rotadd;
	int		frameAdd;
	
	int		lastX;
	int		lastY;
	
	id initialTexture; //damit aus versehen nicht eine textur 2x released wird und eine gar nicht :/
	
	Texture2D *frame0, *frame1, *frame2, *frame3, *frame4, *frame5, *frame6;
}
@property (readonly,assign) BOOL isMoving;

- (void) _movementActionEnded;

- (void) moveAlongPath: (NSArray *) path;


@end
