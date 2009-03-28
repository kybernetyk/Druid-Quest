//
//  MenuBackgroundLayer.m
//  Ginko
//
//  Created by jrk on 24.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "MenuBackgroundLayer.h"


@implementation MenuBackgroundLayer

enum BackgroundLayerNodeTags 
{
	kBackgroundImage,
	kParticleEffect
};

- (id) init 
{
    self = [super init];
    if (self) 
	{
        Sprite *backgroundImage = [[Sprite alloc] initWithFile: @"menu_background.png"];
		[backgroundImage setPosition:cpv(0, 0)];
  
		//assign
		[self addChild:backgroundImage z: 0 tag: kBackgroundImage];
		
		id part = [[ParticleFire alloc] init];//[[ParticleFire alloc] initWithTotalParticles: 256];
		[part setPosition: cpv(0,-160)];
		[part setScaleX: 6.0f];
		[part setScaleY: 0.3f];

		//assign
		[self addChild: part z: 1 tag: kParticleEffect];
		
    }
    return self;
}

- (void) dealloc
{
	NSLog(@"menu background layer dealloc");
	
	Sprite *backgroundImage = (Sprite*)[self getChildByTag: kBackgroundImage];
	ParticleFire *fire = (ParticleFire*)[self getChildByTag: kParticleEffect];
	
	[self removeChildByTag: kBackgroundImage cleanup: YES];
	[self removeChildByTag: kParticleEffect cleanup: YES];
	
	[backgroundImage release];
	[fire release];
	

	
	[super dealloc];
}


@end
