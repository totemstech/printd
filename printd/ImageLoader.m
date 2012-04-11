//
//  ImageLoader.m
//  Bipsly
//
//  Created by Stanislas POLU on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageLoader.h"

#import "ASIHTTPRequest.h"
#import "EventBus.h"

@interface ImageLoader()

- (void)enqueueURLString:(NSString *)aURLString;
- (NSString *)pathForImage:(NSString *)aURLString;

@end

static ImageLoader *kDefaultImageLoader;

@implementation ImageLoader

+ (ImageLoader*)defaultImageLoader
{
    if(!kDefaultImageLoader) {
        kDefaultImageLoader = [[ImageLoader alloc] init];
    }
    return kDefaultImageLoader;
}

- (id)init {
    self = [super init];
	
    if (self) {                
        imageCache_ = [[NSMutableDictionary alloc] init];
        imageCachePath_ = [[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] 
                            stringByAppendingPathComponent:@"images"] retain];
        
        networkQueue_ = [[ASINetworkQueue alloc] init];
        networkQueue_.delegate = self;
        networkQueue_.requestDidFinishSelector = @selector(queuedRequestFinished:);
        networkQueue_.requestDidFailSelector = @selector(queuedRequestFailed:);
        [networkQueue_ go];
        
        responseQueue_ = [[NSOperationQueue alloc] init];
        
        inProgress_ = [[NSMutableDictionary alloc] init];
        
        [[EventBus defaultEventBus] addHandler:self
                                     eventType:[MemoryWarningEvent type]
                                      selector:@selector(onMemoryWarning:)];
    }
 
    return self;
}

- (UIImage *)imageForUrl:(NSString*)url
{
    if(url) {
        UIImage *img = nil;
        
        if ((img = [imageCache_ objectForKey:url])) {
            //NSLog(@"ILImageLoader INCACHE: %@", url);
			return img;
		}
        else if((img = [UIImage imageWithContentsOfFile:[self pathForImage:url]])) {
            //NSLog(@"ILImageLoader INFILE: %@", url);
			[imageCache_ setObject:img forKey:url];
			return img;
        } 
        else if (![inProgress_ valueForKey:url]) {
            //NSLog(@"ILImageLoader NETWORK: %@", url);
            ILImageLoadedEvent *evt = [ILImageLoadedEvent eventWithImageAtUrl:url];
            [inProgress_ setObject:evt forKey:[evt url]];    
            [self enqueueURLString:[evt url]];
        }
    }
    return nil;
}

- (void)prefetchImageForUrl:(NSString*)url
{
    if(url) {
        UIImage *img = nil;
        
        if ((img = [imageCache_ objectForKey:url])) {
            [[ILImagePrefetchEvent eventWithImageAtUrl:url] fire];
		}
        else if((img = [UIImage imageWithContentsOfFile:[self pathForImage:url]])) {
            [[ILImagePrefetchEvent eventWithImageAtUrl:url] fire];
        } 
        else if (![inProgress_ valueForKey:url]) {
            //NSLog(@"ILImageLoader NETWORK: %@", url);
            ILImageLoadedEvent *evt = [ILImageLoadedEvent eventWithImageAtUrl:url];
            evt.prefetch = YES;
            [inProgress_ setObject:evt forKey:url];
            [self enqueueURLString:[evt url]];
        }
        else if([inProgress_ valueForKey:url]) {
            [[inProgress_ valueForKey:url] setPrefetch:YES];
        }
    }
}

- (void)emptyCache
{
    NSLog(@"HCImageLoader Emptying Cache");
	[imageCache_ removeAllObjects];
}

- (NSString *)pathForImage:(NSString *)aURLString 
{
	NSURL *url = [NSURL URLWithString:aURLString];
	NSString *targetPath = [imageCachePath_ stringByAppendingPathComponent:[url host]];
	return [targetPath stringByAppendingPathComponent:[url path]];	
}

- (NSString *)directoryForImage:(NSString *)aURLString {
	return [[self pathForImage:aURLString] stringByDeletingLastPathComponent];
}

- (void)enqueueURLString:(NSString *)aURLString
{
    //NSLog(@"ILImageLoader Queueing: %@", aURLString);
    
	[[NSFileManager defaultManager] createDirectoryAtPath:[self directoryForImage:aURLString] 
                              withIntermediateDirectories:YES 
                                               attributes:nil 
                                                    error:nil];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:aURLString]];

    [request setNumberOfTimesToRetryOnTimeout:0];
    request.timeOutSeconds = 10.0f;

	request.downloadDestinationPath = [self pathForImage:aURLString]; 
	[networkQueue_ addOperation:request];    
}


- (void)queuedRequestFinished:(ASIHTTPRequest *)request 
{
    //NSLog(@"ILImageLoader Request Finished: %@", [[request originalURL] absoluteString]);

	NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self 
                                                                            selector:@selector(loadImageOnMainThread:) 
                                                                              object:request];
	[responseQueue_ addOperation:operation];
	[operation release];
}

- (void)queuedRequestFailed:(ASIHTTPRequest *)request 
{
    NSString *url = [[request url] absoluteString];
    if([request originalURL]) {
        url = [[request originalURL] absoluteString];
    }
	//NSLog(@"ILImageLoader Failed: %@", [[request originalURL] absoluteString]);
    if(url)
        [inProgress_ removeObjectForKey:url];
	
    [[ILImageFailedEvent eventWithImageAtUrl:[[request originalURL] absoluteString] networkFail:YES] fire];
}


- (void)loadImageOnMainThread:(ASIHTTPRequest *)request 
{
	[self performSelectorOnMainThread:@selector(loadImage:) 
                           withObject:request 
                        waitUntilDone:YES];
}

- (void)loadImage:(ASIHTTPRequest *)request 
{
    //NSLog(@"ILImageLoader Handling: %@", [[request originalURL] absoluteString]);
    ILImageLoadedEvent *evt = [inProgress_ objectForKey:[[request originalURL] absoluteString]];
    
	UIImage *image = [UIImage imageWithContentsOfFile:
                      [self pathForImage:[[request originalURL] absoluteString]]];
	if (image) {
	    //NSLog(@"ILImageLoader SUCCESS: %@", [[request originalURL] absoluteString]);
    	[imageCache_ setObject:image forKey:[[request originalURL] absoluteString]];
        if(evt) {
            if(evt.prefetch)
                [[ILImagePrefetchEvent eventWithImageAtUrl:evt.url] fire];
            [evt fire];            
        }
    } 
    else {
		[[NSFileManager defaultManager] removeItemAtPath:
         [self pathForImage:[[request originalURL] absoluteString]] error:nil];                
        
        NSLog(@"ILImageLoader Failed on Image: %@", [[request originalURL] absoluteString]);
        [[ILImageFailedEvent eventWithImageAtUrl:[[request originalURL] absoluteString] networkFail:NO] fire];
	}
    [inProgress_ removeObjectForKey:[[request originalURL] absoluteString]];
}

- (void)onMemoryWarning:(MemoryWarningEvent*)evt
{
    [self emptyCache];
}

- (void)dealloc
{
    [imageCache_ release];
    [imageCachePath_ release];
    
    [networkQueue_ release];
    [responseQueue_ release];
    
    [inProgress_ release];
    
    [super dealloc];
}
@end





// Events


static NSString *kILImageLoadedEventType = @"ILImageLoadedEvent";

@implementation ILImageLoadedEvent

@synthesize url = url_;
@synthesize prefetch = prefetch_;

+ (NSString*)type
{
    return kILImageLoadedEventType;
}

- (id)initWithImageAtUrl:(NSString*)url;
{
    self = [super init];
    
    if (self != nil) {
        self.url = url;
    }
    
    return self;
}

+ (ILImageLoadedEvent*)eventWithImageAtUrl:(NSString*)url;
{
    ILImageLoadedEvent* evt = [[[ILImageLoadedEvent alloc] initWithImageAtUrl:url] autorelease];
    return evt;
}
@end



static NSString *kILImageImagePrefetchEventType = @"ILImagePrefetchEvent";

@implementation ILImagePrefetchEvent

@synthesize url = url_;

+ (NSString*)type
{
    return kILImageImagePrefetchEventType;
}

- (id)initWithImageAtUrl:(NSString*)url;
{
    self = [super init];
    
    if (self != nil) {
        self.url = url;
    }
    
    return self;
}

+ (ILImagePrefetchEvent*)eventWithImageAtUrl:(NSString*)url;
{
    ILImagePrefetchEvent* evt = [[[ILImagePrefetchEvent alloc] initWithImageAtUrl:url] autorelease];
    return evt;
}
@end




static NSString *kILImageFailedEventType = @"ILImageFailedEvent";

@implementation ILImageFailedEvent

@synthesize url = url_;
@synthesize networkFail = networkFail_;

+ (NSString*)type
{
    return kILImageFailedEventType;
}

- (id)initWithImageAtUrl:(NSString*)url 
             networkFail:(BOOL)networkFail
{
    self = [super init];
    
    if (self != nil) {
        self.url = url;
        self.networkFail = networkFail;
    }
    
    return self;
}

+ (ILImageFailedEvent*)eventWithImageAtUrl:(NSString*)url 
                               networkFail:(BOOL)networkFail
{
    ILImageFailedEvent* evt = [[[ILImageFailedEvent alloc] initWithImageAtUrl:url 
                                                                  networkFail:networkFail] autorelease];
    return evt;
}
@end



