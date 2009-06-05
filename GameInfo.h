//
//  GameInfo.h
//  Ginko
//
//  Created by jrk on 24.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameInfo : NSObject 
{
	int score;
	int lives;
	int currentLevel;
	int lastLevel;
	float time;
	
	NSString *activeGraphicsPack;
	NSString *activeMapPack;

	NSString *playerName;
	
	BOOL isPaused;
	
	float zoom;
	float maxZoom;
	float minZoom;
	
	int levelGridWidth;
	int levelGridHeight;
	
	int worldWidth;
	int worldHeight;
	
	cpVect finishPosition;
	
}
+(GameInfo *) sharedInstance;

@property (readwrite, assign) int score, lives,currentLevel,lastLevel;
@property (readwrite, assign) NSString *activeGraphicsPack;
@property (readwrite, assign) NSString *activeMapPack;
@property (readwrite, assign) float zoom;
@property (readwrite, assign) float maxZoom;
@property (readwrite, assign) float minZoom;
@property (readwrite, assign) float time;
@property (readwrite, assign) BOOL isPaused;
@property (readwrite, assign) int worldWidth, worldHeight;
@property (readwrite, assign) int levelGridWidth;
@property (readwrite, assign) int levelGridHeight;
@property (readwrite, copy) NSString *playerName;

@property (readwrite,assign) cpVect finishPosition;

- (void) reset;

- (NSString *) pathForGraphicsFile: (NSString *) filename;
- (NSString *) pathForMapFile: (NSString *) filename;
- (NSString *) currentMapFilename;

- (void) loadFromFile;
- (void) saveToFile;

@end
