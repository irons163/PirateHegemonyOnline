//
//  IRTabBarView.h
//  IRTabbedPageViewController
//
//  Created by Phil on 2019/7/12.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRTabBarCollectionViewCell.h"
#import "IRTabSizingStyle.h"
#import "IRTabStyle.h"
#import "IRTabBarAppearance.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, IRTabTransitionStyle) {
    IRTabTransitionStyleProgressive,
    IRTabTransitionStyleSnap
};

typedef NS_ENUM(NSInteger, IRIndicatorStyle) {
    IRIndicatorStyleLine,
    IRIndicatorStyleImage
};

typedef NS_ENUM(NSInteger, IRSizeToFitAlginStyle) {
    IRSizeToFitAlginCenterWithCells,
    IRSizeToFitAlginCenterWithMiddleCell,
};

extern CGFloat const IRTabBarViewDefaultHeight;

@class IRTabBarView;
@protocol IRTabBarViewDataSource <NSObject>

@required

/**
 The number of items to display in the tab bar.
 
 @param tabBarView
 The tab bar view.
 
 @return the number of tab bar items.
 */
- (NSInteger)numberOfItemsForTabBarView:(nonnull IRTabBarView *)tabBarView;
/**
 Populate a tab bar item.
 
 @param tabBarView
 The tab bar view.
 
 @param tab
 The tab to populate.
 
 @param index
 The index of the tab.
 */
- (void)tabBarView:(nonnull IRTabBarView *)tabBarView
       populateTab:(nonnull IRTabBarCollectionViewCell *)tab
           atIndex:(NSInteger)index;

@optional

/**
 The tab titles to display in the tab bar.
 
 @param tabBarView
 The tab bar view.
 
 @return The array of tab titles.
 */
- (nullable NSArray<NSString *> *)tabTitlesForTabBarView:(nonnull IRTabBarView *)tabBarView
__attribute__((deprecated("Use numberOfItemsForTabBarView and tabBarView:populateTab:atIndex instead")));

/**
 The default tab index to to display in the tab bar.
 
 @param tabBarView
 The tab bar view.
 
 @return
 The default tab index.
 */
- (NSInteger)defaultTabIndexForTabBarView:(nonnull IRTabBarView *)tabBarView;

@end

@protocol IRTabBarViewDelegate <NSObject>
@optional

/**
 A tab has been selected.
 
 @param tabBarView
 The tab bar view.
 @param index
 The index of the selected tab.
 */
- (void)tabBarView:(nonnull IRTabBarView *)tabBarView tabSelectedAtIndex:(NSInteger)index;

- (void)tabBarView:(nonnull IRTabBarView *)tabBarView
       populateTab:(nonnull IRTabBarCollectionViewCell *)tab
tabWillSelectAtIndex:(NSInteger)index;

@end

@interface IRTabBarView : UIView

/**
 The object that acts as the data source for the tab bar.
 */
@property (nonatomic, weak, nullable) IBOutlet id<IRTabBarViewDataSource> dataSource;
/**
 The object that acts as a delegate for the tab bar.
 */
@property (nonatomic, weak, nullable) IBOutlet id<IRTabBarViewDelegate> delegate;

/**
 The number of tabs in the tab bar.
 */
@property (nonatomic, assign, readonly) NSInteger tabCount;

/**
 Whether the tab bar is currently animating a tab change transition.
 */
@property (nonatomic, assign, readonly, getter=isAnimatingTabChange) BOOL animatingTabChange;
/**
 Whether the user can manually scroll the tab bar.
 */
@property (nonatomic, assign) BOOL scrollEnabled;

@property (nonatomic) BOOL allowsSelection;

/**
 The background view for the tab bar.
 */
@property (nonatomic, strong, nullable) UIView *backgroundView;

/**
 The internal horizontal label padding value for each tab.
 */
@property (nonatomic, assign) CGFloat tabPadding UI_APPEARANCE_SELECTOR;
/**
 The content inset for the tabs.
 */
@property (nonatomic, assign) UIEdgeInsets contentInset UI_APPEARANCE_SELECTOR;

/**
 The sizing style to use for tabs in the tab bar.
 
 IRTabSizingStyleSizeToFit - size tabs to the size of their contents.
 
 IRTabSizingStyleDistributed - distribute the tabs equally in the frame of the tab bar (Max 5).
 */
@property (nonatomic, assign) IRTabSizingStyle sizingStyle UI_APPEARANCE_SELECTOR;
/**
 The style for tabs in the tab bar.
 
 IRTabStyleImage - use images as the content for each tab.
 
 IRTabStyleText - use text as the content for each tab.
 */
@property (nonatomic, assign) IRTabStyle tabStyle UI_APPEARANCE_SELECTOR;
/**
 The style for the tab indicator.
 
 IRIndicatorStyleLine - use a coloured line as the indicator (default).
 
 IRIndicatorStyleImage - use an image as the indicator.
 */
@property (nonatomic, assign) IRIndicatorStyle indicatorStyle UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) IRSizeToFitAlginStyle sizeToFitAlginStyle UI_APPEARANCE_SELECTOR;

/**
 The appearance attributes for tabs.
 
 Available attributes:
 NSForegroundColorAttributeName, NSFontAttributeName, NSBackgroundColorAttributeName
 */
@property (nonatomic, strong, nullable) NSDictionary <NSString *, id> *tabAttributes UI_APPEARANCE_SELECTOR;
/**
 The appearance attributes for selected tabs.
 
 Available attributes:
 NSForegroundColorAttributeName, NSFontAttributeName, NSBackgroundColorAttributeName
 */
@property (nonatomic, strong, nullable) NSDictionary <NSString *, id> *selectedTabAttributes UI_APPEARANCE_SELECTOR;
/**
 The appearance attributes for the tab indicator.
 */
@property (nonatomic, strong, nullable) NSDictionary <NSString *, id> *indicatorAttributes UI_APPEARANCE_SELECTOR;

/**
 The transition style for the tabs to use during transitioning.
 */
@property (nonatomic, assign) IRTabTransitionStyle tabTransitionStyle UI_APPEARANCE_SELECTOR;
/**
 The transition style for the tab indicator to use during transitioning.
 */
@property (nonatomic, assign) IRTabTransitionStyle indicatorTransitionStyle UI_APPEARANCE_SELECTOR;

/**
 Whether the tab bar contents can be scrolled.
 */
@property (nonatomic, assign) BOOL userScrollEnabled __attribute__((deprecated("Use scrollEnabled instead")));
/**
 The transition style for the selection indicator to use during transitioning.
 */
@property (nonatomic, assign) IRTabTransitionStyle selectionIndicatorTransitionStyle UI_APPEARANCE_SELECTOR __attribute__((deprecated("Use indicatorTransitionStyle instead")));
/**
 The height of the selection indicator.
 */
@property (nonatomic, assign) CGFloat selectionIndicatorHeight UI_APPEARANCE_SELECTOR  __attribute__((deprecated("Use indicatorAttributes instead")));
/**
 The color of the tab selection indicator.
 */
@property (nonatomic, strong, nullable) UIColor *tabIndicatorColor UI_APPEARANCE_SELECTOR  __attribute__((deprecated("Use indicatorAttributes instead")));
/**
 The text color of the tabs.
 */
@property (nonatomic, strong, nullable) UIColor *tabTextColor UI_APPEARANCE_SELECTOR  __attribute__((deprecated("Use tabAttributes instead")));
/**
 The font used for the tabs. A nil value uses the default font from the cell nib.
 */
@property (nonatomic, strong, nullable) UIFont *tabTextFont UI_APPEARANCE_SELECTOR __attribute__((deprecated("Use tabAttributes instead")));


/**
 Initialize a tab bar with a specified height.
 
 @param height
 The height for the tab bar.
 @return Tab bar instance.
 */
- (nonnull instancetype)initWithHeight:(CGFloat)height;

/**
 Set the current selected tab index of the tab bar.
 
 @param index
 The index of the current tab.
 @param animated
 Animate the tab index transition.
 */
- (void)setTabIndex:(NSInteger)index animated:(BOOL)animated;

- (void)setTabSelected:(NSInteger) index animated:(BOOL)animated;

/**
 Set the data source of the tab bar.
 
 @param dataSource
 The data source.
 @param animated
 Animate the data source transition.
 */
- (void)setDataSource:(nullable id<IRTabBarViewDataSource>)dataSource animated:(BOOL)animated;

/**
 Set the tab and selection indicator transition style.
 */
- (void)setTransitionStyle:(IRTabTransitionStyle)transitionStyle;

@end


NS_ASSUME_NONNULL_END
