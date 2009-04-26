//
//  FinishController.h
//  Ginko
//
//  Created by jrk on 29.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpriteController.h"

@interface FinishController : SpriteController 
{
	Sprite *animationSprite;
	
	Texture2D *frame0, *frame1, *frame2, *frame3, *frame4, *frame5, *frame6; 
	
	Texture2D *currentFrame;
	
	id initialTexture;
	
	int		spriteFrame;
	float	frameThreshold;	

}

@property (readwrite,retain) Sprite *animationSprite;

@end
