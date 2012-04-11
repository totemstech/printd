//
//  PrintController.h
//  printd
//
//  Created by Stanislas POLU on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PrintController : NSObject {
    
}

- (void)printView:(NSView*)pview;


// Delegate Method

-(void)printOperationDidRun:(NSPrintOperation *)printOperation
                    success:(BOOL)success
                contextInfo:(void *)info;


@end
