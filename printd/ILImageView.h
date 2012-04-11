//
//  HCImageView.h
//  teleportd
//
//  Created by Stanislas POLU on 4/24/11.
//  Copyright 2011 teleportd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ImageLoader.h"

@interface ILImageView: UIView {
    
    UIImageView   *tView_;
}

- (void)loadImageAtURL:(NSString*)url withAnimationDuration:(NSTimeInterval)duration;
- (void)clearWithAnimationDuration:(NSTimeInterval)duration;

- (BOOL)isEmpty;

@property (nonatomic, readwrite, retain) NSString  *url;
@property (nonatomic, readwrite)         BOOL       loaded;

@end
