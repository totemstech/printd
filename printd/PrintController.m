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
    self = [super init];
    
    if (self != nil) {
    }
    
    return self;
}

- (void)dealloc 
{        
    [super dealloc];
}

-(void)printView:(NSView *)pview
{
    NSPrintOperation *op = [NSPrintOperation
                            printOperationWithView:pview
                            printInfo:[self printInfo]];

    [op runOperationModalForWindow:[[[Factory sharedFactory] printdAppDelegate] window]
                          delegate:self
                    didRunSelector:@selector(printOperationDidRun:success:contextInfo:)
                       contextInfo:NULL];    
    
}


-(void)printOperationDidRun:(NSPrintOperation *)printOperation
                    success:(BOOL)success
                contextInfo:(void *)info
{
    if(success)
        NSLog(@"PRINT SUCCESSFUL");
    else
        NSLog(@"PRINT FAILED");
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
    
    return printInfo;
}


@end

