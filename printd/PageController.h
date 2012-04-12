//
//  PageController.h
//  printd
//
//  Created by Mohamed Ahmednah on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StreamController.h"


@interface PageController : NSObject {
    NSMutableDictionary    *events_;
}

- (void)onPicture:(PictureEvent*)evt;

- (NSView*) buildPage:(NSImage *)pic event:(PictureEvent*)evt;

@end
