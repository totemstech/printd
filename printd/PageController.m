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
#import "Factory.h"


@interface PageController ()

- (void) buildPage:(NSImage *)img;

@end

@implementation PageController

- (id)init 
{
    if ( self = [super init] )
    {
        events_ = [[NSMutableDictionary alloc] initWithCapacity:10];        
        [[EventBus defaultEventBus] addHandler:self 
                                     eventType:[PictureEvent type] 
                                      selector:@selector(onPicture:)];
    }
    return self;
    
}


- (void) dealloc 
{
    [events_ release];
    
    [super dealloc];
}


- (void)onPicture:(PictureEvent *)evt
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:evt.url]];
    
    [request setDelegate:self];
    [request startAsynchronous];

    [events_ setObject:evt forKey:request];    
}



- (void)requestFinished:(ASIHTTPRequest *)request
{
    PictureEvent *evt = [events_ objectForKey:request];    
    [events_ removeObjectForKey:request];
    
    NSImage* pic = [[[NSImage alloc] initWithData:[request responseData]] autorelease];
    [self buildPage:pic];
}


/*
 NSImage* img = [NSImage imageNamed:@"bg.png"];    
 NSImageView* view = [[NSImageView alloc] initWithFrame:NSMakeRect(0.0,0.0,PRINT_VIEW_WIDTH,PRINT_VIEW_HEIGHT)];
 [view setImage:img];    
 
 [[[Factory sharedFactory] printController] printView: view];
*/

- (void) buildPage:(NSImage *)pic
{
    /*
    NSView *picView = [[NSView alloc] initWithFrame:NSMakeRect(100.0, 100.0, 1000, 1000)];
    
    NSImage *final = [[NSImage alloc] initWithSize:NSMakeSize(PRINT_IMAGE_WIDTH, PRINT_IMAGE_HEIGHT)];
    
    
    
    NSImage *final = pic;
    if (pic.size.width * picView.frame.size.height > picView.frame.size.width * pic.size.height) {
        final = [pic imageAtRect:CGRectMake((pic.size.width - pic.size.height * picView.frame.size.width / picView.frame.size.height) / 2,
                                            0.0f,
                                            pic.size.height * picView.frame.size.width / picView.frame.size.height, 
                                            pic.size.height)];
    }
    else {
        final = [pic imageAtRect:CGRectMake(0.0f,
                                            (pic.size.height - pic.size.width * picView.frame.size.height / picView.frame.size.width) / 2,                                              
                                            pic.size.width,
                                            pic.size.width * picView.frame.size.height / picView.frame.size.width)];        
    }
*/
}

@end


