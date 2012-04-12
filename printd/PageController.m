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
    NSLog(@"PICTURE: %@", [evt url]);
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:evt.url]];

    [request setDelegate:self];
    [request startAsynchronous];

    [events_ setObject:evt forKey:[evt url]];    
}



- (void)requestFinished:(ASIHTTPRequest *)request
{
    PictureEvent *evt = [events_ objectForKey:[[request originalURL] absoluteString]];    
    [events_ removeObjectForKey:[[request originalURL] absoluteString]];
    
    NSLog(@"RECEIVED: %@", [evt url]);
    
    //NSImage* pic = [[[NSImage alloc] initWithData:[request responseData]] autorelease];
    //NSView* vw = [self buildPage:pic event:nil];    
    //[[[Factory sharedFactory] printController] printView:vw];
}


- (NSView*) buildPage:(NSImage *)pic event:(PictureEvent*)evt
{
    NSImage *cropped;

    if (pic.size.width * PRINT_IMAGE_HEIGHT > PRINT_IMAGE_WIDTH * pic.size.height) {
        cropped = [[[NSImage alloc] initWithSize:NSMakeSize(pic.size.height * PRINT_IMAGE_WIDTH / PRINT_IMAGE_HEIGHT,
                                                            pic.size.height)] autorelease];     
        [cropped lockFocus];
        CGRect from = CGRectMake((pic.size.width - pic.size.height * PRINT_IMAGE_WIDTH / PRINT_IMAGE_HEIGHT) / 2,
                                 0.0f,
                                 pic.size.height * PRINT_IMAGE_WIDTH / PRINT_IMAGE_HEIGHT, 
                                 pic.size.height);
        [pic drawInRect:NSMakeRect(0.0f, 0.0f, 
                                   pic.size.height * PRINT_IMAGE_WIDTH / PRINT_IMAGE_HEIGHT,
                                   pic.size.height)
               fromRect:from
              operation:NSCompositeCopy 
               fraction:1.0f];
        
        [cropped unlockFocus];
    }
    else {        
        cropped = [[[NSImage alloc] initWithSize:NSMakeSize(pic.size.width,
                                                            pic.size.width * PRINT_IMAGE_HEIGHT / PRINT_IMAGE_WIDTH)] autorelease];     
        [cropped lockFocus];
        CGRect from = CGRectMake(0.0f,
                                 (pic.size.height - pic.size.width * PRINT_IMAGE_HEIGHT / PRINT_IMAGE_WIDTH) / 2,                                              
                                 pic.size.width,
                                 pic.size.width * PRINT_IMAGE_HEIGHT / PRINT_IMAGE_WIDTH);
        [pic drawInRect:NSMakeRect(0.0f, 0.0f, 
                                   pic.size.width, 
                                   pic.size.width * PRINT_IMAGE_HEIGHT / PRINT_IMAGE_WIDTH)
               fromRect:from
              operation:NSCompositeCopy 
               fraction:1.0];
        
        [cropped unlockFocus];
    }
    
    [cropped setSize:NSMakeSize(PRINT_IMAGE_WIDTH, PRINT_IMAGE_HEIGHT)];    
    
    NSImage *final = [NSImage imageNamed:@"bg.png"];
    
    [final lockFocus];
    
    [cropped drawInRect:CGRectMake((PRINT_VIEW_WIDTH - PRINT_IMAGE_WIDTH) / 2.0, 
                                   PRINT_VIEW_HEIGHT - PRINT_IMAGE_HEIGHT - 100.0, 
                                   PRINT_IMAGE_WIDTH, PRINT_IMAGE_HEIGHT) 
               fromRect:CGRectMake(0.0f, 0.0f, PRINT_IMAGE_WIDTH, PRINT_IMAGE_HEIGHT) 
              operation:NSCompositeCopy
               fraction:1.0f];
    
    [final unlockFocus];
    
    NSImageView* view = [[NSImageView alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, PRINT_VIEW_WIDTH, PRINT_VIEW_HEIGHT)];
    [view setImage:final]; 
    
    NSTextField *handle = [[[NSTextField alloc] initWithFrame:NSMakeRect(100.0f, 100.0f, 1200.0f, 200.f)] autorelease];
    [handle setFont:[NSFont fontWithName:@"Helvetica Neue" size:78.0f]];
    [handle setEditable:NO];
    [handle setTextColor:[NSColor colorWithSRGBRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
    [handle setBackgroundColor:[NSColor colorWithSRGBRed:0.0f green:0.0f blue:0.0f alpha:0.0f]];
    [handle setStringValue:@"spolu"];
    [handle setBordered:NO];
    [handle setBezeled:NO];
    
    NSTextField *time = [[[NSTextField alloc] initWithFrame:NSMakeRect(100.0f, 400.0f, 1200.0f, 200.f)] autorelease];
    [time setFont:[NSFont fontWithName:@"Helvetica Neue" size:78.0f]];
    [time setEditable:NO];
    [time setTextColor:[NSColor colorWithSRGBRed:0.0f green:0.0f blue:0.0f alpha:1.0f]];
    [time setBackgroundColor:[NSColor colorWithSRGBRed:0.0f green:0.0f blue:0.0f alpha:0.0f]];
    [time setStringValue:@"NOW"];
    [time setBordered:NO];
    [time setBezeled:NO];
    
    [view addSubview:handle];
    [view addSubview:time];
    
    return [view autorelease];
}

@end


