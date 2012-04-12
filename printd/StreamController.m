//
//  StreamController.m
//  printd
//
//  Created by Mohamed Ahmednah on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StreamController.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "Factory.h"
#import "EventBus.h"

@implementation StreamController

- (id)init
{
    if ( self = [super init] )
    {
        buffer = [[NSMutableString alloc] init];
    }
    return self;
}


- (void) dealloc
{
    [buffer release];
    [super dealloc];
}


- (void) start {
    NSMutableString *urlstring = [NSMutableString stringWithString:@"http://api.core.teleportd.com/stream?accesskey=53d9a10e2a7db6b7957be8cbbec599d57541e853a94d98fae6e7e7aca06d424cb49b1b200e9b80b032a549dd03d653735a238982d0dead1f509521f07dea7b30&track=[%22lajeuneur%22]"];
    
    NSURL * url = [NSURL URLWithString:urlstring];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setTimeOutSeconds:0];
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"stream1" forKey:@"name"]];
    [request setDelegate:self];
    [request startAsynchronous];

}


/*
 * Method for dealing with the teleportd api stream 
 * parsing it
 */
- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data {
    
    if ([[request.userInfo objectForKey:@"name"] isEqualToString:@"stream1"] && data) {        
        [buffer appendString:[[NSString alloc] initWithData:data encoding:[request responseEncoding]]]; 
        
        while (buffer && [buffer rangeOfString:@"\r\n"].location != NSNotFound) {
            
            NSArray *chunks = [buffer componentsSeparatedByString:@"\r\n"];
            
            if([chunks count] > 1) {
                for (int i=0; i < [chunks count] - 1; i ++) {
                    id json = [[chunks objectAtIndex:i] objectFromJSONString];
                    [[EventBus defaultEventBus] fireEvent:[PictureEvent eventWithURL:[json objectForKey:@"fll"]
                                                                              handle:[[json objectForKey:@"usr"] objectAtIndex:0]]];                
                }
                [buffer setString:[chunks lastObject]];
            }
        }
        
    }
    
}



@end



/*****************************
 * PictureEvent              *
 *****************************/

static NSString *kPictureEventType = @"PictureEvent";

@implementation PictureEvent

@synthesize url = url_;
@synthesize handle = handle_;

+ (NSString*)type 
{    
    return kPictureEventType;
}

-(id)initWithURL:(NSString*)url
{
    if((self = [super init])) {
        self.url = url;
    }
    return self;
}

-(id)initWithURL:(NSString*)url handle:(NSString*)handle 
{
    if((self = [super init])) {
        self.url = url;
        self.handle = handle;
    }
    return self;
}

+(PictureEvent*)eventWithURL:(NSString *)url handle:(NSString*)handle
{
    return [[[PictureEvent alloc] initWithURL:url handle:handle] autorelease];
}

+(PictureEvent*)eventWithURL:(NSString *)url
{
    return [[[PictureEvent alloc] initWithURL:url] autorelease];
}

@end

