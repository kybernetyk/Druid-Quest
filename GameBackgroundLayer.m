//
//  GameBackgroundLayer.m
//  Ginko
//
//  Created by jrk on 25.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "GameBackgroundLayer.h"
#import "GameInfo.h"

@implementation GameBackgroundLayer
enum BackgroundLayerNodeTags 
{
	kBackgroundImage
};


- (id) init 
{
    self = [super init];
    if (self) 
	{
		NSDictionary *mapInfo = [NSDictionary dictionaryWithContentsOfFile: [[GameInfo sharedInstance] currentMapFilename]];
		NSAssert(mapInfo,@"map not found!");
		
		NSString *filename = [NSString stringWithFormat:@"%@_background.png",[mapInfo objectForKey:@"BackgroundGraphic"]];
		NSLog(@"filename is: %@",filename);
		
        Sprite *backgroundImage = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile: filename]];
		NSAssert(backgroundImage,@"could not load background image!");
		
		[backgroundImage setPosition:cpv(0, 0)];
		
		//assign
		[self addChild:backgroundImage z: 0 tag: kBackgroundImage];
		
		[[GameInfo sharedInstance] setWorldWidth: [[backgroundImage texture] contentSize].width];
		[[GameInfo sharedInstance] setWorldHeight: [[backgroundImage texture] contentSize].height];
		
		NSLog(@"%i,%i",[[GameInfo sharedInstance] worldWidth],[[GameInfo sharedInstance] worldHeight]);
    }
    return self;
}

- (void) dealloc
{
	NSLog(@"game background layer dealloc");
	
	id node = [self getChildByTag: kBackgroundImage];
	
	[self removeChild: node cleanup: YES];
	[node release];
	
	[super dealloc];
}

@end
