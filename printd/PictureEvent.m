//
//  PictureEvent.m
//  printd
//
//  Created by Stanislas POLU on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PictureEvent.h"

/*****************************
 * PictureEvent              *
 *****************************/

static NSString *kPictureEventType = @"PictureEvent";

@implementation PictureEvent

@synthesize url = url_;
@synthesize pic = pic_;

+ (NSString*)type 
{    
    return kPictureEventType;
}

-(id)initWithURL:(NSString*)url pic:(id)pic
{
    if((self = [super init])) {
        self.url = url;
        self.pic = pic;
    }
    return self;
}

+(PictureEvent*)eventWithURL:(NSString*)url pic:(id)pic
{
    return [[[PictureEvent alloc] initWithURL:url pic:pic] autorelease];
}

@end

