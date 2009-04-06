//
//  GameInfo.m
//  Ginko
//
//  Created by jrk on 24.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "GameInfo.h"


@implementation GameInfo
@synthesize score, lives,currentLevel,lastLevel;
@synthesize time;
@synthesize activeGraphicsPack;
@synthesize activeMapPack;
@synthesize zoom,maxZoom,minZoom;
@synthesize levelGridWidth, levelGridHeight;
@synthesize finishPosition;
@synthesize worldWidth, worldHeight;

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
	[self setCurrentLevel: 1];
	[self setLastLevel: 7];
	[self setTime: 0.0f];
	[self setActiveGraphicsPack: @"blue"];
	[self setActiveMapPack: @"demo"];
	[self setWorldWidth: 480];
	[self setWorldHeight: 320];
}

-(NSString*) fullPathFromRelativePath:(NSString*) relPath
{
	NSMutableArray *imagePathComponents = [NSMutableArray arrayWithArray:[relPath pathComponents]];
	NSString *file = [imagePathComponents lastObject];
	
	[imagePathComponents removeLastObject];
	NSString *imageDirectory = [NSString pathWithComponents:imagePathComponents];
	
	return [[NSBundle mainBundle] pathForResource:file ofType:nil inDirectory:imageDirectory];	
}


- (NSString *) pathForGraphicsFile: (NSString *) filename
{
	NSString *ret = [NSString stringWithFormat:@"gpacks/%@/%@",activeGraphicsPack, filename];
	
	return ret;
}

- (NSString *) pathForMapFile: (NSString *) filename
{
	NSString *fullFilename = [NSString stringWithFormat:@"mpacks/%@/%@",activeMapPack, filename];
	NSString *ret = [self fullPathFromRelativePath: fullFilename];
	NSAssert1(ret,@"Full Path for map file %@ not found!",fullFilename);
	return ret;
}

- (NSString *) currentMapFilename
{
	return [self pathForMapFile: [NSString stringWithFormat:@"map%i.plist",currentLevel]];
}

@end
