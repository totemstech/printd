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

//interface for private methods
@interface StreamController ()
-(void) startStream:(NSString *)name url:(NSURL*)url;
@end

@implementation StreamController

- (id)init
{
    if ( self = [super init] )
    {
        streams = [[NSMutableDictionary alloc] init];
    }
    return self;
}


- (void) dealloc
{
    [streams release];
    [super dealloc];
}


- (void) addStream:(NSDictionary*)query withName:(NSString*)name {
  
    // url constrution
    NSMutableString *urlString = [NSMutableString stringWithString:@"http://api.core.teleportd.com/stream?accesskey=53d9a10e2a7db6b7957be8cbbec599d57541e853a94d98fae6e7e7aca06d424cb49b1b200e9b80b032a549dd03d653735a238982d0dead1f509521f07dea7b30"];
  
    if([query objectForKey:@"track"]) {
        NSArray *track = [query objectForKey:@"track"];
        [urlString appendString:@"&track=["];
        for(int i = 0; i < [track count]; i++) {
            [urlString appendFormat:@"%@%@%@", @"%22", [track objectAtIndex:i], @"%22", nil];            
            if(i < [track count] - 1)
                [urlString appendString:@","];
        }
        [urlString appendString:@"]"];
    }
    
    if([query objectForKey:@"loc"]) {
        NSArray *loc = [query objectForKey:@"loc"];
        [urlString appendString:@"&loc=["];
        for(int i = 0; i < [loc count]; i++) {
            [urlString appendFormat:@"%@",[loc objectAtIndex:i], nil];            
            if(i < [loc count] - 1)
                [urlString appendString:@","];
        }
        [urlString appendString:@"]"];
    }


    NSLog(@"%@", urlString);
    //request construction
    NSURL * url = [NSURL URLWithString:urlString];
    
 /*   ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:0];
    [request setDelegate:self];
    [request setUserInfo:[NSDictionary dictionaryWithObject:name forKey:@"name"]];
   
    NSMutableDictionary* details =  [[NSMutableDictionary alloc] init];
    [details setObject:request forKey:@"request"];
    [details setObject:[[[NSMutableString alloc] init] autorelease] forKey:@"buffer"];
    [streams setObject:details forKey:name];*/
    
    [self startStream:name url:url];
  
}
- (void) stopStream:(NSString*)name {
    
    [[[streams objectForKey:name] objectForKey:@"request"] clearDelegatesAndCancel];
}


- (void) startStream:(NSString*)name url:(NSURL*)url {
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:0];
    [request setDelegate:self];
    [request setUserInfo:[NSDictionary dictionaryWithObject:name forKey:@"name"]];
    
    NSMutableDictionary* details =  [[NSMutableDictionary alloc] init];
    [details setObject:request forKey:@"request"];
    [details setObject:[[[NSMutableString alloc] init] autorelease] forKey:@"buffer"];
    [streams setObject:details forKey:name];
    
    [request startAsynchronous];
    
}


/*
 * Method for dealing with the teleportd api stream 
 * parsing it
 */
- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data {
    
    NSMutableString * buffer = [[streams objectForKey:[request.userInfo objectForKey:@"name"]] objectForKey:@"buffer"];
    
    if (data) {        
        [buffer appendString:[[NSString alloc] initWithData:data encoding:[request responseEncoding]]]; 
        
        while (buffer && [buffer rangeOfString:@"\r\n"].location != NSNotFound) {
            
            NSArray *chunks = [buffer componentsSeparatedByString:@"\r\n"];
            
            if([chunks count] > 1) {
                for (int i=0; i < [chunks count] - 1; i ++) {
                    id json = [[chunks objectAtIndex:i] objectFromJSONString];                    
                    [[EventBus defaultEventBus] fireEvent:[PictureEvent eventWithURL:[json objectForKey:@"fll"] 
                                                                                 pic:json 
                                                                                from:[request.userInfo objectForKey:@"name"]]];                
                }
                [buffer setString:[chunks lastObject]];
            }
        }
        
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"error");
    [self startStream:[request.userInfo objectForKey:@"name"] url:[request url]];
}


@end



/*****************************
 * PictureEvent              *
 *****************************/

static NSString *kPictureEventType = @"PictureEvent";

@implementation PictureEvent

@synthesize url = url_;
@synthesize pic = pic_;
@synthesize stream = stream_;

+ (NSString*)type 
{    
    return kPictureEventType;
}

-(id)initWithURL:(NSString*)url pic:(id)pic from:(NSString*)stream
{
    if((self = [super init])) {
        self.url = url;
        self.pic = pic;
        self.stream =stream;
    }
    return self;
}

+(PictureEvent*)eventWithURL:(NSString*)url pic:(id)pic from:(NSString*)stream;
{
    return [[[PictureEvent alloc] initWithURL:url pic:pic from:stream] autorelease];
}

@end

