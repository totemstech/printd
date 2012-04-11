//
//  ILImageView.m
//  Bipsly
//
//  Created by Stanislas POLU on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ILImageView.h"

#import "EventBus.h"
#import "Registration.h"
#import "ImageLoader.h"
#import "UIImageCategory.h"

@interface ILImageView()

@property (nonatomic, readwrite, retain) Registration *registration;
@property (nonatomic) NSTimeInterval                   duration;

- (void)transitionTo:(UIImage*)to duration:(NSTimeInterval)duration;

@end


@implementation ILImageView

@synthesize registration = registration_;
@synthesize url = url_;
@synthesize duration = duration_;
@synthesize loaded = loaded_;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect sframe = CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);

        tView_ = [[UIImageView alloc] initWithFrame:sframe];
        [self addSubview:tView_];        
        
        self.registration = [[EventBus defaultEventBus] addHandler:self 
                                                         eventType:[ILImageLoadedEvent type] 
                                                          selector:@selector(onILImageLoaded:)];
        
        self.url = nil;
        self.loaded = NO;
    }
    return self;
}

- (void)dealloc
{
    if(self.registration)
        [[EventBus defaultEventBus] removeHandler:self.registration];
    self.registration = nil;
    
    [tView_ removeFromSuperview];
    [tView_ release];
    
    [url_ release];
    
    [super dealloc];
}

- (void)loadImageAtURL:(NSString*)url withAnimationDuration:(NSTimeInterval)duration
{
    //NSLog(@"LOADING URL: %@", url);
    
    self.url = url;
    self.loaded = NO;
    self.duration = duration;
    
    UIImage *img = [[ImageLoader defaultImageLoader] imageForUrl:url];
    if(img) {
        [self transitionTo:img duration:self.duration];
        self.loaded = YES;
    }
    
    [self.superview setNeedsDisplay];
}

- (void)onILImageLoaded:(ILImageLoadedEvent*)event
{
    if([[event url] isEqualToString:url_]) {
        UIImage *anImage = [[ImageLoader defaultImageLoader] imageForUrl:url_];
        if(anImage) {
            [self transitionTo:anImage duration:self.duration]; 
            self.loaded = YES;
        }
    }
}


- (void)clearWithAnimationDuration:(NSTimeInterval)duration
{
    self.url = nil;
    self.loaded = NO;

    [UIView animateWithDuration:duration
                          delay:0.0f 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^(void) {
                         tView_.alpha = 0.0f;
                     } 
                     completion:^(BOOL finished) {
                     }];
}

- (BOOL)isEmpty
{
    return (self.url == nil);
}

- (void)transitionTo:(UIImage*)to duration:(NSTimeInterval)duration
{
    
    UIImage *finalImg = to;
    if (to.size.width * tView_.frame.size.height > tView_.frame.size.width * to.size.height) {
        finalImg = [to imageAtRect:CGRectMake((to.size.width - to.size.height * tView_.frame.size.width / tView_.frame.size.height) / 2,
                                              0.0f,
                                              to.size.height * tView_.frame.size.width / tView_.frame.size.height, 
                                              to.size.height)];
    }
    else {
        finalImg = [to imageAtRect:CGRectMake(0.0f,
                                              (to.size.height - to.size.width * tView_.frame.size.height / tView_.frame.size.width) / 2,                                              
                                              to.size.width,
                                              to.size.width * tView_.frame.size.height / tView_.frame.size.width)];        
    }
    
    [UIView animateWithDuration:duration 
                          delay:0.0f 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^(void) {
                         tView_.alpha = 1.0f;                         
                         tView_.image = finalImg;                         
                     } 
                     completion:^(BOOL finished) {
                     }];
}

- (BOOL)canBecomeFirstResponder {
    return NO;
}

@end
