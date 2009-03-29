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
	NSString *activeGraphicsPack;
	float zoom;
	float maxZoom;
	float minZoom;
	
	int levelGridWidth;
	int levelGridHeight;
	
	cpVect finishPosition;
	
}
+(GameInfo *) sharedInstance;

@property (readwrite, assign) int score, lives;
@property (readwrite, assign) NSString *activeGraphicsPack;
@property (readwrite, assign) float zoom;
@property (readwrite, assign) float maxZoom;
@property (readwrite, assign) float minZoom;
@property (readwrite, assign) int levelGridWidth;
@property (readwrite, assign) int levelGridHeight;

@property (readwrite,assign) cpVect finishPosition;

- (void) reset;

- (NSString *) pathForGraphicsFile: (NSString *) filename;

@end
