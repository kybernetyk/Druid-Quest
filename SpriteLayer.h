//
//  SpriteLayer.h
//  Ginko
//
//  Created by jrk on 26.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PlayerController.h"

@interface SpriteLayer : Layer
{
	PlayerController *playerController;
	NSMutableArray *spriteControllers;
	NSMutableArray *sprites;

}

@property (readonly,assign) PlayerController *playerController;

- (id) initWithLevelFile: (NSString *) filename;

//array of waypoints
- (NSArray *) getPathForPosition: (cpVect) startPosition andVector: (cpVect) directionVector;

@end
