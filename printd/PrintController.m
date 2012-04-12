//
//  PrintController.m
//  printd
//
//  Created by Stanislas POLU on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PrintController.h"
#import "Factory.h"

@interface PrintController ()

- (NSPrintInfo*)printInfo;

@end


@implementation PrintController

- (id)init 
{        
    if(self = [super init]) {

    }    
    return self;
}

- (void)dealloc 
{        
    [super dealloc];
}

- (void)printOperationDidRun:(NSPrintOperation *)printOperation
                     success:(BOOL)success
                 contextInfo:(void *)info {
    if(success)
        NSLog(@"PRINT SUCCESSFUL");
    else
        NSLog(@"PRINT FAILED");    
}


-(void)printView:(NSView *)pview
{
    NSPrintOperation *op = [NSPrintOperation
                            printOperationWithView:pview
                            printInfo:[self printInfo]];

    [op setShowsPrintPanel:YES];
    
    [op runOperationModalForWindow:[(AppDelegate*)[[NSApplication sharedApplication] delegate] window]
                          delegate:self 
                    didRunSelector:@selector(printOperationDidRun:success:contextInfo:)
                       contextInfo:NULL];
}


-(NSPrintInfo*)printInfo
{
    NSPrintInfo *printInfo = [NSPrintInfo sharedPrintInfo];
    [printInfo setTopMargin:0.0];
    [printInfo setBottomMargin:0.0];
    [printInfo setLeftMargin:0.0];
    [printInfo setRightMargin:0.0];
    [printInfo setHorizontalPagination:NSFitPagination];
    [printInfo setVerticalPagination:NSFitPagination];
    [printInfo setHorizontallyCentered:YES];
    [printInfo setVerticallyCentered:YES];
    [printInfo setPaperName:@"Postcard(4x6in)"];
        
    return printInfo;
}


@end

