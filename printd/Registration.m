//
//  Registration.m
//  Bipsly
//
//  Created by Stanislas POLU on 2/2/11.
//  Copyright 2011 Bipsly. All rights reserved.
//

#import "Registration.h"

@implementation Registration

@synthesize handler_;
@synthesize selector_;
@synthesize eventType_;

- (id)initWithHandler:(id)handler eventType:(NSString*)eventType selector:(SEL)selector {
    
    self = [super init];
    
    if (self != nil) {        
        handler_ = handler;
        selector_ = selector;
        eventType_ = [eventType retain];
    }
    
    return self;
}

- (void)dealloc {
    
    [eventType_ release];
    
    [super dealloc];
}

- (void)callback:(Event*)event {
    
    //NSLog(@"Callback: %@", [[event class] type]);
    if([[[event class] type] isEqualToString:eventType_]) {
        if([handler_ respondsToSelector: selector_]) {
            [handler_ performSelector:selector_ withObject:event];
        }
        else {
            NSLog(@"FAILED Callback: Handler does not respond to specified selector: %@", NSStringFromSelector(selector_));            
        }
    }
    else {
        NSLog(@"FAILED Callback: Mismatch eventType: %@ - %@", [[event class] type], eventType_);        
    }
}

@end
