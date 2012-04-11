//
//  Event.m
//  Bipsly
//
//  Created by Stanislas POLU on 2/2/11.
//  Copyright 2011 Bipsly. All rights reserved.
//

#import "Event.h"
#import "EventBus.h"

static NSString *kEventType = @"Event";

@implementation Event

+ (Event*)event
{
    NSLog(@"EMPTY EVENT: you must override Event class constructor");
    return nil;
}

+ (NSString*)type 
{    
    return kEventType;
}

- (void)fire
{
    [[EventBus defaultEventBus] fireEvent:self];
}

- (void)fireNow
{
    [[EventBus defaultEventBus] fireEventNow:self];
}


- (void)dealloc 
{    
    [super dealloc];
}

@end


static NSString *kMemoryWarningEventType = @"MemoryWarningaEvent";

@implementation MemoryWarningEvent

+ (NSString*)type 
{    
    return kMemoryWarningEventType;
}

+ (Event*)event
{
    return [[[MemoryWarningEvent alloc] init] autorelease];
}

@end

