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
        done_ = [[NSMutableSet alloc] initWithCapacity:10];
        
        [[EventBus defaultEventBus] addHandler:self 
                                     eventType:[PictureEvent type] 
                                      selector:@selector(onPicture:)];
        count_ = 0;
    }
    return self;
    
}


- (void) dealloc 
{
    [events_ release];
    [done_ release];
    
    [super dealloc];
}


- (void)onPicture:(PictureEvent *)evt
{
    @synchronized(events_) {   
        if(![done_ containsObject:[evt url]]) {
            NSLog(@"PICTURE: %@ %@", [evt url], [evt stream]);

            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:evt.url]];            
            [request setDelegate:self];
            [request startAsynchronous];
            
            [events_ setObject:evt forKey:[evt url]];                
            [done_ addObject:[evt url]];
        }
    }
}



- (void)requestFinished:(ASIHTTPRequest *)request
{
    @synchronized(events_) {

        PictureEvent *evt = [events_ objectForKey:[[request originalURL] absoluteString]];  
        if(evt) {    
            NSLog(@"RECEIVED: %@", [evt url]);
            
            ++count_;
            
            NSImage* pic = [[[NSImage alloc] initWithData:[request responseData]] autorelease];
            NSView* vw = [self buildPage:pic event:evt];    
            [[[Factory sharedFactory] printController] printView:vw];
            
            NSLog(@"PIC: %@", [evt pic]);
            
            // tweet
            if([[evt pic] objectForKey:@"usr"] && [[[evt pic] objectForKey:@"usr"] count] > 0) {            
                NSString *tweet = 
                [NSString stringWithFormat:@"@%@ Wow! That's Cool: your photo is being #printd right now... follow the white LEDs. #lajeuneur #%d", 
                 [[[evt pic] objectForKey:@"usr"] objectAtIndex:0],
                 count_, nil];
                
                [[[Factory sharedFactory] twitterController] updateStatus:tweet];
            }
            
            [events_ removeObjectForKey:[[request originalURL] absoluteString]];        
        }
    }
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
    
    NSFont *font = [NSFont fontWithName:@"Helvetica Neue" size:40.0f];
    NSColor *color = [NSColor colorWithDeviceRed:0.47f green:0.47f blue:0.47f alpha:0.8f];
    
    NSImageView* view = [[NSImageView alloc] initWithFrame:NSMakeRect(0.0f, 0.0f, PRINT_VIEW_WIDTH, PRINT_VIEW_HEIGHT)];
    [view setImage:final]; 
    
    if([[evt pic] objectForKey:@"usr"] && [[[evt pic] objectForKey:@"usr"] count] > 0) {
        NSTextField *handle = [[[NSTextField alloc] initWithFrame:NSMakeRect(200.0f, 270.0f, 1000.0f, 150.f)] autorelease];
        [handle setFont:font];
        [handle setTextColor:color];
        [handle setEditable:NO];
        //[handle setBackgroundColor:[NSColor colorWithSRGBRed:0.0f green:0.0f blue:0.0f alpha:0.0f]];
        [handle setStringValue:[NSString stringWithFormat:@"@%@", [[[evt pic] objectForKey:@"usr"] objectAtIndex:0]]];
        //[handle setStringValue:@"spolu"];
        [handle setBordered:NO];
        [handle setBezeled:NO];

        [view addSubview:handle];
    }
    
    NSString *dateStr = [[NSDate  date]
                         descriptionWithCalendarFormat:@"%d.%m.%Y %H:%M:%S" timeZone:nil
                         locale:[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];

    NSTextField *time = [[[NSTextField alloc] initWithFrame:NSMakeRect(200.0f, 180.0f, 1000.0f, 150.f)] autorelease];
    [time setFont:font];
    [time setTextColor:color];
    [time setEditable:NO];
    //[time setBackgroundColor:[NSColor colorWithSRGBRed:0.0f green:0.0f blue:0.0f alpha:0.0f]];
    [time setStringValue:[NSString stringWithFormat:@"%@ CEST", dateStr, nil]];
    [time setBordered:NO];
    [time setBezeled:NO];
    
    [view addSubview:time];
    
    
    NSTextField *loc = [[[NSTextField alloc] initWithFrame:NSMakeRect(200.0f, 95.0f, 1000.0f, 150.0f)] autorelease];
    [loc setFont:font];
    [loc setTextColor:color];
    [loc setEditable:NO];
    //[loc setBackgroundColor:[NSColor colorWithSRGBRed:0.0f green:0.0f blue:0.0f alpha:0.0f]];
    [loc setStringValue:@"48.869 N 2.345 E"];
    [loc setBordered:NO];
    [loc setBezeled:NO];
    
    [view addSubview:loc];
    
    return [view autorelease];
}

@end


