//
//  MyDocument.h
//  GinkoLevelEditor
//
//  Created by jrk on 28.03.09.
//  Copyright flux forge 2009 . All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "RenderView.h"
#import "MapEntity.h"

@interface MyDocument : NSDocument
{
	IBOutlet RenderView *renderView;
	
	NSMutableArray *entitiesInLevel;
	int currentylSelectedBlocktype;
	
	//special entity managment
	MapEntity *playerEntity;
	MapEntity *finishEntity;
	
	int mapGridWidth;
	int mapGridHeight;
}
@property (readwrite, assign) RenderView *renderView;
@property (readwrite, assign) NSMutableArray *entitiesInLevel;
@property (readwrite,assign) int mapGridWidth;
@property (readwrite,assign) int mapGridHeight;

- (IBAction) render: (id) sender;
- (IBAction) changeCurrentBlockType: (id) sender;

- (IBAction) addEntityToLevel: (id) sender atPosition: (NSPoint) gridPosition;
- (IBAction) exportMap: (id) sender;

@end
