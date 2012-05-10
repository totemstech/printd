//
//  AppDelegate.m
//  printd
//
//  Created by Mohamed Ahmednah on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//
//  AppDelegate.m
//  printd
//
//  Created by Mohamed Ahmednah on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "Factory.h"
#import <Quartz/Quartz.h>





@implementation AppDelegate

@synthesize window = _window;
@synthesize log = _log;
@synthesize capsule = _capsule;
@synthesize twitter = _twitter;


- (void) dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [_twitter setStringValue:TW_ACCOUNT];
    [[Factory sharedFactory] log:@"INITIALIZING..."];
    [[Factory sharedFactory] setCapsuleId:@""];
    
    /*******************************
     * START!!!                    *
     *******************************/   
    [[[Factory sharedFactory] capsuleController] trackCapsuleWithId:TLPD_CAPSULE_ID fromStart:NO];
}

- (void)log:(NSString*)str
{
    [_log setFont:[NSFont boldSystemFontOfSize:11.0f]];
    NSString *txt = [NSString stringWithFormat:@"%@\n%@", str, [_log string]];
    [_log setString:txt];        
}

- (void)setCapsuleId:(NSString*)capsuleId
{
    [_capsule setStringValue:capsuleId];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    if(!flag)
        [_window makeKeyAndOrderFront:self];
    return TRUE;
}

@end
