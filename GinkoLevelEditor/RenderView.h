//
//  RenderView.h
//  GinkoLevelEditor
//
//  Created by jrk on 28.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface RenderView : NSView 
{
	NSImage *backgroundImage;
	NSArray *entitiesToDraw;
	NSImage *cursorImage;
	NSPoint cursorLocation;
	NSSize drawSize;
	
	IBOutlet NSDocument *parentDocument;
}
@property (readwrite,retain) NSImage *backgroundImage;
@property (readwrite,assign) NSImage *cursorImage;
@property (readwrite,assign) NSArray *entitiesToDraw;
@property (readwrite,assign) NSSize drawSize;

@end
