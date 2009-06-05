//
//  GinkoAppDelegate.h
//  Ginko
//
//  Created by jrk on 24.03.09.
//  Copyright flux forge 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NameEnterViewController.h"
//#import "GameOverScene.h"

@interface GinkoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	NameEnterViewController *nameEnterViewController;
}

- (void) showHighscoreInput: (id) sender;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

