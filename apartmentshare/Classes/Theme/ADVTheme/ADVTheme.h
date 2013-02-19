//
//  ADVTheme.h
//  
//
//  Created by Valentin Filip on 7/9/12.
//  Copyright (c) 2012 AppDesignVault. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    SSThemeTabMe,
    SSThemeTabWorkouts,
    SSThemeTabElements,
    SSThemeTabExtra
} SSThemeTab;

@protocol ADVTheme <NSObject>

- (UIStatusBarStyle)statusBarStyle;

- (UIColor *)mainColor;
- (UIColor *)secondColor;
- (UIColor *)navigationTextColor;
- (UIColor *)highlightColor;
- (UIColor *)shadowColor;
- (UIColor *)highlightShadowColor;
- (UIColor *)navigationTextShadowColor;
- (UIColor *)backgroundColor;

- (UIFont *)navigationFont;

- (UIColor *)baseTintColor;
- (UIColor *)accentTintColor;
- (UIColor *)selectedTabbarItemTintColor;

- (UIColor *)switchThumbColor;
- (UIColor *)switchOnColor;
- (UIColor *)switchTintColor;

- (CGSize)shadowOffset;

- (UIImage *)topShadow;
- (UIImage *)bottomShadow;

- (UIImage *)navigationBackgroundForBarMetrics:(UIBarMetrics)metrics;
- (UIImage *)navigationBackgroundForIPadAndOrientation:(UIInterfaceOrientation)orientation;
- (UIImage *)barButtonBackgroundForState:(UIControlState)state style:(UIBarButtonItemStyle)style barMetrics:(UIBarMetrics)barMetrics;
- (UIImage *)backBackgroundForState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics;

- (UIImage *)toolbarBackgroundForBarMetrics:(UIBarMetrics)metrics;

- (UIImage *)searchBackground;
- (UIImage *)searchFieldImage;
- (UIImage *)searchImageForIcon:(UISearchBarIcon)icon state:(UIControlState)state;
- (UIImage *)searchScopeButtonBackgroundForState:(UIControlState)state;
- (UIImage *)searchScopeButtonDivider;

- (UIImage *)segmentedBackgroundForState:(UIControlState)state barMetrics:(UIBarMetrics)barMetrics;
- (UIImage *)segmentedDividerForBarMetrics:(UIBarMetrics)barMetrics;

- (UIImage *)tableBackground;
- (UIImage *)tableSectionHeaderBackground;
- (UIImage *)tableFooterBackground;
- (UIImage *)viewBackground;

- (UIImage *)switchOnImage;
- (UIImage *)switchOffImage;
- (UIImage *)switchThumbForState:(UIControlState)state;

- (UIImage *)sliderThumbForState:(UIControlState)state;
- (UIImage *)sliderMinTrack;
- (UIImage *)sliderMaxTrack;

- (UIImage *)progressTrackImage;
- (UIImage *)progressProgressImage;

- (UIImage *)progressPercentTrackImage;
- (UIImage *)progressPercentProgressImage;

- (UIImage *)stepperBackgroundForState:(UIControlState)state;
- (UIImage *)stepperDividerForState:(UIControlState)state;
- (UIImage *)stepperIncrementImage;
- (UIImage *)stepperDecrementImage;

- (UIImage *)buttonBackgroundForState:(UIControlState)state;

- (UIImage *)colorButtonBackgroundForState:(UIControlState)state;

- (UIImage *)tabBarBackground;
- (UIImage *)tabBarSelectionIndicator;
// One of these must return a non-nil image for each tab:
- (UIImage *)imageForTab:(SSThemeTab)tab;
- (UIImage *)finishedImageForTab:(SSThemeTab)tab selected:(BOOL)selected;


@end

@interface ADVThemeManager : NSObject

+ (id <ADVTheme>)sharedTheme;

+ (void)customizeAppAppearance;
+ (void)customizeView:(UIView *)view;
+ (void)customizeTableView:(UITableView *)tableView;
+ (void)customizeTabBarItem:(UITabBarItem *)item forTab:(SSThemeTab)tab;
+ (void)customizeMainLabel:(UILabel *)label;
+ (void)customizeSecondaryLabel:(UILabel *)label;

@end
