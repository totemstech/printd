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
    
    /*******************************
     * START!!!                    *
     *******************************/   
    // hashtag
    NSMutableDictionary *dic1 = [[[NSMutableDictionary alloc] init] autorelease];

    [dic1 setObject:[NSArray arrayWithObjects:@"esperluette", nil] forKey:@"track"];
    
    [[[Factory sharedFactory] streamController]addStream:dic1
                                                withName:@"hashtag"];
    
    // loc
    NSMutableDictionary *dic2 = [[[NSMutableDictionary alloc] init] autorelease];
    
    [dic2 setObject:[NSArray arrayWithObjects:
                    [NSNumber numberWithFloat:48.846f],
                    [NSNumber numberWithFloat:2.374f],
                    [NSNumber numberWithFloat:0.003f],
                    [NSNumber numberWithFloat:0.003f], 
                    nil]
            forKey:@"loc"];
    
    [[[Factory sharedFactory] streamController]addStream:dic2
                                                withName:@"loc"];

}
@end
