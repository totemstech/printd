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
#import "EventBus.h"

@implementation PageController


- (id)init {
    if ( self = [super init] )
    {
        [[EventBus defaultEventBus] addHandler:self 
                                     eventType:[PictureEvent type] 
                                      selector:@selector(onPicture:)];
    }
    return self;
    
}


- (void)onPicture:(PictureEvent *)evt
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:evt.url]];
    
    [request setDelegate:self];
    [request startAsynchronous];
    
    NSLog(@"%@ %@ %@", evt.url, evt.handle, evt.comments); 
  
}



- (void)requestFinished:(ASIHTTPRequest *)request
{
     NSData *responseData = [request responseData];
 //   NSImage* img = [NSImage ] 

}


/*
 NSImage* img = [NSImage imageNamed:@"bg.png"];    
 NSImageView* view = [[NSImageView alloc] initWithFrame:NSMakeRect(0.0,0.0,PRINT_VIEW_WIDTH,PRINT_VIEW_HEIGHT)];
 [view setImage:img];    
 
 [[[Factory sharedFactory] printController] printView: view];
*/


@end


