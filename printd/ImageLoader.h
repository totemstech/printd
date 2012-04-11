//
//  ImageLoader.h
//  Bipsly
//
//  Created by Stanislas POLU on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASINetworkQueue.h"
#import "Event.h"

// Events

@interface ILImageLoadedEvent : Event {    
    NSString      *url_;
}
+ (ILImageLoadedEvent*)eventWithImageAtUrl:(NSString*)url;
@property (nonatomic, retain) NSString    *url;
@property (nonatomic)         bool         prefetch;
@end

@interface ILImagePrefetchEvent : Event {    
    NSString      *url_;
}
+ (ILImagePrefetchEvent*)eventWithImageAtUrl:(NSString*)url;
@property (nonatomic, retain) NSString    *url;
@end


@interface ILImageFailedEvent : Event {
    NSString      *url_;
    BOOL           networkFail_;
}
+ (ILImageFailedEvent*)eventWithImageAtUrl:(NSString*)url 
                               networkFail:(BOOL)networkFail;
@property (nonatomic, retain) NSString    *url;
@property (nonatomic)         BOOL         networkFail;
@end


// Image Loader

@interface ImageLoader : NSObject {
    
    NSMutableDictionary  *imageCache_;
    NSString             *imageCachePath_;
    
    ASINetworkQueue      *networkQueue_;
    NSOperationQueue     *responseQueue_;
    
    NSMutableDictionary  *inProgress_;
}

+ (ImageLoader*)defaultImageLoader;

- (void)emptyCache;
- (UIImage *)imageForUrl:(NSString*)url;
- (void)prefetchImageForUrl:(NSString*)url;

- (void)onMemoryWarning:(MemoryWarningEvent*)evt;

@end
