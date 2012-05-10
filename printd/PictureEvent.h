//
//  PictureEvent.h
//  printd
//
//  Created by Stanislas POLU on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Event.h"

@interface PictureEvent : Event {
}
+(PictureEvent*)eventWithURL:(NSString*)url pic:(id)pic;


@property (nonatomic, readwrite, retain) NSString* url;
@property (nonatomic, readwrite, retain) id pic;
@end

