#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "IRPageViewController+Private.h"
#import "IRPageViewController.h"
#import "IRTabBarAppearance.h"
#import "IRTabBarCollectionViewCell+Private.h"
#import "IRTabBarCollectionViewCell.h"
#import "IRTabBarView+Private.h"
#import "IRTabBarView.h"
#import "IRTabSizingStyle.h"
#import "IRTabStyle.h"
#import "IRTabNavigationBar+Private.h"
#import "IRTabNavigationBar.h"
#import "IRTabbedPageViewControllerImp.h"
#import "IRTabControllerStyle.h"
#import "IRCustomHeightNavigationBar.h"
#import "UIView+IRAutoLayout.h"
#import "UIViewController+IRUtilities.h"
#import "IRTabbedPageViewController.h"

FOUNDATION_EXPORT double IRTabbedPageViewControllerVersionNumber;
FOUNDATION_EXPORT const unsigned char IRTabbedPageViewControllerVersionString[];

