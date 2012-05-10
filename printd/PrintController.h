//
//  PrintController.h
//  printd
//
//  Created by Stanislas POLU on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PictureEvent.h"

@interface PrintController : NSObject {
}

- (void)printView:(NSView*)pview forEvt:(PictureEvent*)evt;



@end
