//
//  RenderView.m
//  GinkoLevelEditor
//
//  Created by jrk on 28.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "RenderView.h"


@implementation RenderView
@synthesize backgroundImage;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) 
	{
		backgroundImage = [[NSImage alloc] initWithContentsOfFile:@"/game_background.png"];
    }
    return self;
}

- (void)awakeFromNib
 {
	   [[self window] makeFirstResponder: self];
	   [[self window] setAcceptsMouseMovedEvents: YES];
	    if ([[self window] acceptsMouseMovedEvents]) {NSLog(@"window now  acceptsMouseMovedEvents");}
	 
	 NSLog(@"awake!");
 }

- (void)drawRect:(NSRect)rect 
{
    // Drawing code here.
	NSLog(@"draw rect! %f,%f",rect.origin.x,rect.origin.y);
	NSPoint p;
	p.x = 0;
	p.y = 0;
	
	NSRect r;
	r.origin.x = 0;
	r.origin.y = 0.0f;
	r.size.width = [backgroundImage size].width;
	r.size.height = [backgroundImage size].height;
	[backgroundImage drawAtPoint: p fromRect: r operation:NSCompositeCopy fraction: 1.0];
	
	
	for (id block in blocksToDraw)
	{
		NSLog(@"%@",block);
	}
	
/*	
	NSImage *img = [[NSImage alloc] initWithContentsOfFile:@"/block_1.png"];
	//NSImage *img = drawImage;
	NSLog(@"%@",img);
	
	p.x = 0;
	p.y = 0;

	
	r.origin.x = 0;
	r.origin.y = 0.0f;
	r.size.width = [img size].width;
	r.size.height = [img size].height;
	

	
	[img drawAtPoint: p fromRect: r operation:NSCompositeXOR fraction: 1.0];*/	
}

- (void)mouseDown:(NSEvent *)theEvent 
{
	NSPoint event_location = [theEvent locationInWindow];
	NSPoint local_point = [self convertPoint:event_location fromView:nil];
	
		NSLog(@"mouse down %f %f",local_point.x,local_point.y);
	
	// determine if I handle theEvent
    // if not...
    [super mouseDown:theEvent];
}

- (void)mouseMoved: (NSEvent *)theEvent 
{
	NSPoint event_location = [theEvent locationInWindow];
	NSPoint local_point = [self convertPoint:event_location fromView:nil];

	if (local_point.x <= [backgroundImage size].width &&
		local_point.y <= [backgroundImage size].height)
			NSLog(@"mouseMoved working %f,%f",local_point.x,local_point.y);
	
	[super mouseMoved: theEvent];
}

- (BOOL) acceptsFirstResponder 
{
	  return YES;
}
@end
