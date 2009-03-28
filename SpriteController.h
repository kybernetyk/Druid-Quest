//
//  SpriteController.h
//  Ginko
//
//  Created by jrk on 26.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SpriteController : NSObject 
{
	Sprite *controlledSprite;
	cpVect gridPosition;
}
@property (readwrite, assign) Sprite *controlledSprite;
@property (readwrite, assign) cpVect gridPosition;

- (cpVect) bounceVector: (cpVect) attackVector;

- (id) initWithSprite: (Sprite *) spriteToControll;
- (void) update; //tick


@end
