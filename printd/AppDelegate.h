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
}

- (void)log:(NSString*)str;
- (void)setCapsuleId:(NSString*)capsuleId;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextView *log;
@property (assign) IBOutlet NSTextField *capsule;
@property (assign) IBOutlet NSTextField *twitter;

@end
