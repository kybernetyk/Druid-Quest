//
//  GinkoAppDelegate.h
//  Ginko
//
//  Created by jrk on 24.03.09.
//  Copyright flux forge 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NameEnterViewController.h"
#import <AVFoundation/AVAudioPlayer.h>
//#import "GameOverScene.h"

#define kGinkoMusicNone 0
#define kGinkoMusicMenuTheme 1
#define kGinkoMusicGameTheme 2
#define kGinkoMusicScoreTheme 3

@interface GinkoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	NameEnterViewController *nameEnterViewController;
	UIImageView *splashView; 
	
	AVAudioPlayer *audioplayer;
	NSUInteger whichMusicIsPlaying;
	BOOL isMusicPlaybackEnabled;
}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (readwrite, assign) BOOL isMusicPlaybackEnabled;

- (void) showHighscoreInput: (id) sender;

- (void) playMenuMusic;
- (void) playGameMusic;
- (void) playScoreMusic;
- (void) stopMusicPlayback;


@end

