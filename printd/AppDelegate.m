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


- (void) dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSView *vw = [[[Factory sharedFactory] pageController] buildPage:[NSImage imageNamed:@"test.jpeg"] event:nil];
    [[[Factory sharedFactory] printController] printView:vw];
    
    /*******************************
     * START!!!                    *
     *******************************/   
    NSMutableDictionary *dic1 = [[[NSMutableDictionary alloc] init] autorelease];

    [dic1 setObject:[NSArray arrayWithObjects:
                     [NSNumber numberWithFloat:45.0f],
                     [NSNumber numberWithFloat:90.0f],
                     [NSNumber numberWithFloat:90.0f],
                     [NSNumber numberWithFloat:180.0f], 
                    nil]
            forKey:@"loc"];
    
    [dic1 setObject:[NSArray arrayWithObjects:@"yfrog", nil] forKey:@"track"];
    
    [[[Factory sharedFactory] streamController]addStream:dic1
                                                withName:@"stream1"];
    
    // stream2
    NSMutableDictionary *dic2 = [[[NSMutableDictionary alloc] init] autorelease];
    
    [dic2 setObject:[NSArray arrayWithObjects:
                    [NSNumber numberWithFloat:-45.0f],
                    [NSNumber numberWithFloat:-90.0f],
                    [NSNumber numberWithFloat:90.0f],
                    [NSNumber numberWithFloat:180.0f], 
                    nil]
            forKey:@"loc"];
    
    [dic2 setObject:[NSArray arrayWithObjects:@"twitpic", nil] forKey:@"track"];
    
    [[[Factory sharedFactory] streamController]addStream:dic2
                                                withName:@"stream2"];
   
}
@end
