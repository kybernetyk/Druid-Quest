//
//  MyDocument.h
//  GinkoLevelEditor
//
//  Created by jrk on 28.03.09.
//  Copyright flux forge 2009 . All rights reserved.
//


#import <Cocoa/Cocoa.h>

@interface MyDocument : NSDocument
{
	IBOutlet NSView *renderView;
	
	NSMutableArray *blocksInLevel;
	int currentylSelectedBlocktype;
}
@property (readwrite, assign) NSView *renderView;
@property (readwrite, assign) NSMutableArray *blocksInLevel;

- (IBAction) render: (id) sender;
- (IBAction) changeCurrentBlockType: (id) sender;

@end
