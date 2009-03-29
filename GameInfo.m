//
//  GameInfo.m
//  Ginko
//
//  Created by jrk on 24.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "GameInfo.h"


@implementation GameInfo
@synthesize score, lives;
@synthesize activeGraphicsPack;
@synthesize zoom,maxZoom,minZoom;
@synthesize levelGridWidth, levelGridHeight;
@synthesize finishPosition;

static GameInfo *sharedSingleton = nil;

+(GameInfo*)sharedInstance 
{
    @synchronized(self) 
	{
        if (sharedSingleton == nil) 
		{
            [[self alloc] init]; // assignment not done here
        }
    }
    return sharedSingleton;
}


+(id)allocWithZone:(NSZone *)zone 
{
    @synchronized(self) 
	{
        if (sharedSingleton == nil) 
		{
            sharedSingleton = [super allocWithZone:zone];
            return sharedSingleton;  // assignment and return on first allocation
        }
    }
    return nil; //on subsequent allocation attempts return nil
}


-(void)dealloc 
{
    [super dealloc];
}

-(id)copyWithZone:(NSZone *)zone 
{
    return self;
}


-(id)retain 
{
    return self;
}


-(unsigned)retainCount {
    return UINT_MAX;  //denotes an object that cannot be release
}


-(void)release 
{
    //do nothing    
}


-(id)autorelease 
{
    return self;    
}


-(id)init 
{
    self = [super init];
    sharedSingleton = self;
	
    //initialize here
	[self reset];
	
    return self;
}

- (void) reset
{
	[self setScore: 0];
	[self setLives: 0];
	[self setZoom: 1.0f];
	[self setActiveGraphicsPack: @"blue"];
}

- (NSString *) pathForGraphicsFile: (NSString *) filename
{
	NSString *ret = [NSString stringWithFormat:@"gpacks/%@/%@",activeGraphicsPack, filename];
	
	return ret;
}


@end
