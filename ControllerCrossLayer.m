//
//  ControllerCrossLayer.m
//  Ginko
//
//  Created by jrk on 25.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "ControllerCrossLayer.h"
#import "GameInfo.h"

@implementation ControllerCrossLayer
enum BackgroundLayerNodeTags 
{
	kCrossUpImage,
	kCrossRightImage,
	kCrossDownImage,
	kCrossLeftImage,
	kCrossVertBackOne,
	kCrossVertBackTwo,
	kCrossHorizBackOne,
	kCrossHorizBackTwo
};


- (id) init 
{
    self = [super init];
    if (self) 
	{
		Sprite *image = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"vert_cross_back.png"]];
		[image setPosition:cpv(480/2-16,0)];
		[image setOpacity: 16];
		[self addChild:image z: 0 tag: kCrossVertBackOne];
		
		image = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"vert_cross_back.png"]];
		[image setPosition:cpv(-480/2+16,0)];
		[image setOpacity: 16];
		[self addChild:image z: 0 tag: kCrossVertBackTwo];
	
		image = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"horiz_cross_back.png"]];
		[image setPosition:cpv(0,320/2-16)];
		[image setOpacity: 16];
		[self addChild:image z: 0 tag: kCrossHorizBackOne];
		
		image = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"horiz_cross_back.png"]];
		[image setPosition:cpv(0,-320/2+16)];
		[image setOpacity: 16];
		[self addChild:image z: 0 tag: kCrossHorizBackTwo];
		
//--
		
		image = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"cross_up.png"]];
		[image setPosition:cpv(0, 320/2-16)];
		[image setOpacity: 64];
		[self addChild:image z: 2 tag: kCrossUpImage];

		image = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"cross_right.png"]];
		[image setPosition:cpv(480/2-16, 0)];
		[image setOpacity: 64];
		[self addChild:image z: 1 tag: kCrossRightImage];
		
		image = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"cross_down.png"]];
		[image setPosition:cpv(0, -320/2+16)];
		[image setOpacity: 64];
		[self addChild:image z: 2 tag: kCrossDownImage];
		
		image = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:@"cross_left.png"]];
		[image setPosition:cpv(-480/2+16, 0)];
		[image setOpacity: 64];
		[self addChild:image z: 1 tag: kCrossLeftImage];
	}
    return self;
}

- (void) dealloc
{
	NSLog(@"controller cross layer dealloc");
	
	id node = [self getChildByTag: kCrossUpImage];
	[self removeChild: node cleanup: YES];
	[node release];
	
	node = [self getChildByTag: kCrossRightImage];
	[self removeChild: node cleanup: YES];
	[node release];
	
	node = [self getChildByTag: kCrossDownImage];
	[self removeChild: node cleanup: YES];
	[node release];
	
	node = [self getChildByTag: kCrossLeftImage];
	[self removeChild: node cleanup: YES];
	[node release];
	

	node = [self getChildByTag: kCrossVertBackOne];
	[self removeChild: node cleanup: YES];
	[node release];

	node = [self getChildByTag: kCrossVertBackTwo];
	[self removeChild: node cleanup: YES];
	[node release];

	node = [self getChildByTag: kCrossHorizBackOne];
	[self removeChild: node cleanup: YES];
	[node release];
	
	node = [self getChildByTag: kCrossHorizBackTwo];
	[self removeChild: node cleanup: YES];
	[node release];
	
	
	
	[self removeAllChildrenWithCleanup: YES];
	
	[super dealloc];
}

#pragma mark -- higlighting
- (void) highlightUpperCross: (BOOL) shouldHighlight
{
	int opa = 64;
	if (shouldHighlight)
		opa = 128;
		
	id node = [self getChildByTag: kCrossUpImage];
	[node setOpacity: opa];
	
	node = [self getChildByTag: kCrossHorizBackOne];
	[node setOpacity: opa - 48];
}

- (void) highlightLowerCross: (BOOL) shouldHighlight
{
	int opa = 64;
	if (shouldHighlight)
		opa = 128;
	
	id node = [self getChildByTag: kCrossDownImage];
	[node setOpacity: opa];

	node = [self getChildByTag: kCrossHorizBackTwo];
	[node setOpacity: opa - 48];

}

- (void) highlightLeftCross: (BOOL) shouldHighlight
{
	int opa = 64;
	if (shouldHighlight)
		opa = 128;
	
	id node = [self getChildByTag: kCrossLeftImage];
	[node setOpacity: opa];
	
	node = [self getChildByTag: kCrossVertBackTwo];
	[node setOpacity: opa - 48];

	
}

- (void) highlightRightCross: (BOOL) shouldHighlight
{
	int opa = 64;
	if (shouldHighlight)
		opa = 128;
	
	id node = [self getChildByTag: kCrossRightImage];
	[node setOpacity: opa];
	
	node = [self getChildByTag: kCrossVertBackOne];
	[node setOpacity: opa - 48];

}


@end
