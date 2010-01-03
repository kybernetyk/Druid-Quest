//
//  NameEnterViewController.m
//  Ginko
//
//  Created by jrk on 05.06.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "NameEnterViewController.h"
#import "GameInfo.h"
#import "cocoslive.h"
#import "GameOverScene.h"

@implementation NameEnterViewController
@synthesize gameOverScene;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	[[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationLandscapeRight];
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (BOOL) textFieldShouldReturn:(UITextField *)aTextField
{
	[aTextField resignFirstResponder];

	//NSLog(@"return!");
	return NO;
}

- (void)viewDidAppear:(BOOL)animated
{
	[self updateFromGameInfo];
}

- (void) updateFromGameInfo
{
	[statusLabel setHidden: YES];
	[progressSpin stopAnimating];
	//NSLog(@"updatring from game info! %@",[[GameInfo sharedInstance] playerName] );
	[nameTextField setText: [[GameInfo sharedInstance] playerName]];
}

- (IBAction) submitScoreToServer: (id) sender
{
	[statusLabel setHidden: NO];
	[progressSpin startAnimating];
	
	[[GameInfo sharedInstance] setPlayerName: [nameTextField text]];
	[[GameInfo sharedInstance] saveToFile];
	
	[nameTextField resignFirstResponder];
	
	[self postHighScoresToServer];
}

-(void) scorePostOk:(id) sender
{
	//NSLog(@"score post ok!");
	
	[gameOverScene fetchHighscores];
	[statusLabel setHidden: YES];
	[progressSpin stopAnimating];

	[[self view] removeFromSuperview];
}

-(void) scorePostFail:(id) sender
{
	//NSLog(@"score post failed!");
	[statusLabel setHidden: YES];
	[progressSpin stopAnimating];

//	[gameOverScene fetchHighscores];
	[[self view] removeFromSuperview];

}


- (void) postHighScoresToServer
{
	id rolf = [ScoreServerPost serverWithGameName:@"Druid Quest" gameKey:@"3f3ef753f1cda7c134640a5bc7eefcaa" delegate: self];
	NSMutableDictionary *d = [NSMutableDictionary dictionary];
	
//	float rating = 1.0/([[GameInfo sharedInstance] time] + [[GameInfo sharedInstance] score]) * 300000.0f;
	float rating = [(GameOverScene*)gameOverScene rating];
	
	//NSLog(@"rating from scene: %f\rfucked up rating: %f",rating2, rating);
	int minutes = [[GameInfo sharedInstance] time]/60;
	int hours = [[GameInfo sharedInstance] time]/60/60;
	int seconds = [[GameInfo sharedInstance] time];
	
	if (seconds >= 60)
		seconds = seconds%60;
	
	if (minutes >= 60)
		minutes = minutes%60;
	
	
	NSString *timeString = [NSString stringWithFormat:@"%.2i:%.2i:%.2i",hours,minutes,seconds];
	
	[d setObject:[[GameInfo sharedInstance] playerName] forKey:@"cc_playername"];
	[d setObject:[NSNumber numberWithFloat:rating] forKey:@"cc_score"];
	[d setObject:[NSNumber numberWithInt:(int)rating] forKey:@"usr_rating"];
	[d setObject:timeString forKey:@"usr_time"];
	[d setObject:[NSNumber numberWithInt:(int)[[GameInfo sharedInstance] score]] forKey:@"usr_steps"];
	
	
	
	d = [NSDictionary dictionaryWithDictionary: d];
	[rolf sendScore: d];
}


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
