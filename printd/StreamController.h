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
    NSMutableString *buffer; 
}

- (void) start;

@end


// Events

@interface PictureEvent : Event {
}
+(PictureEvent*)eventWithURL:(NSString*)url;
+(PictureEvent*)eventWithURL:(NSString *)url handle:(NSString*)handle;

@property (nonatomic, readwrite, retain) NSString* url;
@property (nonatomic, readwrite, retain) NSString* handle;
@end

