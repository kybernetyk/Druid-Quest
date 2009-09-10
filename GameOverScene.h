//
//  GameOverScene.h
//  Ginko
//
//  Created by jrk on 04.06.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"



@interface GameOverScene : Scene <TouchEventsDelegate> 
{
	CocosNode *background;
	
	Label *textLabel;
	MenuItem *submitScoresItem;
	
	BOOL scoreWasPostedAlready;
	float rating;
}

@property (readonly, assign) float rating;

- (void) proceedToMainMenuScene: (id) sender;
- (void) proceedToHighscoreSubmit: (id) sender;

- (NSString *) congratulationsString;
- (NSString *) worldWideHighscoreString;

- (void) fetchHighscores;

- (BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (BOOL)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (BOOL)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end
