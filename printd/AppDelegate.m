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
    //[[[Factory sharedFactory] streamController] start];
}
@end
