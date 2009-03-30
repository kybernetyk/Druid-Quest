//
//  MyDocument.m
//  GinkoLevelEditor
//
//  Created by jrk on 28.03.09.
//  Copyright flux forge 2009 . All rights reserved.
//

#import "MyDocument.h"
#import "MapEntity.h"

@implementation MyDocument
@synthesize renderView;
@synthesize entitiesInLevel;
@synthesize mapGridWidth, mapGridHeight;

- (IBAction) render: (id) sender
{

    // Drawing code here.
//	NSLog(@"draw rect! %f,%f",rect.origin.x,rect.origin.y);
	[renderView setNeedsDisplay: YES];
	
}

enum blockTags
{
	kEmpty = 0,
	kPlayer = 1,
	kFinish = 2,
	kSimpleBlock = 3,
	
	kBlockNormal_South_East = 4,
	kBlockNormal_North_East = 5,
	kBlockNormal_North_West = 6,
	kBlockNormal_South_West = 7
};


- (IBAction) changeCurrentBlockType: (id) sender
{
	NSLog(@"%i",[[sender selectedCell] tag]);
	switch ([[sender selectedCell] tag])
	{
		case kPlayer:
			NSLog(@"player!");
			break;
			
		case kFinish:
			NSLog(@"finish!");
			break;

		case kSimpleBlock:
			NSLog(@"block!");
			break;
			
		case kEmpty:
		default:
			NSLog(@"empty!");
			break;
	}

	//NSButton *b = sender;
	currentylSelectedBlocktype = [[sender selectedCell] tag];
	
	NSLog(@"setting cursor Image: %@",[[sender selectedCell] image]);
	[renderView setCursorImage: [[sender selectedCell] image]];


}

- (IBAction) addEntityToLevel: (id) sender atPosition: (NSPoint) gridPosition
{

	//check if field already occupied
	for (MapEntity *entity in entitiesInLevel)
	{
		if ([entity gridPosition].x == gridPosition.x &&
			[entity gridPosition].y == gridPosition.y)
		{
			[entitiesInLevel removeObject: entity];
			if (entity == playerEntity)
				playerEntity = nil;
			if (entity == finishEntity)
				finishEntity = nil;
			//[entity release];
			break;
		}
	}

	//if selection == empty ... lets exit and so erase the field
	if (currentylSelectedBlocktype == kEmpty)
		return;
	
	//player set already?
	//special entity managment
	if (playerEntity && currentylSelectedBlocktype == kPlayer)
	{
		[entitiesInLevel removeObject: playerEntity];
		playerEntity = nil;
	}

	//finish entity set already?
	//kill it
	if (finishEntity && currentylSelectedBlocktype == kFinish)
	{
		[entitiesInLevel removeObject: finishEntity];
		finishEntity = nil;
	}
	
	NSLog(@"adding Entity %i at %f,%f with Image %@ [%@]",currentylSelectedBlocktype,gridPosition.x,gridPosition.y,[sender cursorImage],[[sender cursorImage] name]);
	NSImage *entityImage = [sender cursorImage];
	MapEntity *ent = [[[MapEntity alloc] init] autorelease];
	[ent setImage: entityImage];
	[ent setImageName: [entityImage name]];
	[ent setGridPosition: gridPosition];
	[ent setType: currentylSelectedBlocktype];

	//save special entities
	if (currentylSelectedBlocktype == kPlayer)
		playerEntity = ent;
	if (currentylSelectedBlocktype == kFinish)
		finishEntity = ent;
	
	[entitiesInLevel addObject: ent];
	[renderView setEntitiesToDraw: entitiesInLevel];
	[renderView setNeedsDisplay: YES];
}

- (id)init
{
    self = [super init];
    if (self) {
    
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
	
	if (!entitiesInLevel)
	{
		entitiesInLevel = [NSMutableArray array];
		[entitiesInLevel retain];
		[self setMapGridWidth: 15];
		[self setMapGridHeight: 10];
	}
	
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
	NSLog(@"rolf! %@",[aController window]);
	//[[aController window] setAcceptsMouseMovedEvents: YES];
	currentylSelectedBlocktype = kEmpty;

	[renderView setEntitiesToDraw: entitiesInLevel];
	
/*	for (MapEntity *ent in entitiesInLevel)
	{
		NSLog(@"ent: %@",ent);
		NSLog(@"ent type: %i",[ent type]);
		//NSLog(@"ent img: %@",[ent image]);
		NSLog(@"ent pos: %f,%f",[ent gridPosition].x,[ent gridPosition].y);
	}*/
	
	[renderView setNeedsDisplay: YES];
	
	
}

- (NSMutableDictionary *) mapInfoDictionary
{
	NSMutableDictionary *mapInfo = [NSMutableDictionary dictionary];
	NSString *mapName = @"dummy";
	
	
	[mapInfo setObject:[NSNumber numberWithInt:mapGridWidth] forKey:@"MapGridWidth"];
	[mapInfo setObject:[NSNumber numberWithInt:mapGridHeight] forKey:@"MapGridHeight"];
	[mapInfo setObject:mapName forKey:@"MapName"];
	[mapInfo setObject:entitiesInLevel forKey:@"Entities"];
	[mapInfo retain];
	
	return mapInfo;
}


- (BOOL) exportMapToFile: (NSString *) filename
{
	NSLog(@"exporting to: %@",filename);

	NSDictionary *mapInfo = [self mapInfoDictionary];

	NSMutableArray *convEnts = [NSMutableArray array];
	

	for (MapEntity *ent in entitiesInLevel)
	{
		[convEnts addObject: [MapEntity entityToDictionary: ent]];
	}
	
//	NSSize mapSize = [[mapInfo objectForKey:@"MapSize"] sizeValue];
	NSMutableDictionary *e = [NSMutableDictionary dictionary];
	[e setObject:convEnts forKey:@"Entities"];
	int _mwidth = [[mapInfo objectForKey:@"MapGridWidth"] intValue];
	int _mheight = [[mapInfo objectForKey:@"MapGridHeight"] intValue];
	
	[e setObject:[NSNumber numberWithFloat: _mwidth] forKey:@"MapGridWidth"];
	[e setObject:[NSNumber numberWithFloat: _mheight] forKey:@"MapGridHeight"];	
	
	BOOL b = [e writeToFile:filename atomically:NO];
	NSLog(@"b: %i",b);
	
 
	
	return YES;
}

- (IBAction) exportMap: (id) sender
{
	[self exportMapToFile:@"/Users/jrk/map1.plist"];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If the given outError != NULL, ensure that you set *outError when returning nil.

    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    // For applications targeted for Panther or earlier systems, you should use the deprecated API -dataRepresentationOfType:. In this case you can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.

	//[entitiesInLevel writeToFile:@"/lol.lvl" atomically: YES];
	NSLog(@"written!");
	
//	NSData *ret = [entitiesInLevel 
	
	
/*	NSLog(@"playerEntity: %@",playerEntity);
	NSLog(@"finishEntity: %@",finishEntity);
	if (playerEntity)
		[mapInfo setObject:playerEntity forKey:@"PlayerEntity"];

	if (finishEntity)
		[mapInfo setObject:finishEntity forKey:@"FinishEntity"];
	*/
	
	NSData *ret = [NSArchiver archivedDataWithRootObject: [self mapInfoDictionary]];

	return ret;
	
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type.  If the given outError != NULL, ensure that you set *outError when returning NO.

    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead. 
    
    // For applications targeted for Panther or earlier systems, you should use the deprecated API -loadDataRepresentation:ofType. In this case you can also choose to override -readFromFile:ofType: or -loadFileWrapperRepresentation:ofType: instead.
  
	NSMutableDictionary *mapInfo = [NSUnarchiver unarchiveObjectWithData: data];
	//NSLog(@"%@",mapInfo);
	
	entitiesInLevel = [mapInfo objectForKey:@"Entities"];
	[entitiesInLevel retain];
	
	playerEntity = nil;
	finishEntity = nil;
	
	for (MapEntity *ent in entitiesInLevel)
	{
		if ([ent type] == kPlayer)
			playerEntity = ent;
		if ([ent type] == kFinish)
			finishEntity = ent;
	}
	
	[self setMapGridWidth: [[mapInfo objectForKey:@"MapGridWidth"] intValue]];
	[self setMapGridHeight: [[mapInfo objectForKey:@"MapGridHeight"] intValue]];
	
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
}

@end
