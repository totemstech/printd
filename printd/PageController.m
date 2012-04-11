//
//  PageController.m
//  printd
//
//  Created by Mohamed Ahmednah on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PageController.h"
#import "StreamController.h"
#import "ASIHTTPRequest.h"

@implementation PageController

- (id)init {
    if ( self = [super init] )
    {
        [[EventBus defaultEventBus] addHandler:self 
                                     eventType:[StreamEvent type] 
                                      selector:@selector(onStream:)];
    }
    return self;
    
}


- (void)onStream:(StreamEvent*)evt
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[[evt data] objectForKey:@"fll"]];
    
    [request setDelegate:self];
    [request startAsynchronous];
    NSLog(@"%@",[evt data]);
}



- (void)requestFinished:(ASIHTTPRequest *)request
{
 
}

@end
