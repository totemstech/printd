//
//  NSPrinter+PaperSize.h
//  printd
//
//  Created by Stanislas POLU on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <Cocoa/Cocoa.h>

#define PAPER_NAME               @"paper_name"
#define LOCALISED_PAPER_NAME     @"localised_paper_name"
#define LOCALIZED_PAPER_NAME     @"localised_paper_name"
#define PAPER_SIZE               @"paper_size"
#define PAPER_IMAGEABLE_MARGINS  @"printable_margins"

@interface NSPrinter (PaperSize)

// returns an NSArray of NSDictionaries: see constants above.
+ (NSArray *)paperSizesAndNamesForPrinter: (NSString *)printerName;
+ (NSArray *)extractInfoFromPrinter: (PMPrinter)printerInfo;

@end
