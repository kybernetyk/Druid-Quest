//
//  BlockFactory.m
//  Ginko
//
//  Created by jrk on 29.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "BlockFactory.h"
#import "GameInfo.h"
#import "PlayerController.h"
#import "AngularBlockController.h"
#import "FinishController.h"

@implementation BlockFactory

+ (NSDictionary *) createBlockControllerPair: (int) type positionX: (int) posX positionY: (int) posY
{
	id node = nil;
	id controller = nil;
	NSString *spriteFileName = @"";
	
	
	switch (type)
	{
			//player is handled extra lol
		case kPlayer:
			spriteFileName = @"player0.png";
			node = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:spriteFileName]];
			[node setPosition:cpv(posX *32,posY *32)];
			controller = [[PlayerController alloc] initWithSprite: node];
			//[node setzOrder: 10];
			//node.zOrder = 10;
		//	NSLog(@"player %i!",[controller retainCount]);
			break;
			
		case kFinish:
			spriteFileName = @"finish.png";
			node = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:spriteFileName]];
			[node setPosition:cpv(posX *32,posY *32)];
			controller = [[FinishController alloc] initWithSprite: node];
			
		//	NSLog(@"finish! %@",node);
			break;
			
		case kSimpleBlock:
			spriteFileName = @"block_1_1.png";
			if (rand()%2 == 1)
				spriteFileName = @"block_1_2.png";	
			
			node = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:spriteFileName]];
			[node setPosition:cpv(posX *32,posY *32)];
			controller = [[SpriteController alloc] initWithSprite: node];

			break;
			
		case kBlockNormal_South_East:
			spriteFileName = @"block_4.png";
			node = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:spriteFileName]];
			[node setPosition:cpv(posX *32,posY *32)];
			controller = [[AngularBlockController alloc] initWithSprite: node];
			[controller setNormalVector: cpv(1.0,-1.0)];
			//NSLog(@"south_east! %i,%i",posX,posY);
			break;

		case kBlockNormal_North_East:
			spriteFileName = @"block_3.png";
			node = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:spriteFileName]];
			[node setPosition:cpv(posX *32,posY *32)];
			controller = [[AngularBlockController alloc] initWithSprite: node];
			[controller setNormalVector: cpv(1.0,1.0)];
			//NSLog(@"north_east! %i,%i",posX,posY);
			break;
			
			
		case kBlockNormal_North_West:
			spriteFileName = @"block_2.png";
			node = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:spriteFileName]];
			[node setPosition:cpv(posX *32,posY *32)];
			controller = [[AngularBlockController alloc] initWithSprite: node];
			[controller setNormalVector: cpv(-1.0,1.0)];
			//NSLog(@"north_west! %i,%i",posX,posY);
			break;
			
		case kBlockNormal_South_West:
			spriteFileName = @"block_5.png";
			node = [[Sprite alloc] initWithFile: [[GameInfo sharedInstance] pathForGraphicsFile:spriteFileName]];
			[node setPosition:cpv(posX *32,posY *32)];
			controller = [[AngularBlockController alloc] initWithSprite: node];
			[controller setNormalVector: cpv(-1.0,-1.0)];
			//NSLog(@"north_west! %i,%i",posX,posY);
			break;
			
		case kEmpty:
		default:
			//NSLog(@"wuts dat? empty entity in mapfile!");
			//exit(44);
			node = nil;
			controller = nil;
			break;
	}
			//NSLog(@"%@ == %@",node,spriteFileName);
	NSDictionary *ret = [NSDictionary dictionaryWithObjectsAndKeys:node,@"node",controller,@"controller",nil];
	[ret retain];
	//NSLog(@"%@",ret);
	return ret;
}


@end
