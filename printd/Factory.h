//
//  Factory.h
//  teleportd
//
//  Created by Stanislas POLU on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PrintController.h"
#import "CapsuleController.h"
#import "AppDelegate.h"
#import "PageController.h"
#import "TwitterController.h"

// Config Top Level

#define TW_STATUS @"@%@ Wow! That's Cool: your photo is being #printd right now... follow the white LEDs. #LamaInParis #%d"
#define TW_ACCOUNT @"@JimmyFairly"

#define TW_CONSUMER_KEY @"xGoSF4ArgirVCTo5XuhdQ"
#define TW_CONSUMER_SECRET @"VydwtQLEaysoRYyq0vBb4CasF4efDv5JCMVQctLEUw4"

#define TW_ACCESS_TOKEN @"309574150-tKpO11zzjs1xqVfF4UMhG9y4roxA43dxzoGJZpgd"
#define TW_ACCESS_TOKEN_SECRET @"a7JcguVZzTPz6dy8mFkqqeDhNCIl9irkIDwNd4Y55Y"

#define TLPD_CAPSULE_ID @"2a7fd05efe68b364e6072f4f9fe810992428ec26"


// Config Low Level

#define PRINT_VIEW_WIDTH 1200
#define PRINT_VIEW_HEIGHT 1800

#define PRINT_IMAGE_WIDTH 1000
#define PRINT_IMAGE_HEIGHT 1000

#define PRINT_PAPER_NAME @"Postcard(4x6in)"

// Storage keys:

// Factory


@interface Factory : NSObject {
    
}

+ (Factory *)sharedFactory;
+ (NSString*)stringWithHexBytes:(NSData*)data;
+ (NSString*)SHA1forData:(NSData *)data;

- (void)log:(NSString*)str;
- (void)setCapsuleId:(NSString*)capsuleId;

@property (nonatomic, readonly, retain)  PrintController         *printController;
@property (nonatomic, readwrite, retain) AppDelegate             *printdAppDelegate;
@property (nonatomic, readonly, retain)  CapsuleController       *capsuleController;
@property (nonatomic, readonly, retain)  PageController          *pageController;
@property (nonatomic, readonly, retain)  TwitterController       *twitterController;

@end
