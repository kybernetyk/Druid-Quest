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
	NSArray *blocksToDraw;

}
@property (readwrite,retain) NSImage *backgroundImage;
@property (readwrite,assign) NSArray *blocksToDraw;

@end
