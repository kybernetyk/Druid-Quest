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

	
	levelPath = [[NSArray alloc] initWithObjects: @"2",@"4",@"3",@"5",@"10",@"8",@"6",@"12",@"16",@"7",@"15",@"24",@"14",@"11",@"28",@"1",@"26",@"25",@"27",@"23",@"17",@"13",@"21",@"22",@"9",nil];
	
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
	[self setLastLevel: [levelPath count]]; //11
	[self setTime: 0.0f];
	[self setActiveGraphicsPack: @"druidquest"];
	[self setActiveMapPack: @"final"];
	[self setWorldWidth: 480];
	[self setWorldHeight: 320];
	[self setIsPaused: NO];
	[self setPlayerName: @"player"];
	
	[self loadFromFile];
}

- (void) loadFromFile
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filename = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"savegame.plist"];
	
	
	NSMutableDictionary *d = [NSMutableDictionary dictionaryWithContentsOfFile: filename];
	NSString *name = [d objectForKey: @"player_name"];
	
	if (name)
		[self setPlayerName: name];
}

- (void) resumeFromFile
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filename = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"savegame.plist"];
	
	
	[self reset];
	
	NSMutableDictionary *d = [NSMutableDictionary dictionaryWithContentsOfFile: filename];
	
	if (!d)
	{
		[self reset];
		return;
	}
	
	NSString *name = [d objectForKey: @"player_name"];
	int level = [[d objectForKey: @"current_level"] intValue];
	float time = [[d objectForKey: @"time"] floatValue];
	int score = [[d objectForKey: @"score"] intValue];
	
	
	[self setCurrentLevel: level];
	[self setTime: time];
	[self setScore: score];
	
	if (level == 0)
		[self reset];
	if (level > lastLevel)
		[self reset];
	
	if (name)
		[self setPlayerName: name];

}

- (void) saveToFile
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filename = [NSString stringWithFormat:@"%@/%@",documentsDirectory,@"savegame.plist"];
	
	
	NSMutableDictionary *d = [NSMutableDictionary dictionary];
	
	if (playerName)
		[d setObject: playerName forKey: @"player_name"];
	
	[d setObject: [NSNumber numberWithInt: currentLevel] forKey:@"current_level"];
	[d setObject: [NSNumber numberWithFloat: time] forKey: @"time"];
	[d setObject: [NSNumber numberWithInt: score] forKey: @"score"];
	
	[d writeToFile: filename atomically: YES];
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
	NSLog(@"returning name: %@",[NSString stringWithFormat:@"level%@.plist",[levelPath objectAtIndex: (currentLevel-1)]]);
	
	return [self pathForMapFile: [NSString stringWithFormat:@"level%@.plist",[levelPath objectAtIndex: (currentLevel-1)]]];
}

@end
