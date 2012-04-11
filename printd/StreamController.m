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
#include "iconv.h"
@implementation StreamController

- (id)init
{
    if ( self = [super init] )
    {
        buffer = [[NSMutableString alloc] init];
        [ self start];
    }
    return self;
}


- (void) dealloc
{
    [buffer release];
    [super dealloc];
}


- (void) start {
    NSMutableString *urlstring = [NSMutableString stringWithString:@"http://api.core.teleportd.com/stream?accesskey=53d9a10e2a7db6b7957be8cbbec599d57541e853a94d98fae6e7e7aca06d424cb49b1b200e9b80b032a549dd03d653735a238982d0dead1f509521f07dea7b30"];
    
    NSURL * url = [NSURL URLWithString:urlstring];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"stream1" forKey:@"stream1"]];
    [request setDelegate:self];
    [request startAsynchronous];
    
}


/*
 * Method for dealing with the teleportd api stream 
 * parsing it
 */
- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data {

    if ([[request.userInfo objectForKey:@"stream1"] isEqualToString:@"stream1"] && data) {        
        [buffer appendString:[[NSString alloc] initWithData:data encoding:[request responseEncoding]]];      
        
        while (buffer && [buffer rangeOfString:@"\r\n"].location != NSNotFound) {
            
            NSArray *chunks = [buffer componentsSeparatedByString:@"\r\n"];
            
           // NSRange range = [dataMutableString rangeOfString:@"\r\n"];
                   
            for (int y = 0; y < [chunks count]; y++) {
                //NSLog(@"%@", [chunks objectAtIndex:y]);
                [[EventBus defaultEventBus] fireEvent:[StreamEvent eventWithDic:[[chunks objectAtIndex:y ] objectFromJSONString]]];
            }
            
            if ([chunks lastObject]  ) {
                
            }

          //  NSString *jsonString = [buffer substringWithRange:range];
         // NSLog(@"%@",[[NSString alloc]initWithData:data encoding:[request responseEncoding]]);
          //  NSLog(@"%@",jsonString);
            //TODO send the json to the appropriate method to proceed 
            //downloading images
            
         //   NSDictionary *deserializedData = [jsonString objectFromJSONString];
           
            
            //[[EventBus defaultEventBus] fireEvent:[StreamEvent eventWithDic:deserializedData]];
  
                
                
           // [buffer deleteCharactersInRange:range];
        }
        
    }
    
}



@end

static NSString *kStreamEventType = @"StreamEvent";

@implementation StreamEvent
@synthesize data;

- (id)initWithDic:(NSDictionary*) dic {
    if ( self = [super init] )
    {
        [self setData:dic];
    }
    return self;
    
}

+ (NSString*)type
{
    return kStreamEventType;
}

+(Event*)event
{
    return [[[StreamEvent alloc] init] autorelease];
}

+(Event*)eventWithDic:(NSDictionary*) dic
{
    return [[[StreamEvent alloc] initWithDic:dic] autorelease];
}



@end