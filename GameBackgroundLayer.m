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
        Sprite *backgroundImage = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"game_background.png"]];
		[backgroundImage setPosition:cpv(0, 0)];
		
		//assign
		[self addChild:backgroundImage z: 0 tag: kBackgroundImage];
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
