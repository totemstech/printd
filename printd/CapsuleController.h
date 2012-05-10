//
//  CapsuleController.h
//  printd
//
//  Created by Stanislas POLU on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureEvent.h"

@interface CapsuleController : NSObject 
{    
    NSString         *capsuleId_;
    NSMutableSet     *knownShas_;
    NSTimer          *updateTimer_;
    
    BOOL              firstUpdate_;
    BOOL              fromStart_;
}


- (void)trackCapsuleWithId:(NSString*)capsuleId fromStart:(BOOL)fromStart;
- (void)stop;


@end
