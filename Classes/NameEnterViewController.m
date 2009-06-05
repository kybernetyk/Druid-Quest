//
//  NameEnterViewController.m
//  Ginko
//
//  Created by jrk on 05.06.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "NameEnterViewController.h"
#import "GameInfo.h"

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

	NSLog(@"return!");
	return NO;
}

- (void)viewDidAppear:(BOOL)animated
{
	[self updateFromGameInfo];
}

- (void) updateFromGameInfo
{
	NSLog(@"updatring from game info! %@",[[GameInfo sharedInstance] playerName] );
	[nameTextField setText: [[GameInfo sharedInstance] playerName]];
}

- (IBAction) submitScoreToServer: (id) sender
{
	[[GameInfo sharedInstance] setPlayerName: [nameTextField text]];
	[nameTextField resignFirstResponder];
	
	[gameOverScene fetchHighscores];
	[[self view] removeFromSuperview];
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
