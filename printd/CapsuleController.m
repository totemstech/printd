//
//  CapsuleController.m
//  printd
//
//  Created by Stanislas POLU on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CapsuleController.h"

#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"

#import "EventBus.h"
#import "Factory.h"


//private methods

@interface CapsuleController ()

- (void)update;

@end


@implementation CapsuleController


- (id)init
{
    self = [super init];
    if (self)
    {
        knownShas_ = [[NSMutableSet alloc] init];
    }
    return self;
}


- (void) dealloc
{
    if(capsuleId_)
        [capsuleId_ release];
    if(updateTimer_)
        [updateTimer_ release];
    [knownShas_ release];
    [super dealloc];
}

- (void)trackCapsuleWithId:(NSString*)capsuleId fromStart:(BOOL)fromStart
{
    [self stop];
 
    [[Factory sharedFactory] setCapsuleId:capsuleId];
    capsuleId_ = [capsuleId retain];

    fromStart_ = fromStart;
    
    updateTimer_ = [NSTimer scheduledTimerWithTimeInterval:10 
                                                    target:self 
                                                  selector:@selector(update) 
                                                  userInfo:nil 
                                                   repeats:YES];
    [updateTimer_ fire];
}

- (void)stop
{
    [[Factory sharedFactory] setCapsuleId:@""];

    [knownShas_ removeAllObjects];
    firstUpdate_ = YES;

    if(capsuleId_) {
        [capsuleId_ release];
        capsuleId_ = nil;
    }
    if(updateTimer_) {
        [updateTimer_ invalidate];
        [updateTimer_ release];
        updateTimer_ = nil;
    }
}

- (void)update 
{
    if(capsuleId_) {
        [[Factory sharedFactory] log:[NSString stringWithFormat:@"UPDATING: %@", capsuleId_]];
        
        NSMutableString *urlStr = [NSString stringWithFormat:@"http://teleportd-board-demo.jit.su/plugin/%@", capsuleId_, nil];
        NSURL * url = [NSURL URLWithString:urlStr];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setTimeOutSeconds:0];
        [request setDelegate:self];
        [request setUserInfo:[NSDictionary dictionaryWithObject:capsuleId_ forKey:@"capsule"]];
        
        [request startAsynchronous];
    }
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    [[Factory sharedFactory] log:[NSString stringWithFormat:@"ERROR: updating %@", capsuleId_]];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{    
    id capsule = [[request responseString] objectFromJSONString];
 
    if(![capsule objectForKey:@"ok"]) {
        [[Factory sharedFactory] log:[NSString stringWithFormat:@"ERROR: %@ %@", 
                                      [capsule objectForKey:@"error"], capsuleId_]];        
        return;
    }
    
    [[Factory sharedFactory] log:[NSString stringWithFormat:@"UPDATED: %@", capsuleId_]];   
    
    id list = [[capsule objectForKey:@"set"] objectForKey:@"pic"];
    
    if(firstUpdate_ && !fromStart_) {
        for(int i = 0; i <[list count]; i++) {
            [knownShas_ addObject:[[list objectAtIndex:i] objectForKey:@"sha"]];
        }
        firstUpdate_ = NO;
        return;
    }
    
    for(int i = 0; i <[list count]; i++) { 
        if(![knownShas_ containsObject:[[list objectAtIndex:i] objectForKey:@"sha"]]) {
            id json = [list objectAtIndex:i];
            [[Factory sharedFactory] log:[NSString stringWithFormat:@"NEW: %@", 
                                          [json objectForKey:@"sha"]]];        
            [[EventBus defaultEventBus] fireEvent:[PictureEvent eventWithURL:[json objectForKey:@"fll"] 
                                                                         pic:json]];
            [knownShas_ addObject:[[list objectAtIndex:i] objectForKey:@"sha"]];
        }
    }
    
    firstUpdate_ = NO;        
    
    NSLog(@"%@", [request responseString]);
}

@end
