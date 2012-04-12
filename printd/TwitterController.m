//
//  TwitterController.m
//  printd
//
//  Created by Anthony MOI on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TwitterController.h"
#import "Factory.h"

static NSString* access_token = @"309574150-tKpO11zzjs1xqVfF4UMhG9y4roxA43dxzoGJZpgd";
static NSString* access_token_secret = @"a7JcguVZzTPz6dy8mFkqqeDhNCIl9irkIDwNd4Y55Y";
static NSString* consumer_key = @"xGoSF4ArgirVCTo5XuhdQ";
static NSString* consumer_secret = @"VydwtQLEaysoRYyq0vBb4CasF4efDv5JCMVQctLEUw4";

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
    
    char *post_arg = NULL;
    
    char *req_url = oauth_sign_url2([post_url UTF8String], &post_arg, OA_HMAC, NULL, 
                                    [consumer_key UTF8String], 
                                    [consumer_secret UTF8String], 
                                    [access_token UTF8String], 
                                    [access_token_secret UTF8String]);
    
    //printf("req_url: %s\n\npostarg: %s\n", req_url, post_arg);
    
    char *reply = oauth_http_post(req_url, post_arg);
    //printf("\nREPLY: %s", reply);
}

@end
