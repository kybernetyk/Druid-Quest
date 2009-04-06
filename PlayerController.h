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
	
	Texture2D *frame0, *frame1;
}
@property (readonly,assign) BOOL isMoving;

- (void) _movementActionEnded;

- (void) moveAlongPath: (NSArray *) path;


@end
