//
//  MapEntity.h
//  GinkoLevelEditor
//
//  Created by jrk on 29.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MapEntity : NSObject <NSCoding>
{
	NSImage *image;
	NSPoint gridPosition;
	NSInteger type;
}

@property (readwrite, assign) NSImage *image;
@property (readwrite, assign) NSPoint gridPosition;
@property (readwrite, assign) NSInteger type;

+ (NSDictionary *) entityToDictionary: (MapEntity *) entity;

@end
