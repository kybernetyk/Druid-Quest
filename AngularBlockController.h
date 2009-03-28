//
//  AngularBlockController.h
//  Ginko
//
//  Created by jrk on 26.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SpriteController.h"


@interface AngularBlockController : SpriteController 
{
	cpVect originalPosition;
	cpVect normalVector;
}
@property (readwrite, assign) cpVect normalVector;


- (cpVect) bounceVector: (cpVect) attackVector;


@end
