//
//  PauseBackgroundLayer.m
//  Ginko
//
//  Created by jrk on 07.04.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "PauseBackgroundLayer.h"
#import "GameInfo.h"


@implementation PauseBackgroundLayer
- (id) init 
{
    self = [super init];
    if (self) 
	{
        Sprite *backgroundImage = [Sprite spriteWithFile: [[GameInfo sharedInstance] pathForGraphicsFile: @"menu_bg.png"]];
		[backgroundImage setPosition:cpv(0, 0)];
		
		//assign
		[self addChild:backgroundImage];
		
		Sprite *scrollImage = [Sprite spriteWithFile: [[GameInfo sharedInstance] pathForGraphicsFile: @"menu_scroll.png"]];
		[scrollImage setPosition:cpv(0, 0)];
		[self addChild:scrollImage];
		
		
/*		id part = [[ParticleFire alloc] init];//[[ParticleFire alloc] initWithTotalParticles: 256];
		[part setPosition: cpv(0,-160)];
		[part setScaleX: 6.0f];
		[part setScaleY: 0.3f];
		
		//assign
		[self addChild: part z: 1 tag: kParticleEffect];*/
		
    }
    return self;
}

- (void) dealloc
{
	//NSLog(@"pause background layer dealloc");
	
	[self removeAllChildrenWithCleanup: YES];
	
	[super dealloc];
}


@end
