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

    [op setShowsPrintPanel:YES];
    
    BOOL success = [op runOperation];
    //BOOL success = YES;
    
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
    [printInfo setHorizontallyCentered:YES];
    [printInfo setVerticallyCentered:YES];
    [printInfo setPaperName:@"Postcard(4x6in)"];
    
    
    //NSPrinter *printer = [[NSPrinter printerNames] objectAtIndex:0];
    //NSLog(@"%@", [NSPrinter paperSizesAndNamesForPrinter:[[NSPrinter printerNames] objectAtIndex:0]]);
    
    return printInfo;
}


@end

