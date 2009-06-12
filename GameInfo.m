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
@synthesize isPaused;
@synthesize playerName;

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
	[self setLastLevel: 11]; //11
	[self setTime: 0.0f];
	[self setActiveGraphicsPack: @"druidquest"];
	[self setActiveMapPack: @"druid"];
	[self setWorldWidth: 480];
	[self setWorldHeight: 320];
	[self setIsPaused: NO];
	[self setPlayerName: @"player"];
	
	[self loadFromFile];
}

- (void) loadFromFile
{
	NSMutableDictionary *d = [NSMutableDictionary dictionaryWithContentsOfFile:@"savegame.plist"];
	NSString *name = [d objectForKey: @"player_name"];
	
	[self setPlayerName: name];
}

- (void) resumeFromFile
{
	[self reset];
	
	NSMutableDictionary *d = [NSMutableDictionary dictionaryWithContentsOfFile:@"savegame.plist"];
	NSString *name = [d objectForKey: @"player_name"];
	int level = [[d objectForKey: @"current_level"] intValue];
	float time = [[d objectForKey: @"time"] floatValue];
	int score = [[d objectForKey: @"score"] intValue];
	
	[self setPlayerName: name];
	[self setCurrentLevel: level];
	[self setTime: time];
	[self setScore: score];
	
	if (level == 0)
		[self reset];
}

- (void) saveToFile
{
	NSMutableDictionary *d = [NSMutableDictionary dictionary];
	[d setObject: playerName forKey: @"player_name"];
	[d setObject: [NSNumber numberWithInt: currentLevel] forKey:@"current_level"];
	[d setObject: [NSNumber numberWithFloat: time] forKey: @"time"];
	[d setObject: [NSNumber numberWithInt: score] forKey: @"score"];
	
	[d writeToFile:@"savegame.plist" atomically: YES];
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
