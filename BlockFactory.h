//
//  BlockFactory.h
//  Ginko
//
//  Created by jrk on 29.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SpriteController.h"
#import "Sprite.h"

enum blockTags
{
	kEmpty = 0,
	kPlayer = 1,
	kFinish = 2,
	kSimpleBlock = 3,
	
	kBlockNormal_South_East = 4,
	kBlockNormal_North_East = 5,
	kBlockNormal_North_West = 6,
	kBlockNormal_South_West = 7
};



@interface BlockFactory : NSObject 
{

}

+ (NSDictionary *) createBlockControllerPair: (int) type positionX: (int) posX positionY: (int) posY;

@end
