//
//  MenuBackgroundLayer.m
//  Ginko
//
//  Created by jrk on 24.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "MenuBackgroundLayer.h"
#import "GameInfo.h"

@implementation MenuBackgroundLayer

enum BackgroundLayerNodeTags 
{
	kBackgroundImage,
	kScrollImage
};

- (id) init 
{
    self = [super init];
    if (self) 
	{
		Sprite *backgroundImage = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile: @"menu_bg.png"]];
		[backgroundImage setPosition:cpv(0, 0)];
		[self addChild:backgroundImage z: 0 tag: kBackgroundImage];

		Sprite *scrollImage = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile: @"menu_scroll.png"]];
		[scrollImage setPosition:cpv(0, 0)];
		[self addChild:scrollImage z: 0 tag: kScrollImage];
		
		
	//	id part = [[ParticleFire alloc] init];//[[ParticleFire alloc] initWithTotalParticles: 256];
	//	[part setPosition: cpv(0,-160)];
	//	[part setScaleX: 6.0f];
	//	[part setScaleY: 0.3f];

		//assign
	//	[self addChild: part z: 1 tag: kParticleEffect];
		
    }
    return self;
}

- (void) dealloc
{
	NSLog(@"menu background layer dealloc");
	
	Sprite *backgroundImage = (Sprite*)[self getChildByTag: kBackgroundImage];
	Sprite *scrollImage = (Sprite*)[self getChildByTag: kScrollImage];
	
	[self removeChildByTag: kBackgroundImage cleanup: YES];
	[self removeChildByTag: kScrollImage cleanup: YES];
	
	[backgroundImage release];
	[scrollImage release];

	
	[super dealloc];
}


@end
