//
//  ControllerCrossLayer.h
//  Ginko
//
//  Created by jrk on 25.03.09.
//  Copyright 2009 flux forge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ControllerCrossLayer : Layer 
{

}

- (void) highlightUpperCross: (BOOL) shouldHighlight;
- (void) highlightLowerCross: (BOOL) shouldHighlight;
- (void) highlightLeftCross: (BOOL) shouldHighlight;
- (void) highlightRightCross: (BOOL) shouldHighlight;

@end
