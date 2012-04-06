//
//  AppDelegate.h
//  printd
//
//  Created by Mohamed Ahmednah on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    NSMutableString *dataMutableString;  
}
@property (assign) IBOutlet NSWindow *window;

@end
