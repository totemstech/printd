//
//  Factory.h
//  teleportd
//
//  Created by Stanislas POLU on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PrintController.h"
#import "StreamController.h"
#import "AppDelegate.h"
#import "PageController.h"
// Config

#define PRINT_VIEW_WIDTH 1748
#define PRINT_VIEW_HEIGHT 1181

// Storage keys:

// Factory


@interface Factory : NSObject {
    
}

+ (Factory *) sharedFactory;
+ (NSString*)stringWithHexBytes:(NSData*)data;
+ (NSString*)SHA1forData:(NSData *)data;

@property (nonatomic, readonly, retain)  PrintController         *print;
@property (nonatomic, readwrite, retain) AppDelegate             *printdAppDelegate;
@property (nonatomic, readonly, retain)  StreamController        *streamController;
@property (nonatomic, readonly, retain)  PageController          *pageController;

@end
