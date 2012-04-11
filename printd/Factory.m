//
//  Factory.m
//  teleportd
//
//  Created by Stanislas POLU on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "Factory.h"

@interface Factory ()

@end

static Factory *sharedFactory_ = nil;

@implementation Factory

@synthesize print = print_;
@synthesize printdAppDelegate = printdAppDelegate_;
@synthesize streamController  = streamController_;
@synthesize pageController    = pageController_;

+ (Factory *)sharedFactory 
{
    if(nil == sharedFactory_) {
        sharedFactory_ = [[Factory alloc] init];
    }
    return sharedFactory_;
}

+ (NSString*)stringWithHexBytes:(NSData*)data 
{
	NSMutableString *stringBuffer = [NSMutableString stringWithCapacity:([data length] * 2)];
	const unsigned char *dataBuffer = [data bytes];
	int i;
	for (i = 0; i < [data length]; ++i) {
		[stringBuffer appendFormat:@"%02X", (unsigned long)dataBuffer[i]];
	}
	return [[stringBuffer copy] autorelease];
}


+ (NSString*)SHA1forData:(NSData *)data
{
	uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
	
    CC_SHA1_CTX sha1Context;
    CC_SHA1_Init(&sha1Context);
    CC_SHA1_Update(&sha1Context, data.bytes, (int)data.length);
	CC_SHA1_Final(digest, &sha1Context);
    
    return [Factory stringWithHexBytes:[NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH]];
}


- (id)init
{
    if((self = [super init])) {
        printdAppDelegate_ = (AppDelegate*)[[NSApplication sharedApplication] delegate];
        print_ = [[PrintController alloc] init];
        streamController_  = [[StreamController alloc] init];
        pageController_    = [[PageController alloc] init];
    }
                               
    return self;
}

- (void)dealloc
{    
    [print_ release];
    [streamController_ release];
    [pageController_ release];
    [super dealloc];
}


@end



