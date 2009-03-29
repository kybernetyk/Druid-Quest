//
//  RenderView.m
//  GinkoLevelEditor
//
//  Created by jrk on 28.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "RenderView.h"
#import "MapEntity.h"

@implementation RenderView
@synthesize backgroundImage;
@synthesize cursorImage;
@synthesize entitiesToDraw;
@synthesize drawSize;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) 
	{
		backgroundImage = [[NSImage alloc] initWithContentsOfFile:@"/game_background.png"];
		cursorImage = nil;
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
	//NSLog(@"draw rect! %f,%f",rect.origin.x,rect.origin.y);
	NSPoint p;
	p.x = 0;
	p.y = 0;
	
	NSRect r;
	r.origin.x = 0;
	r.origin.y = 0.0f;
	r.size.width = [backgroundImage size].width;
	r.size.height = [backgroundImage size].height;
	[backgroundImage drawAtPoint: p fromRect: r operation:NSCompositeCopy fraction: 1.0];
	
	
	for (MapEntity *entity in entitiesToDraw)
	{
		NSImage *img = [entity image];
		p.x = [entity gridPosition].x * 32;
		p.y = [entity gridPosition].y * 32;
		
		r.origin.x = 0;
		r.origin.y = 0.0f;
		r.size.width = [img size].width;
		r.size.height = [img size].height;
		
		[img drawAtPoint: p fromRect: r operation:NSCompositeXOR fraction: 1.0];
	}
	
	
	if (cursorImage)
	{
//		NSLog(@"%@",cursorImage);
		p.x = ((int)cursorLocation.x/32)*32;//-[cursorImage size].width/2;
		p.y = ((int)cursorLocation.y/32)*32;//-[cursorImage size].height/2;
		
		r.origin.x = 0;
		r.origin.y = 0.0f;
		r.size.width = [cursorImage size].width;
		r.size.height = [cursorImage size].height;
		
		[cursorImage drawAtPoint: p fromRect: r operation:NSCompositeXOR fraction: 1.0];
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
	NSPoint grid_point = local_point;
	grid_point.x = (int)local_point.x/32;
	grid_point.y = (int)local_point.y/32;
	
	NSLog(@"mouse down %f %f",grid_point.x,grid_point.y);
//- (IBAction) addBlockToLevel: (id) sender atPosition: (NSPoint) gridPosition
	[parentDocument addEntityToLevel: self atPosition: grid_point];
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
	{	//	NSLog(@"mouseMoved working %f,%f",local_point.x,local_point.y);
		cursorLocation = local_point;
		[self setNeedsDisplay: YES];
	}
	
	[super mouseMoved: theEvent];
}

- (BOOL) acceptsFirstResponder 
{
	  return YES;
}
@end
