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
#import "TwitterController.h"

// Config

#define PRINT_VIEW_WIDTH 1200
#define PRINT_VIEW_HEIGHT 1800

#define PRINT_IMAGE_WIDTH 1000
#define PRINT_IMAGE_HEIGHT 1000


// Storage keys:

// Factory


@interface Factory : NSObject {
    
}

+ (Factory *)sharedFactory;
+ (NSString*)stringWithHexBytes:(NSData*)data;
+ (NSString*)SHA1forData:(NSData *)data;

@property (nonatomic, readonly, retain)  PrintController         *printController;
@property (nonatomic, readwrite, retain) AppDelegate             *printdAppDelegate;
@property (nonatomic, readonly, retain)  StreamController        *streamController;
@property (nonatomic, readonly, retain)  PageController          *pageController;
@property (nonatomic, readonly, retain)  TwitterController       *twitterController;

@end
