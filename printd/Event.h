//
//  Event.h
//  Bipsly
//
//  Created by Stanislas POLU on 2/2/11.
//  Copyright 2011 Bipsly. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Event : NSObject {

}

+ (Event*)event;
+ (NSString*)type;

- (void)fire;
- (void)fireNow;

@end


@interface MemoryWarningEvent : Event {
}
@end
