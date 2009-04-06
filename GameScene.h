//
//  GameScene.h
//  Ginko
//
//  Created by jrk on 24.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PlayerController.h"

@interface GameScene : Scene <TouchEventsDelegate>
{
	PlayerController *playerController;
	struct  timeval lastUpdated;
	float	timeThreshold;

}

- (void) loadScene;
- (void) unloadScene;
- (void) resetScene;

- (BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (BOOL)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (BOOL)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;


- (void) checkCameraBounds;
- (void) moveCameraBy: (float) x y: (float) y;
- (void) zoomCameraBy: (float)zoomAmmount zoomCenter: (cpVect)center;

@end
