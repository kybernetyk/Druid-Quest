//
//  HighScoresScene.h
//  Ginko
//
//  Created by jrk on 06.06.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HighScoresScene : Scene <TouchEventsDelegate> 
{
	Label *textLabel;
}

- (void) proceedToMainMenuScene: (id) sender;

- (NSString *) worldWideHighscoreString;
- (void) fetchHighscores;

@end
