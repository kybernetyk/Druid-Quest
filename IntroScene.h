//
//  IntroScene.h
//  Ginko
//
//  Created by jrk on 24.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface IntroScene : Scene <TouchEventsDelegate>
{
	CocosNode *background;
	CocosNode *loadingBar;
	CocosNode *prevLoadingBar;
	int _preloadCounter;
	float prevPercent;
	NSArray *preloadArray;
	BOOL isPreloading;
}

- (void) proceedToMainMenuScene;

- (BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (BOOL)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (BOOL)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;


@end
