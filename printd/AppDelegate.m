//
//  AppDelegate.m
//  printd
//
//  Created by Mohamed Ahmednah on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//
//  AppDelegate.m
//  printd
//
//  Created by Mohamed Ahmednah on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import <Quartz/Quartz.h>


//#import "ASIFormDataRequest.h"
//#import "ASIHTTPRequest.h"


@implementation AppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}


- (void) fetch {
//NSMutableString *urlstring = [NSMutableString stringWithString:@"http://teleportd-ios.nodejitsu.com/geo"];
    
    
  /*  NSURL * url = [NSURL URLWithString:urlstring];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    //[request addPostValue:lat forKey:@"lat"];
    
    
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"loc" forKey:@"locationupdate"]];
    [request setDelegate:self];
    [request startAsynchronous];*/
    
}

- (void)printPDF:(NSURL *)fileURL {
    
    // Create the print settings.
    NSPrintInfo *printInfo = [NSPrintInfo sharedPrintInfo];
    [printInfo setTopMargin:0.0];
    [printInfo setBottomMargin:0.0];
    [printInfo setLeftMargin:0.0];
    [printInfo setRightMargin:0.0];
    [printInfo setHorizontalPagination:NSFitPagination];
    [printInfo setVerticalPagination:NSFitPagination];
    
    // Create the document reference.
    PDFDocument *pdfDocument = [[PDFDocument alloc] initWithURL:fileURL];
    
    // Invoke private method.
    // NOTE: Use NSInvocation because one argument is a BOOL type. Alternately, you could declare the method in a category and just call it.
    BOOL autoRotate = YES;
    NSMethodSignature *signature = [PDFDocument instanceMethodSignatureForSelector:@selector(getPrintOperationForPrintInfo:autoRotate:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:@selector(getPrintOperationForPrintInfo:autoRotate:)];
    [invocation setArgument:&printInfo atIndex:2];
    [invocation setArgument:&autoRotate atIndex:3];
    [invocation invokeWithTarget:pdfDocument];
    
    // Grab the returned print operation.
    NSPrintOperation *op = nil;
    [invocation getReturnValue:&op];
    
    // Run the print operation without showing any dialogs.
    [op setShowsPrintPanel:NO];
    [op setShowsProgressPanel:NO];
    [op runOperation];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    if ([[request.userInfo objectForKey:@"locationupdate"] isEqualToString:@"loc"]) {
        // Use when fetching text data
        //  NSString *responseString = [request responseString];
        //NSArray  *body = [[request responseString] 	object	]; 
        //[body enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        
        
        //  }];
        
    }
    
    
}

@end