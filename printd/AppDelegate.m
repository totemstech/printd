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


#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"


@implementation AppDelegate

@synthesize window = _window;


- (id)initWithCoder:(NSCoder *)inCoder
{
    if ( self = [super init] )
    {
       dataMutableString = [[NSMutableString alloc] init];
    }
    return self;
}

- (void) dealloc
{
    [dataMutableString release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}


- (void) fetch {
    NSMutableString *urlstring = [NSMutableString stringWithString:@"http://teleportd-ios.nodejitsu.com/geo"];
    
    
    NSURL * url = [NSURL URLWithString:urlstring];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"TLAPIReq" forKey:@"TLAPIReq"]];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

- (void)printImage:(NSURL *)fileURL {
    
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

/*
 * Method for dealing with the teleportd api stream 
 * parsing it
 */
- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data {
    
    if ([[request.userInfo objectForKey:@"TLAPIReq"] isEqualToString:@"TLAPIReq"]) {
        
    [dataMutableString appendString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
	
    while (dataMutableString && [dataMutableString rangeOfString:@"\r\n"].location != NSNotFound) {
    	NSRange range = [dataMutableString rangeOfString:@"\r\n"];
        NSString *jsonString = [dataMutableString substringWithRange:range];
        //TODO send the json to the appropriate method to proceed 
        //downloading images
        [dataMutableString deleteCharactersInRange:range];
    }
    }

}

- (void) downloadImage {
    NSMutableString *urlstring = [NSMutableString stringWithString:@"http://teleportd-ios.nodejitsu.com/geo"];
    
    
    NSURL * url = [NSURL URLWithString:urlstring];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"TLAPIReq" forKey:@"TLAPIReq"]];
    [request setDelegate:self];
    [request startAsynchronous];

}



- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    if ([[request.userInfo objectForKey:@"TLAPIReq"] isEqualToString:@"TLAPIReq"]) {
  
    }
    
    
}

@end