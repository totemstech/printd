//
//  NSPrinter+PaperSize.m
//  printd
//
//  Created by Stanislas POLU on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSPrinter+PaperSize.h"

@implementation NSPrinter (PaperSize)

+ (NSArray *)paperSizesAndNamesForPrinter: (NSString *)printerName
{
    PMPrintSession printSession = NULL;
    CFArrayRef printerList = NULL;
    PMPrinter thisPrinter = NULL;
    int numPrinters;
    OSStatus err;
    int i;
    
    err = PMCreateSession(&printSession);
    if (err != noErr)
        [NSException raise:@"Error PrinterPaperList" format:@"Error %d", err];
    
    @try
    {
        /**
         * Get a list of all printers.
         */
        err = PMServerCreatePrinterList(kPMServerLocal, &printerList);
        if (err != noErr)
            [NSException raise:@"Error PrinterPaperList" format:@"Error %d", err];
        
        /**
         * Now, loop through them until we find the printer we're looking
         * for.  Then we can get the properties.  We throw if the printer
         * isn't found.
         */
        numPrinters = CFArrayGetCount(printerList);
        for (i = 0; i < numPrinters; i++)
        {
            CFStringRef thisPrinterName;
            thisPrinter = (PMPrinter)CFArrayGetValueAtIndex(printerList, i);
            
            thisPrinterName = PMPrinterGetName(thisPrinter);
            if ([(NSString *)thisPrinterName caseInsensitiveCompare: printerName] == NSOrderedSame)
            {
                CFRelease(thisPrinterName);
                return [NSPrinter extractInfoFromPrinter: thisPrinter];
            }
            
            CFRelease(thisPrinterName);
            thisPrinter = NULL;
        }
    }
    @finally
    {
        /**
         * Clean up.  Exceptions will still throw back up the stack.
         */
        if (printerList != NULL) CFRelease(printerList);
        PMRelease(printSession);
    }
    
    return nil;
}

+ (NSArray *)extractInfoFromPrinter: (PMPrinter)printerInfo
{
    NSMutableArray *outputArray = [NSMutableArray arrayWithCapacity: 10];
    CFStringRef paperName = NULL, localised = NULL;
    NSMutableDictionary *paperProps;
    CFArrayRef paperList;
    PMPaper thisPaper;
    int j, numPapers;
    OSStatus err;
    
    /**
     * First, get a list of the paper sizes and create an NSArray 
     * for them all.
     */
    err = PMPrinterGetPaperList(printerInfo, &paperList);
    if (err != noErr)
        [NSException raise:@"Error PrinterPaperList" format:@"Error %d", err];
    
    @try
    {
        numPapers = CFArrayGetCount(paperList);
        for (j = 0; j < numPapers; j++)
        {
            NSValue *imageableMargins, *paperSize;
            double paperHeight, paperWidth;
            NSRect adjustedMargins;
            PMPaperMargins margie;
            
            thisPaper =  (PMPaper)CFArrayGetValueAtIndex(paperList, j);
            
            /**
             * Get the system non-localised paper name.
             */
            PMPaperGetID(thisPaper, &paperName);
            
            
            /**
             * Get the localised paper name.
             */
            err = PMPaperGetName(thisPaper, &localised);
            if (err != noErr)
                [NSException raise:@"Error PrinterPaperList" format:@"Error %d", err];
            
            /**
             * Finally, build up the size.
             */
            err = PMPaperGetHeight(thisPaper, &paperHeight);
            if (err != noErr)
                [NSException raise:@"Error PrinterPaperList" format:@"Error %d", err];
            
            err = PMPaperGetWidth(thisPaper, &paperWidth);
            if (err != noErr)
                [NSException raise:@"Error PrinterPaperList" format:@"Error %d", err];
            
            paperSize = [NSValue valueWithSize: NSMakeSize(paperWidth, paperHeight)];
            
            /**
             * This gets the imageable margins for the page type, which
             * is very useful.
             */
            PMPaperGetMargins(thisPaper, &margie);
            adjustedMargins = NSMakeRect(margie.left, margie.top,
                                         (paperWidth - margie.left - margie.right),
                                         (paperHeight - margie.top - margie.bottom));
            imageableMargins = [NSValue valueWithRect: adjustedMargins];
            
            /**
             * Finally, create a dictionary with these values and then add
             * them to da array.
             */
            paperProps = [NSMutableDictionary dictionaryWithCapacity: 3];
            [paperProps setValue: [NSString stringWithString: (NSString *)paperName]
                          forKey: PAPER_NAME];
            [paperProps setValue: [NSString stringWithString: (NSString *)localised]
                          forKey: LOCALISED_PAPER_NAME];
            [paperProps setValue: paperSize forKey: PAPER_SIZE];
            [paperProps setValue: imageableMargins forKey: PAPER_IMAGEABLE_MARGINS];
            
            [outputArray addObject: paperProps];
            
            CFRelease(paperName);
            CFRelease(localised);
            paperName = NULL;
            localised = NULL;
        }
    }
    @finally
    {
        if (paperName) CFRelease(paperName);
        if (localised) CFRelease(localised);
    }
    
    return outputArray;
}

@end
