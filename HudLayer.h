//
//  HudLayer.h
//  Ginko
//
//  Created by jrk on 06.04.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface HudLayer : Layer
{
	Label *score;
	Label *time;
	Label *level;
	
	Sprite *sprite,*sprite2,*sprite3;
}

@end
