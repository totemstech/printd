//
//  EventBus.h
//  Bipsly
//
//  Created by Stanislas POLU on 2/2/11.
//  Copyright 2011 Bipsly. All rights reserved.
//

#import "Registration.h"
#import "Event.h"

#define EventBusFlushNotification @"EventBusFlushNotification"

@interface EventBus : NSObject {
    
    NSMutableDictionary         *registrations_;
    NSMutableSet                *pendingEvents_;
    
}

+ (EventBus*)defaultEventBus;

- (Registration*)addHandler:(id)handler eventType:(NSString*)eventType selector:(SEL)selector;
- (void)removeHandler:(Registration*)reg;

- (void)fireEvent:(Event*)event;
- (void)fireEventNow:(Event*)event;

@end
