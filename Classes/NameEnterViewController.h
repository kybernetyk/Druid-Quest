//
//  NameEnterViewController.h
//  Ginko
//
//  Created by jrk on 05.06.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NameEnterViewController : UIViewController 
{
	IBOutlet id nameTextField;
	IBOutlet id statusLabel;
	IBOutlet id progressSpin;
	
	id gameOverScene;
}

@property (readwrite, assign) id gameOverScene;

- (IBAction) submitScoreToServer: (id) sender;

- (void) updateFromGameInfo;
- (void) postHighScoresToServer;

@end
