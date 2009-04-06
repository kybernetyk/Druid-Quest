//
//  HudLayer.m
//  Ginko
//
//  Created by jrk on 06.04.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "HudLayer.h"
#import "GameInfo.h"


@implementation HudLayer

- (id) init 
{
    self = [super init];
    if (self) 
	{
//		label = [Label labelWithString:value fontName:_fontName fontSize:_fontSize];
		NSLog(@"lalalal");
		
		Sprite *sprite = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile: @"time.png"]];
		[sprite setPosition: cpv(-480/2+[sprite contentSize].width/2 ,-320/2+11-3)];
		[self addChild: sprite];
		
		Sprite *sprite2 = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile: @"steps.png"]];
		[sprite2 setPosition: cpv(480/2-[sprite2 contentSize].width-14,-320/2+11-4)];
		[self addChild: sprite2];
		
		NSString *scoreString = [NSString stringWithFormat:@"%.4i", [[GameInfo sharedInstance] score]];
		
		//score = [Label labelWithString:@"distance: 0001" fontName:@"Helvetica" fontSize: 20.0f];
		score = [[LabelAtlas labelAtlasWithString:scoreString charMapFile:@"numfont.png" itemWidth:11 itemHeight:20 startCharMap:'.'] retain];
		[score setPosition:cpv(480/2-[score contentSize].width,-320/2-2-3)];
		[score retain];
		
		//time = [Label labelWithString:@"time: 99.99.99" fontName:@"Helvetica" fontSize: 20.0f];
//		time = [Label la
		
		NSString *timeString = [NSString stringWithFormat:@"%f", [[GameInfo sharedInstance] time]];
		
		time = [[LabelAtlas labelAtlasWithString:timeString charMapFile:@"numfont.png" itemWidth:11 itemHeight:20 startCharMap:'.'] retain];
		[time setPosition:cpv(-480/2+[sprite contentSize].width-8,-320/2-2-3)];
		[time retain];
		
		[self addChild: score];
		[self addChild: time];
		
	}
	return self;
}

- (void) update
{
	//NSLog(@"layer update!\n");
	
	NSString *scoreString = [NSString stringWithFormat:@"%.4i", [[GameInfo sharedInstance] score]];
	[score setString:scoreString];
	
	int minutes = [[GameInfo sharedInstance] time]/60;
	int hours = [[GameInfo sharedInstance] time]/60/60;
	int seconds = [[GameInfo sharedInstance] time];
	
	if (seconds >= 60)
		seconds = seconds%60;
	
	if (minutes >= 60)
		minutes = minutes%60;
	
	
	NSString *timeString = @"";
	
	if (seconds % 2 != 0)
		timeString = [NSString stringWithFormat:@"%.2i %.2i %.2i",hours,minutes,seconds];
	else
		timeString = [NSString stringWithFormat:@"%.2i:%.2i:%.2i",hours,minutes,seconds];
	[time setString: timeString];
	
}

- (void) dealloc
{
	[score release];
	[time release];
	[super dealloc];
}
@end