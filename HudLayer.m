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
		sprite = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile: @"time.png"]];
		[sprite setPosition: cpv(-480/2+[sprite contentSize].width/2 ,-320/2+11-3)];
		[self addChild: sprite];
		
		sprite2 = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile: @"steps.png"]];
		[sprite2 setPosition: cpv(480/2-[sprite2 contentSize].width-14,-320/2+11-4)];
		[self addChild: sprite2];

		sprite3 = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile: @"level.png"]];
		[sprite3 setPosition: cpv(480/2-[sprite3 contentSize].width,152)];
		[self addChild: sprite3];
		
		NSString *scoreString = [NSString stringWithFormat:@"%.4i", [[GameInfo sharedInstance] score]];
		
		score = [[LabelAtlas labelAtlasWithString:scoreString charMapFile:@"numfont.png" itemWidth:11 itemHeight:20 startCharMap:'.'] retain];
		[score setPosition:cpv(480/2-[score contentSize].width,-320/2-2-3)];
		
		NSString *timeString = [NSString stringWithFormat:@"%f", [[GameInfo sharedInstance] time]];
		
		time = [[LabelAtlas labelAtlasWithString:timeString charMapFile:@"numfont.png" itemWidth:11 itemHeight:20 startCharMap:'.'] retain];
		[time setPosition:cpv(-480/2+[sprite contentSize].width-8,-320/2-2-3)];
		
		
		NSString *levelString = [NSString stringWithFormat:@"%.2i", [[GameInfo sharedInstance] currentLevel]];
		
		level = [[LabelAtlas labelAtlasWithString: levelString charMapFile:@"numfont.png" itemWidth: 11 itemHeight: 20 startCharMap:'.'] retain];
		[level setPosition: cpv(480/2-[level contentSize].width-8+8,138)];

		
		[self addChild: score];
		[self addChild: time];
		[self addChild: level];
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
	[sprite release];
	[sprite2 release];
	[sprite3 release];
	[score release];
	[time release];
	[level release];
	[super dealloc];
}
@end
