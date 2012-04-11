//
//  PageController.h
//  printd
//
//  Created by Mohamed Ahmednah on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StreamController.h"
#import "ILImageView.h"
#import "ImageLoader.h"


@interface PageController : NSObject

- (void)onPicture:(PictureEvent*)evt;
- (void)onILImagePrefetch:(ILImagePrefetchEvent*)evt;

@end
