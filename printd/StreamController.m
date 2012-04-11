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
@implementation StreamController

- (id)init
{
    if ( self = [super init] )
    {
        dataMutableString = [[NSMutableString alloc] init];
    }
    return self;
}


- (void) dealloc
{
    [dataMutableString release];
    [super dealloc];
}


- (void) downloadImage: (NSString *) image {
    NSMutableString *urlstring = [NSMutableString stringWithString:@"http://teleportd-ios.nodejitsu.com/geo"];
    
    
    NSURL * url = [NSURL URLWithString:urlstring];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setUserInfo:[NSDictionary dictionaryWithObject:@"TLAPIReq" forKey:@"TLAPIReq"]];
    [request setDelegate:self];
    [request startAsynchronous];
    
}


/*
 * Method for dealing with the teleportd api stream 
 * parsing it
 */
- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data {
    
    if ([[request.userInfo objectForKey:@"TLAPIReq"] isEqualToString:@"TLAPIReq"]) {
        
        [dataMutableString appendString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
        
        while (dataMutableString && [dataMutableString rangeOfString:@"\r\n"].location != NSNotFound) {
            NSRange range = [dataMutableString rangeOfString:@"\r\n"];
            NSString *jsonString = [dataMutableString substringWithRange:range];
            //TODO send the json to the appropriate method to proceed 
            //downloading images
            NSError * error;
            NSDictionary *deserializedData = [jsonString objectFromJSONString];
  
                
                
            [dataMutableString deleteCharactersInRange:range];
        }
    }
    
}

@end
