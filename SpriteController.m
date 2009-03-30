//
//  SpriteController.m
//  Ginko
//
//  Created by jrk on 26.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "SpriteController.h"


@implementation SpriteController
@synthesize controlledSprite;
@synthesize gridPosition;

#pragma mark -- init / dealloc
- (id) initWithSprite: (Sprite *) spriteToControll
{
	self = [super init];
	if (self)
	{
		controlledSprite = spriteToControll;
	}
	
	return self;
}

- (id) init
{
	NSLog(@"YOU MAY NOT CALL SpriteController::init() directly!");
	exit (23);
	
	return nil;
}

#pragma mark game logic
- (void) update
{
	gridPosition = cpv([controlledSprite position].x/32,[controlledSprite position].y/32);
	
	//NSLog(@"sprite controller %@ grid positon: %f,%f",self ,gridPosition.x, gridPosition.y);
}

#pragma mark -- normal Vector
- (cpVect) bounceVector: (cpVect) attackVector
{
	//NSLog(@"simple sprite bounceblock!");
	return cpvzero;
}

@end
