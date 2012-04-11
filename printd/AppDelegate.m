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
#import "Factory.h"
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

    // [Factory sharedFactory] ...
}


@end