//
//  IRTabbedPageViewController.m
//  IRTabbedPageViewController
//
//  Created by Phil on 2019/7/12.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRTabbedPageViewControllerImp.h"
#import "IRPageViewController+Private.h"
#import "IRTabNavigationBar+Private.h"
#import "IRTabBarView+Private.h"
#import <objc/runtime.h>

@interface IRTabbedPageViewControllerImp () <UINavigationControllerDelegate>

#if !defined(IR_APP_EXTENSIONS)
@property (nonatomic, weak) IRTabNavigationBar *tabNavigationBar;
#endif

@property (nonatomic, assign) BOOL allowTabBarRequiredCancellation;

@end

@implementation IRTabbedPageViewControllerImp

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.provideOutOfBoundsUpdates = NO;
}

#if !defined(IR_APP_EXTENSIONS)
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // set up navigation bar for tabbed page view if available
    if ([self.navigationController.navigationBar isMemberOfClass:[IRTabNavigationBar class]] && !self.tabBarView) {
        IRTabNavigationBar *navigationBar = (IRTabNavigationBar *)self.navigationController.navigationBar;
        self.navigationController.delegate = self;
        _tabNavigationBar = navigationBar;
        
        IRTabBarView *tabBarView = navigationBar.tabBarView;
        tabBarView.dataSource = self;
        tabBarView.delegate = self;
        self.tabBarView = tabBarView;
        self.tabBarView.hidden = NO;
        
        BOOL isInitialController = (self.navigationController.viewControllers.firstObject == self);
        [navigationBar tabbedPageViewController:self viewWillAppear:animated isInitial:isInitialController];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.tabNavigationBar && (self.tabBarView == self.tabNavigationBar.tabBarView)) {
        
        // if next view controller is not tabbed page view controller update navigation bar
        self.allowTabBarRequiredCancellation = ![self.navigationController.visibleViewController isKindOfClass:[IRTabbedPageViewControllerImp class]];
        if (self.allowTabBarRequiredCancellation) {
            [self.tabNavigationBar tabbedPageViewController:self viewWillDisappear:animated];
        }
        
        // remove the current tab bar
        self.tabBarView.hidden = YES;
        self.tabBarView = nil;
    }
}
#endif

#pragma mark - Public

- (void)setDelegate:(id<IRPageViewControllerDelegate>)delegate {
    // only allow self to be page view controller delegate
    if (delegate == (id<IRPageViewControllerDelegate>)self) {
        [super setDelegate:delegate];
    }
}

#pragma mark - Tab bar data source

- (NSInteger)numberOfItemsForTabBarView:(IRTabBarView *)tabBarView {
    return self.viewControllers.count;
}

- (void)tabBarView:(IRTabBarView *)tabBarView
       populateTab:(IRTabBarCollectionViewCell *)tab
           atIndex:(NSInteger)index {
    
}

- (NSInteger)defaultTabIndexForTabBarView:(IRTabBarView *)tabBarView {
    if (self.currentPage == IRPageViewControllerPageNumberInvalid) { // return default page if page has not been moved
        return self.defaultPageIndex;
    }
    return self.currentPage;
}

#pragma mark - Tab bar delegate

- (void)tabBarView:(IRTabBarView *)tabBarView tabSelectedAtIndex:(NSInteger)index {
    if (index != self.currentPage && !self.isAnimatingPageUpdate && index < self.viewControllers.count) {
        self.allowScrollViewUpdates = NO;
        self.userInteractionEnabled = NO;
        
        [self.tabBarView setTabIndex:index animated:YES];
        typeof(self) __weak weakSelf = self;
        [self moveToPageAtIndex:index
                     completion:^(UIViewController *newViewController, BOOL animated, BOOL transitionFinished) {
                         typeof(weakSelf) __strong strongSelf = weakSelf;
                         strongSelf.allowScrollViewUpdates = YES;
                         strongSelf.userInteractionEnabled = YES;
                     }];
    }
}

#pragma mark - Page View Controller delegate

- (void)pageViewController:(IRPageViewController *)pageViewController
     didScrollToPageOffset:(CGFloat)pageOffset
                 direction:(IRPageViewControllerScrollDirection)scrollDirection {
    [self.tabBarView setTabOffset:pageOffset];
}

- (void)pageViewController:(IRPageViewController *)pageViewController
          willScrollToPage:(NSInteger)newPage
               currentPage:(NSInteger)currentPage {
    self.tabBarView.userInteractionEnabled = NO;
}

- (void)pageViewController:(IRPageViewController *)pageViewController
           didScrollToPage:(NSInteger)page {
    
    if (!self.isDragging) {
        self.tabBarView.userInteractionEnabled = YES;
    }
    self.allowScrollViewUpdates = YES;
    self.userInteractionEnabled = YES;
    
    if(self.tabbedDelegate && [self.tabbedDelegate respondsToSelector:@selector(IR_tabbedController:didSelectIndex:)])
        [self.tabbedDelegate IR_tabbedController:self didSelectIndex:page];
}

#pragma mark - Navigation Controller delegate

#if !defined(IR_APP_EXTENSIONS)
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
    // Fix for navigation controller swipe back gesture
    // Manually set tab bar to hidden if gesture was cancelled
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = navigationController.topViewController.transitionCoordinator;
    [transitionCoordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if ([context isCancelled] && self.allowTabBarRequiredCancellation) {
            self.tabNavigationBar.tabBarRequired = NO;
            [self.tabNavigationBar setNeedsLayout];
        }
    }];
}
#endif

#pragma mark - Scroll View delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [super scrollViewWillBeginDragging:scrollView];
    self.tabBarView.userInteractionEnabled = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        self.tabBarView.userInteractionEnabled = YES;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.tabBarView.userInteractionEnabled = YES;
}

@end


