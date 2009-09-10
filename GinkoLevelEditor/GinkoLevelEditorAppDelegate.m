//
//  GinkoLevelEditorAppDelegate.m
//  GinkoLevelEditor
//
//  Created by jrk on 22.08.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "GinkoLevelEditorAppDelegate.h"


@implementation GinkoLevelEditorAppDelegate

- (id) init
{
	self = [super init];
	if (self)
	{
	}
	return self;
	
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

}




- (IBAction) exportAllOpenMaps: (id) sender
{
//	NSLog(@"export all %@!", [[NSDocumentController sharedDocumentController] documents]);
	
//	return;
	
//	GinkoLevelEditorAppDelegate *ad = (GinkoLevelEditorAppDelegate *)[[NSApplication sharedApplication] delegate];
	
	for (MyDocument *doc in [[NSDocumentController sharedDocumentController] documents])
	{
		//NSLog(@"doc: %@",[doc fileName]);
		
		if ([doc fileName])
		{
			[doc exportMap: self];
		}
	}
	
}


@end
