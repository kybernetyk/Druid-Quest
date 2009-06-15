//
//  TeleporterController.h
//  Ginko
//
//  Created by jrk on 15.06.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpriteController.h"


@interface TeleporterController : SpriteController 
{
	Texture2D *frame0, *frame1, *frame2, *frame3, *frame4; 
	Texture2D *currentFrame;
	
	id initialTexture;
	int		spriteFrame;
	float	frameThreshold;	
	
	TeleporterController *linkedTeleport;
}

@property (readwrite, assign) TeleporterController *linkedTeleport;

@end
