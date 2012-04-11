//
//  StreamController.h
//  printd
//
//  Created by Mohamed Ahmednah on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Event.h"
#import "EventBus.h"


@interface StreamEvent : Event {
  
}
@property (nonatomic, retain) NSDictionary* data;
+ (Event*)eventWithDic:(NSDictionary*) dic;


@end

@interface StreamController : NSObject
{
    NSMutableString *buffer; 
}

- (void) start;

@end

