//
//  MapEntity.m
//  GinkoLevelEditor
//
//  Created by jrk on 29.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import "MapEntity.h"


@implementation MapEntity
@synthesize image, gridPosition,type, imageName;

- (id)initWithCoder:(NSCoder *)coder 
{
    self = [super init];

    gridPosition = [coder decodePoint];
	NSNumber *tpe = [coder decodeObject];
	type = [tpe intValue];
	NSData *d = [coder decodeDataObject];
	imageName = [[NSString alloc] initWithData: d encoding: NSUTF8StringEncoding];
	//[imageName retain];
	NSLog(@"imgname: %@",imageName);
	image = [[NSImage alloc] initWithContentsOfFile: 	[[NSBundle mainBundle] pathForImageResource: imageName]];
	//[image retain];
//	[image setName: imgName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder 
{
	[coder encodePoint: gridPosition];
	NSNumber *tpe = [NSNumber numberWithInt: type];
	[coder encodeObject: tpe];
	[coder encodeDataObject: [imageName dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSDictionary *) entityToDictionary: (MapEntity *) entity
{
	NSMutableDictionary *d = [NSMutableDictionary dictionary];
	
	NSNumber *_type = [NSNumber numberWithInt: [entity type]];
//	NSValue *_location = [NSValue valueWithPoint: [entity gridPosition]];
	NSNumber *_xPos = [NSNumber numberWithFloat: [entity gridPosition].x];
	NSNumber *_yPos = [NSNumber numberWithFloat: [entity gridPosition].y];
	
	[d setObject:_type forKey:@"type"];
	[d setObject:_xPos forKey:@"gridPositionX"];
	[d setObject:_yPos forKey:@"gridPositionY"];
	
	NSDictionary *ret = [[NSDictionary dictionaryWithDictionary: d] retain];
	return ret;
	
}


@end
