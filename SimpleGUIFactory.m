//
//  SimpleGUIFactory.m
//
//  Created by Bruno Capezzali on 24/04/12.
//  Copyright (c) 2012 Bruno Capezzali. All rights reserved.
//

#import "SimpleGUIFactory.h"

static SimpleGUIFactory *_sharedInstance;

@implementation SimpleGUIFactory

+ (SimpleGUIFactory *)sharedInstance {
    @synchronized([SimpleGUIFactory class]) {
        if (!_sharedInstance) {
            _sharedInstance = [[self alloc] init];
        }
    }
    return _sharedInstance;
}

- (CGSize)screenSize {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGSize size = screenRect.size;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        size = CGSizeMake(size.height, size.width);
    }
    return size;
}

- (UIView *)viewFullscreen {
    CGSize winSize = [self screenSize];
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, winSize.width, winSize.height)];
    [blackView setBackgroundColor:[UIColor blackColor]];
    [blackView setAlpha:0.7f];
    return blackView;
}

- (UILabel *)labelWithText:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont boldSystemFontOfSize:20]];
    [label setShadowColor:[UIColor blackColor]];
    [label setShadowOffset:CGSizeMake(1, 1)];
    [label setText:title];
    return label;
}

- (UIActivityIndicatorView *)activityIndicator {
    CGSize winSize = [self screenSize];
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator setCenter:CGPointMake(winSize.width*0.5f, winSize.height*0.7f)];
    [activityIndicator startAnimating];
    return activityIndicator;
}

- (UIProgressView *)progressView {
    CGSize winSize = [self screenSize];
    UIProgressView *progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [progress setFrame:CGRectMake(0, 0, winSize.width*0.85f, 60.0f)];
    [progress setCenter:CGPointMake(winSize.width*0.5f, winSize.height*0.6f)];
    [progress setProgress:0.0f];
    return progress;
}

- (UIButton *)closeButtonWithTarget:(id)target andSelector:(SEL)selector {
    CGSize winSize = [self screenSize];
    UIImage* closeImage = [UIImage imageNamed:@"close-button-2.png"];
    UIColor* color = [UIColor colorWithRed:167.0/255 green:184.0/255 blue:216.0/255 alpha:1];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:closeImage forState:UIControlStateNormal];
//    [closeButton setTitleColor:color forState:UIControlStateNormal];
    [closeButton setTitleColor:color forState:UIControlStateHighlighted];
    [closeButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [closeButton setFrame:CGRectMake(0, 0, kCloseButtonSize, kCloseButtonSize)];
    [closeButton setCenter:CGPointMake(winSize.width-kCloseButtonSize*0.7f, kCloseButtonSize*0.7f)];
    return closeButton;
}

- (UIView *)rootView {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return window.rootViewController.view;
}

- (void)removeView:(UIView *)view {
    if ( view == nil || [view superview] == nil ) {
        return;
    }
    [view removeFromSuperview];
}

@end
