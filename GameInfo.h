//
//  GameInfo.h
//  Ginko
//
//  Created by jrk on 24.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameInfo : NSObject 
{
	int score;
	int lives;
	NSString *activeGraphicsPack;
	float zoom;
	float maxZoom;
	float minZoom;
}
+(GameInfo *) sharedInstance;

@property (readwrite, assign) int score, lives;
@property (readwrite, assign) NSString *activeGraphicsPack;
@property (readwrite, assign) float zoom;
@property (readwrite, assign) float maxZoom;
@property (readwrite, assign) float minZoom;

- (void) reset;

- (NSString *) pathForGraphicsFile: (NSString *) filename;

@end
