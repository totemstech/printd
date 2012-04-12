//
//  StreamController.h
//  printd
//
//  Created by Mohamed Ahmednah on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"



@interface StreamController : NSObject
{
    NSMutableDictionary * streams_;
}

- (void) addStream:(NSDictionary*)query withName:(NSString*)name;
- (void) stopStream:(NSString*)name;

@end


// Events

@interface PictureEvent : Event {
}
+(PictureEvent*)eventWithURL:(NSString*)url pic:(id)pic from:(NSString*)stream;


@property (nonatomic, readwrite, retain) NSString* url;
@property (nonatomic, readwrite, retain) NSString* stream;
@property (nonatomic, readwrite, retain) id pic;
@end

