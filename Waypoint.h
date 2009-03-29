//
//  Waypoint.h
//  Ginko
//
//  Created by jrk on 29.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import "SpriteController.h"

@interface Waypoint : NSObject 
{
	CGPoint location;
	SpriteController *assignedObject;
}

@property (readwrite,assign) CGPoint location;
@property (readwrite,assign) SpriteController *assignedObject;

@end
