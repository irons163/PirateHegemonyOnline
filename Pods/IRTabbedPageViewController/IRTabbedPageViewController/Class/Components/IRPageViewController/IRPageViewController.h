//
//  IRPageViewController.h
//  IRTabbedPageViewController
//
//  Created by Phil on 2019/7/12.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+IRUtilities.h"
#import "UIView+IRAutoLayout.h"

NS_ASSUME_NONNULL_BEGIN

extern NSInteger const IRPageViewControllerPageNumberInvalid;

typedef NS_ENUM(NSInteger, IRPageViewControllerScrollDirection) {
    IRPageViewControllerScrollDirectionUnknown = -1,
    IRPageViewControllerScrollDirectionBackward = 0,
    IRPageViewControllerScrollDirectionForward = 1
};

typedef NS_ENUM(NSInteger, IRPageViewControllerInfinitePagingBehavior) {
    /**
     The infinite page behavior will be standard.
     
     I.e. Going from last index to index 0 will have a forward transition,
     index 0 to last index will have a reverse transition.
     */
    IRPageViewControllerInfinitePagingBehaviorStandard,
    /**
     The infinite page behavior will be reversed.
     
     I.e. Going from last index to index 0 will have a reverse transition,
     index 0 to last index will have a forward transition.
     */
    IRPageViewControllerInfinitePagingBehaviorReversed
};

typedef void(^IRPageViewControllerPageMoveCompletion)(UIViewController *_Nullable newViewController, BOOL animated, BOOL transitionFinished);

@class IRPageViewController;

@protocol IRPageViewControllerDelegate <NSObject>
@optional

/**
 The page view controller has scrolled to a new page offset.
 
 @param pageViewController
 The page view controller.
 @param pageOffset
 The updated page offset.
 */
- (void)pageViewController:(nonnull IRPageViewController *)pageViewController
     didScrollToPageOffset:(CGFloat)pageOffset
                 direction:(IRPageViewControllerScrollDirection)scrollDirection;
/**
 The page view controller has started a scroll to a new page.
 
 @param pageViewController
 The page view controller.
 @param newPage
 The new visible page.
 @param currentPage
 The new currently visible page.
 */
- (void)pageViewController:(nonnull IRPageViewController *)pageViewController
          willScrollToPage:(NSInteger)newPage
               currentPage:(NSInteger)currentPage;
/**
 The page view controller has completed scroll to a page.
 
 @param pageViewController
 The page view controller.
 @param page
 The new currently visible page.
 */
- (void)pageViewController:(nonnull IRPageViewController *)pageViewController
           didScrollToPage:(NSInteger)page;

/**
 The page view controller has successfully prepared child view controllers ready for display.
 
 @param pageViewController
 The page view controller.
 @param viewControllers
 The view controllers inside the page view controller.
 */
- (void)pageViewController:(nonnull IRPageViewController *)pageViewController
 didPrepareViewControllers:(nonnull NSArray *)viewControllers;
/**
 The page view controller will display the initial view controller.
 
 @param pageViewController
 The page view controller.
 @param viewController
 The initial view controller.
 */
- (void)pageViewController:(nonnull IRPageViewController *)pageViewController
willDisplayInitialViewController:(nonnull UIViewController *)viewController;

@end

@protocol IRPageViewControllerDataSource <NSObject>

/**
 The view controllers to display in the page view controller.
 
 @param pageViewController
 The page view controller.
 @return The array of view controllers.
 */
- (nullable NSArray<UIViewController *> *)viewControllersForPageViewController:(nonnull IRPageViewController *)pageViewController;

@optional

/**
 The default page index for the page view controller to initially display.
 
 @param pageViewController
 The page view controller.
 @return The default page index.
 */
- (NSInteger)defaultPageIndexForPageViewController:(nonnull IRPageViewController *)pageViewController;

@end

@interface IRPageViewController : UIViewController <IRPageViewControllerDelegate, IRPageViewControllerDataSource, UIScrollViewDelegate>

/**
 The object that acts as a data source for the page view controller.
 */
@property (nonatomic, weak, nullable) IBOutlet id<IRPageViewControllerDataSource> dataSource;
/**
 The object that acts as a delegate for the page view controller.
 */
@property (nonatomic, weak, nullable) IBOutlet id<IRPageViewControllerDelegate> delegate;

/**
 The number of pages in the page view controller.
 */
@property (nonatomic, assign ,readonly) NSInteger numberOfPages;
/**
 The current active page index of the page view controller.
 */
@property (nonatomic, assign, readonly) NSInteger currentPage;
/**
 The view controllers within the page view controller.
 */
@property (nonatomic, strong, readonly, nullable) NSArray<UIViewController *> *viewControllers;

/**
 Whether page view controller will display the page indicator view.
 */
@property (nonatomic, assign) BOOL showPageIndicator;

/**
 Whether page view controller will provide delegate updates on scroll events.
 */
@property (nonatomic, assign) BOOL allowScrollViewUpdates;
/**
 Whether the user is currently dragging the page view controller.
 */
@property (nonatomic, assign, readonly) BOOL isDragging;
/**
 Whether scroll view interaction is enabled on the page view controller.
 */
@property (nonatomic, assign, getter=isScrollEnabled) BOOL scrollEnabled;
/**
 Whether user interaction is allowed on the page view controller.
 */
@property (nonatomic, assign) BOOL userInteractionEnabled;
/**
 Whether page view controller will provide scroll updates when out of bounds.
 */
@property (nonatomic, assign, getter=willProvideOutOfBoundsUpdates) BOOL provideOutOfBoundsUpdates;
/**
 Whether the page view controller is currently animating a page update.
 */
@property (nonatomic, assign, readonly, getter=isAnimatingPageUpdate) BOOL animatingPageUpdate;
/**
 Allows the page view controller to scroll indefinitely when it reaches end of page range.
 */
@property (nonatomic, assign, getter=hasInfiniteScrollEnabled) BOOL infiniteScrollEnabled;
/**
 The paging behavior to use when infinite scroll is enabled. This adjusts page transition animations
 when using moveToPageAtIndex functions. IRPageViewControllerInfinitePagingBehaviorStandard by default.
 */
@property (nonatomic, assign) IRPageViewControllerInfinitePagingBehavior infiniteScrollPagingBehaviour;

@property (nonatomic) UIEdgeInsets edgeInsets;

/**
 Move page view controller to a page at specific index.
 
 @param index
 The index of the page to display.
 */
- (void)moveToPageAtIndex:(NSInteger)index;

/**
 Move page view controller to a page at specific index.
 
 @param index
 The index of the page to display.
 @param completion
 Completion of the page move.
 */
- (void)moveToPageAtIndex:(NSInteger)index
               completion:(nullable IRPageViewControllerPageMoveCompletion)completion;

/**
 Move page view controller to a page at specific index.
 
 @param index
 The index of the page to display.
 @param animated
 Whether to animate the page transition.
 @param completion
 Completion of the page move.
 */
- (void)moveToPageAtIndex:(NSInteger)index
                 animated:(BOOL)animated
               completion:(nullable IRPageViewControllerPageMoveCompletion)completion;


/** UIScrollViewDelegate */
- (void)scrollViewWillBeginDragging:(nonnull UIScrollView *)scrollView NS_REQUIRES_SUPER;
- (void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView NS_REQUIRES_SUPER;

@end

@interface UIViewController (IRPageViewController)

/**
 The page view controller of the parent
 */
@property (nonatomic, weak, readonly, nullable) IRPageViewController *pageViewController;
/**
 The index of the current view controller
 */
@property (nonatomic, assign, readonly) NSInteger pageIndex;

@end


NS_ASSUME_NONNULL_END
