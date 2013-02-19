//
//  ADVSociovilleTheme.m
//  
//
//  Created by Valentin Filip on 7/9/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import "ADVFitpulseTheme.h"

@implementation ADVFitpulseTheme

- (UIStatusBarStyle)statusBarStyle {
    return UIStatusBarStyleBlackOpaque;
}

- (UIColor *)mainColor {
    return [UIColor colorWithWhite:0.3 alpha:1.0];
}

- (UIColor *)secondColor {
    return [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f];
}

- (UIColor *)navigationTextColor {
    return [UIColor colorWithWhite:1.0 alpha:1.0];
}

- (UIColor *)highlightColor
{
    return [UIColor colorWithWhite:0.9 alpha:1.0];
}

- (UIColor *)shadowColor
{
    return [UIColor colorWithWhite:1.0 alpha:0.5];
}

- (UIColor *)highlightShadowColor
{
    return [UIColor colorWithWhite:0.3 alpha:0.7];
}

- (UIColor *)navigationTextShadowColor {
    return [UIColor colorWithRed:0.00f green:0.44f blue:0.66f alpha:1.00f];
}

- (UIFont *)navigationFont {
    return [UIFont fontWithName:@"HelveticaNeue Bold" size:24];
}

- (UIColor *)backgroundColor
{
    return [UIColor colorWithWhite:0.85 alpha:1.0];
}

- (UIColor *)baseTintColor
{
    return nil;
}

- (UIColor *)accentTintColor
{
    return nil;
}

- (UIColor *)selectedTabbarItemTintColor
{
    return [UIColor colorWithRed:0.50f green:0.84f blue:0.06f alpha:1.00f];
}

- (UIColor *)switchThumbColor
{
    return [UIColor colorWithRed:0.87f green:0.87f blue:0.89f alpha:1.00f];
}

- (UIColor *)switchOnColor
{
    return [UIColor colorWithRed:0.16f green:0.65f blue:0.51f alpha:1.00f];
}

- (UIColor *)switchTintColor
{
    return [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f];;
}

- (CGSize)shadowOffset
{
    return CGSizeMake(0.0, 1.0);
}

- (UIImage *)topShadow
{
    return [UIImage imageNamed:@"topShadow"];
}

- (UIImage *)bottomShadow
{
    return [UIImage imageNamed:@"bottomShadow"];
}

- (UIImage *)navigationBackgroundForBarMetrics:(UIBarMetrics)metrics
{
    NSString *name = @"navigationBackground";
    if (metrics == UIBarMetricsLandscapePhone) {
        name = [name stringByAppendingString:@"Landscape"];
    }
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 8.0, 0.0, 8.0)];
    return image;
}

- (UIImage *)navigationBackgroundForIPadAndOrientation:(UIInterfaceOrientation)orientation {
    NSString *name = @"navigationBackgroundRight";
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        name = [name stringByAppendingString:@"Landscape"];
    }
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 8.0, 0.0, 8.0)];
    return image;
}

- (UIImage *)barButtonBackgroundForState:(UIControlState)state style:(UIBarButtonItemStyle)style barMetrics:(UIBarMetrics)barMetrics
{
    NSString *name = @"barButton";
    if (style == UIBarButtonItemStyleDone) {
        name = [name stringByAppendingString:@"Done"];
    }
    if (barMetrics == UIBarMetricsLandscapePhone) {
        name = [name stringByAppendingString:@"Landscape"];
    }
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:@"Highlighted"];
    }
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    return image;
}

- (UIImage *)backBackgroundForState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics
{
    NSString *name = @"backButton";
    if (barMetrics == UIBarMetricsLandscapePhone) {
        name = [name stringByAppendingString:@"Landscape"];
    }
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:@"Highlighted"];
    }
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 21.0, 0.0, 13.0)];
    return image;
}

- (UIImage *)toolbarBackgroundForBarMetrics:(UIBarMetrics)metrics
{
    NSString *name = @"toolbarBackground";
    if (metrics == UIBarMetricsLandscapePhone) {
        name = [name stringByAppendingString:@"Landscape"];
    }
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 8.0, 0.0, 8.0)];
    return image;
}

- (UIImage *)searchBackground
{
    return [UIImage imageNamed:@"searchBackground"];
}

- (UIImage *)searchFieldImage
{
    UIImage *image = [UIImage imageNamed:@"searchField"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 16.0, 0.0, 16.0)];
    return image;
}

- (UIImage *)searchScopeButtonBackgroundForState:(UIControlState)state
{
    NSString *name = @"searchScopeButton";
    if (state == UIControlStateSelected) {
        name = [name stringByAppendingString:@"Selected"];
    }
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(6.0, 6.0, 6.0, 6.0)];
    return image;
}

- (UIImage *)searchScopeButtonDivider
{
    return [UIImage imageNamed:@"searchScopeButtonDivider"];
}

- (UIImage *)searchImageForIcon:(UISearchBarIcon)icon state:(UIControlState)state
{
    NSString *name;
    if (icon == UISearchBarIconSearch) {
        name = @"searchIconSearch";
    } else if (icon == UISearchBarIconClear) {
        name = @"searchIconClear";
        if (state == UIControlStateHighlighted) {
            name = [name stringByAppendingString:@"Highlighted"];
        }
    }
    return (name ? [UIImage imageNamed:name] : nil);
}

- (UIImage *)segmentedBackgroundForState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics;
{
    NSString *name = @"segmentedBackground";
    if (barMetrics == UIBarMetricsLandscapePhone) {
        name = [name stringByAppendingString:@"Landscape"];
    }
    if (state == UIControlStateSelected) {
        name = [name stringByAppendingString:@"Selected"];
    }
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)];
    return image;
}

- (UIImage *)segmentedDividerForBarMetrics:(UIBarMetrics)barMetrics
{
    NSString *name = @"segmentedDivider";
    if (barMetrics == UIBarMetricsLandscapePhone) {
        name = [name stringByAppendingString:@"Landscape"];
    }
    return [UIImage imageNamed:name];
}

- (UIImage *)tableBackground
{
    UIImage *image = [UIImage imageNamed:@"background"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsZero];
    return image;
}

- (UIImage *)tableSectionHeaderBackground {
    UIImage *image = [UIImage imageNamed:@"list-section-header-bg"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsZero];
    return image;
}


- (UIImage *)tableFooterBackground {
    UIImage *image = [UIImage imageNamed:@"list-footer-bg"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsZero];
    return image;
}

- (UIImage *)viewBackground
{
    UIImage *image = [UIImage imageNamed:@"background"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsZero];
    return image;
}

- (UIImage *)switchOnImage
{
    return [UIImage imageNamed:@"switchOnBackground"];
}

- (UIImage *)switchOffImage
{
    return [UIImage imageNamed:@"switchOffBackground"];
}


- (UIImage *)switchThumbForState:(UIControlState)state {
    NSString *name = @"switchHandle";
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:@"Highlighted"];
    }
    return [UIImage imageNamed:name];
}

- (UIImage *)sliderThumbForState:(UIControlState)state
{
    NSString *name = @"sliderThumb";
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:@"Highlighted"];
    }
    return [UIImage imageNamed:name];
}

- (UIImage *)sliderMinTrack
{
    UIImage *image = [UIImage imageNamed:@"sliderMinTrack"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 35.0, 0.0, 35.0)];
    return image;
}

- (UIImage *)sliderMaxTrack
{
    UIImage *image = [UIImage imageNamed:@"sliderMaxTrack"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 35.0, 0.0, 35.0)];
    return image;
}

- (UIImage *)progressTrackImage
{
    UIImage *image = [UIImage imageNamed:@"progress-segmented-track"];
    return image;
}

- (UIImage *)progressProgressImage
{
    UIImage *image = [UIImage imageNamed:@"progress-segmented-fill"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    return image;
}

- (UIImage *)progressPercentTrackImage
{
    UIImage *image = [UIImage imageNamed:@"progressTrack"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)];
    return image;
}

- (UIImage *)progressPercentProgressImage
{
    UIImage *image = [UIImage imageNamed:@"progressProgress"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 7.0, 0.0, 7.0)];
    return image;
}

- (UIImage *)stepperBackgroundForState:(UIControlState)state
{
    NSString *name = @"stepperBackground";
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:@"Highlighted"];
    } else if (state == UIControlStateDisabled) {
        name = [name stringByAppendingString:@"Disabled"];
    }
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 13.0, 0.0, 13.0)];
    return image;
}

- (UIImage *)stepperDividerForState:(UIControlState)state
{
    NSString *name = @"stepperDivider";
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:@"Highlighted"];
    }
    return [UIImage imageNamed:name];
}

- (UIImage *)stepperIncrementImage
{
    return [UIImage imageNamed:@"stepperIncrement"];
}

- (UIImage *)stepperDecrementImage
{
    return [UIImage imageNamed:@"stepperDecrement"];
}

- (UIImage *)buttonBackgroundForState:(UIControlState)state
{
    NSString *name = @"button-gray";
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:@"-pressed"];
    } else if (state == UIControlStateDisabled) {
        name = [name stringByAppendingString:@"-pressed"];
    }
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 16.0, 0.0, 16.0)];
    return image;
}

- (UIImage *)colorButtonBackgroundForState:(UIControlState)state{
    
    NSString *name = @"button-blue";
    if (state == UIControlStateHighlighted) {
        name = [name stringByAppendingString:@"-pressed"];
    } else if (state == UIControlStateDisabled) {
        name = [name stringByAppendingString:@"-pressed"];
    }
    UIImage *image = [UIImage imageNamed:name];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25.0, 0.0, 25.0)];
    return image;

}

- (UIImage *)tabBarBackground
{
    return [UIImage imageNamed:@"tabBarBackground"];
}

- (UIImage *)tabBarSelectionIndicator
{
    return [UIImage imageNamed:@"tabBarSelectionIndicator"];
}

- (UIImage *)imageForTab:(SSThemeTab)tab
{
    return nil;
}

- (UIImage *)finishedImageForTab:(SSThemeTab)tab selected:(BOOL)selected
{
    NSString *name = nil;
    if (tab == SSThemeTabMe) {
        name = @"tabbar-home";
    } else if (tab == SSThemeTabWorkouts) {
        name = @"tabbar-movie";
    } else if (tab == SSThemeTabElements) {
        name = @"tabbar-star";
    } else if (tab == SSThemeTabExtra) {
        name = @"tabbar-vcard";
    }
    if (selected) {
        name = [name stringByAppendingString:@"-selected"];
    }
    return (name ? [UIImage imageNamed:name] : nil);
}


@end
