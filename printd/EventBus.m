//
//  EventBus.m
//  Bipsly
//
//  Created by Stanislas POLU on 2/2/11.
//  Copyright 2011 Bipsly. All rights reserved.
//

#import "EventBus.h"

static EventBus* kDefaultEventBus = nil;

@implementation EventBus

+ (EventBus*)defaultEventBus
{
    if(kDefaultEventBus == nil) {
        kDefaultEventBus = [[EventBus alloc] init];
    }
    return kDefaultEventBus;
}

- (id)init 
{    
    self = [super init];
    
    if (self != nil) {
        registrations_ = [[NSMutableDictionary alloc] init];
        pendingEvents_ = [[NSMutableSet alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flush) name:EventBusFlushNotification object:nil];
    }
    
    return self;
}

- (void)dealloc 
{    
    [registrations_ release];
    [pendingEvents_ release];
    
    [super dealloc];
}


- (void)flush 
{
    NSSet *events;
    @synchronized(self) {
        events = [NSSet setWithSet:pendingEvents_];
        [pendingEvents_ removeAllObjects];        
        
        for(Event *evt in events) {
#ifdef DEBUG
            NSLog(@">>>> %@ <<", [[evt class] type]);
#endif
            NSArray *regs = (NSArray*)[registrations_ objectForKey:[[evt class] type]];
            if(regs != nil) {
                for(Registration *reg in regs) {
                    [reg callback:evt];
                }
            }        
        }
    }
}

- (Registration*)addHandler:(id)handler eventType:(NSString*)eventType selector:(SEL)selector 
{
    Registration *reg = [[[Registration alloc] initWithHandler:handler eventType:eventType selector:selector] autorelease];

    @synchronized(self) {
        if([registrations_ objectForKey:eventType] == nil) {
            [registrations_ setObject:[[[NSMutableArray alloc] init] autorelease] forKey:eventType];
        }
        
        [(NSMutableArray*)[registrations_ objectForKey:eventType] addObject:reg];
    }
    return reg;
}

- (void)removeHandler:(Registration*)reg
{
    @synchronized(self) {
        if([registrations_ objectForKey:[reg eventType]] == nil)
            return;

        [(NSMutableArray*)[registrations_ objectForKey:[reg eventType]] removeObject:reg];
    }
}

- (void)fireEvent:(Event*)event 
{
    @synchronized(self) {
        //NSLog(@"Stacking event: %@", [[event class] type]);
        [pendingEvents_ addObject:event];        
    }
    
    [self performSelectorOnMainThread:@selector(postFlush) withObject:nil waitUntilDone:NO];
}

- (void)fireEventNow:(Event*)event
{
#ifdef DEBUG
    NSLog(@">>>> %@ << NOW", [[event class] type]);
#endif
    NSArray *regs = (NSArray*)[registrations_ objectForKey:[[event class] type]];
    if(regs != nil) {
        for(Registration *reg in regs) {
            [reg callback:event];
        }
    }        
}

- (void)postFlush 
{
    [[NSNotificationQueue defaultQueue] enqueueNotification:[NSNotification notificationWithName:EventBusFlushNotification 
                                                                                          object:self ] 
                                               postingStyle:NSPostWhenIdle];
}

@end
