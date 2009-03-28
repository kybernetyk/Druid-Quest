//
//  PlayerController.m
//  Ginko
//
//  Created by jrk on 25.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "PlayerController.h"


@implementation PlayerController
@synthesize controlledSprite;
@synthesize gridPosition;

#pragma mark -- init / dealloc
- (id) initWithSprite: (Sprite *) spriteToControll
{
	self = [super initWithSprite: spriteToControll];
	if (self)
	{
		isMoving = NO;
	}
	
	return self;
}

- (void) dealloc
{
	NSLog(@"player controller dealloc");
	[super dealloc];
}
#pragma mark gameLogic

#pragma mark private managment funcs
- (void) _movementActionEnded
{
	isMoving = NO;
	
	[self update];
	NSLog(@"%f,%f",gridPosition.x,gridPosition.y);
	
	
	//player dies :(
	//not the perfect place for this ... as there might be deadly blocks later
	if (((int)gridPosition.x) < 0 || ((int)(gridPosition.x)) >= 480/32 ||
		((int)gridPosition.y) < 0 || ((int)(gridPosition.y)) >= 320/32)
	{
		NSLog(@"\n\n\n\n\nO M F G DIE DIE DIE DIE DI DEE DEDEDEDE NOOOOOOOOOOOOOOOOOO");
	}
	
}


- (void) moveAlongPath: (NSArray *) path
{
	if (isMoving)
	{	
		for (NSValue *waypoint in path)
		{
			[waypoint release];
		}
		
		[path release];
		return;
	}
	isMoving = YES;
	
	Sequence *tmpseq = [Sequence actions:[MoveBy actionWithDuration: 0.01 position: cpvzero],nil];
	CGPoint p = [controlledSprite position];
	for (NSValue *waypoint in path)
	{
		CGPoint r = [waypoint CGPointValue];
		CGPoint l = cpvsub(r,p);
//		NSLog(@"start: %f,%f",p.x,p.y);
//		NSLog(@"stop: %f,%f",r.x,r.y);

		p = r;
		
		float len = cpvlength(l);
		float time = 1.5f/296.0f*len;
		
//		NSLog(@"len: %f, time: %f",len,time);
		
		id action = [MoveTo actionWithDuration: time position: r];
		tmpseq = [Sequence actionOne: tmpseq two: action];
		[waypoint release];
	}
	id fc = [CallFunc actionWithTarget: self selector: @selector(_movementActionEnded)];
	tmpseq = [Sequence actionOne: tmpseq two: fc];
	
	[controlledSprite runAction: tmpseq];
	[path release];
}


@end
