//
//  TwitterController.m
//  printd
//
//  Created by Anthony MOI on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwitterController.h"
#import "Factory.h"

@implementation TwitterController

- (id) init
{
    if(self = [super init]) {
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void)updateStatus:(NSString *)status
{
    NSString* post_url = [[NSString stringWithFormat:
                          @"http://api.twitter.com/1/statuses/update.json?status=%@",
                           status, nil] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    //NSLog(@"TWEET URL: %@", post_url);

    char *post_arg = NULL;
    
    char *req_url = oauth_sign_url2([post_url UTF8String], &post_arg, OA_HMAC, NULL, 
                                    [TW_CONSUMER_KEY UTF8String], 
                                    [TW_CONSUMER_SECRET UTF8String], 
                                    [TW_ACCESS_TOKEN UTF8String], 
                                    [TW_ACCESS_TOKEN_SECRET UTF8String]);
    
    //printf("req_url: %s\n\npostarg: %s\n", req_url, post_arg);    

    char *reply = oauth_http_post(req_url, post_arg);
    printf("\nREPLY: %s", reply);    
}

@end
