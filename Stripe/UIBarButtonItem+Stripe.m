//
//  UIBarButtonItem+Stripe.m
//  Stripe
//
//  Created by Jack Flintermann on 5/18/16.
//  Copyright © 2016 Stripe, Inc. All rights reserved.
//

#import "UIBarButtonItem+Stripe.h"
#import "UIImage+Stripe.h"
#import "STPTheme.h"

@implementation UIBarButtonItem (Stripe)

+ (instancetype)stp_backButtonItemWithTitle:(NSString *)title
                                      style:(UIBarButtonItemStyle)style
                                     target:(id)target
                                     action:(SEL)action {
    UIBarButtonItem *item = [[self alloc] initWithTitle:title
                                                             style:style
                                                            target:target
                                                            action:action];
    UIImage *chevron = [UIImage stp_leftChevronIcon];
    CGFloat yPadding = (30 - chevron.size.height) / 2;
    UIImage *paddedChevron = [chevron stp_paddedImageWithInsets:UIEdgeInsetsMake(yPadding, 0, yPadding, 30)];
    [item setBackgroundImage:paddedChevron forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    return item;
}

- (void)stp_setTheme:(STPTheme *)theme {
    UIImage *image = [self backgroundImageForState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage *enabledImage = [image stp_imageWithTintColor:theme.accentColor];
    UIImage *disabledImage = [image stp_imageWithTintColor:theme.secondaryForegroundColor];
    [self setBackgroundImage:enabledImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:disabledImage forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
    
    self.tintColor = self.enabled ? theme.accentColor : theme.secondaryForegroundColor;
    [self setTitleTextAttributes:@{
                                   NSFontAttributeName: self.style == UIBarButtonItemStylePlain ? theme.font : theme.emphasisFont,
                                   NSForegroundColorAttributeName: theme.accentColor,
                                   }
                        forState:UIControlStateNormal];
    [self setTitleTextAttributes:@{
                                   NSFontAttributeName: self.style == UIBarButtonItemStylePlain ? theme.font : theme.emphasisFont,
                                   NSForegroundColorAttributeName: theme.secondaryForegroundColor,
                                   }
                        forState:UIControlStateDisabled];
}

@end

