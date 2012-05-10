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
        [[Factory sharedFactory] log:@"PRINT: successful"];
    else
        [[Factory sharedFactory] log:@"ERROR: print failed"];
}


-(void)printView:(NSView *)pview forEvt:(PictureEvent *)evt
{
    NSPrintOperation *op = [NSPrintOperation
                            printOperationWithView:pview
                            printInfo:[self printInfo]];

    [op setShowsPrintPanel:NO];
    
    [op runOperationModalForWindow:[(AppDelegate*)[[NSApplication sharedApplication] delegate] window]
                          delegate:self 
                    didRunSelector:@selector(printOperationDidRun:success:contextInfo:)
                       contextInfo:NULL];
    
    [[Factory sharedFactory] log:[NSString stringWithFormat:@"PRINTING [%@]", 
                                  [[evt pic] objectForKey:@"sha"] ,nil]];
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
    [printInfo setPaperName:PRINT_PAPER_NAME];
        
    return printInfo;
}


@end

