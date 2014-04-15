//
//  SimpleGUIFactory.h
//
//  Created by Bruno Capezzali on 24/04/12.
//  Copyright (c) 2012 Bruno Capezzali. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCloseButtonSize (60)

@interface SimpleGUIFactory : NSObject {
    
}

+ (SimpleGUIFactory *)sharedInstance;

- (CGSize)screenSize;
- (UIView *)viewFullscreen;
- (UILabel *)labelWithText:(NSString *)title;
- (UIActivityIndicatorView *)activityIndicator;
- (UIProgressView *)progressView;
- (UIButton *)closeButtonWithTarget:(id)target andSelector:(SEL)selector;
- (void)removeView:(UIView *)view;
- (UIView *)rootView;

@end
