//
//  Registration.h
//  Bipsly
//
//  Created by Stanislas POLU on 2/2/11.
//  Copyright 2011 Bipsly. All rights reserved.
//


#import "Event.h"

@interface Registration : NSObject {

    id            handler_;
    NSString     *eventType_;
    SEL           selector_;    
    
}

- (id)initWithHandler:(id)handler eventType:(NSString*)eventType selector:(SEL)selector;

- (void)callback:(Event*)event;

@property (readonly, getter=handler)   id         handler_;
@property (readonly, getter=selector)  SEL        selector_;
@property (readonly, getter=eventType) NSString  *eventType_;

@end
