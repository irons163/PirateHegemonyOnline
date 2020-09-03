//
//  IRPageViewController.m
//  IRTabbedPageViewController
//
//  Created by Phil on 2019/7/12.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRPageViewController.h"
#import "IRPageViewController+Private.h"
#import <objc/runtime.h>

NSInteger const IRPageViewControllerPageNumberInvalid = -1;

@implementation UIViewController (IRPageViewController)

- (void)setPageViewController:(IRPageViewController *)pageViewController {
    objc_setAssociatedObject(self,
                             @selector(pageViewController),
                             pageViewController,
                             OBJC_ASSOCIATION_ASSIGN);
}

- (IRPageViewController *)pageViewController {
    return objc_getAssociatedObject(self, @selector(pageViewController));
}

- (void)setPageIndex:(NSInteger)pageIndex {
    objc_setAssociatedObject(self,
                             @selector(pageIndex),
                             @(pageIndex),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)pageIndex {
    return [objc_getAssociatedObject(self, @selector(pageIndex))integerValue];
}

@end


@interface IRPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate> {
    BOOL _viewHasLoaded;
}

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, assign) CGFloat previousPagePosition;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL scrollUpdatesEnabled;

@end

@implementation IRPageViewController

@synthesize dataSource = _dataSource,
            delegate = _delegate,
            defaultPageIndex = _defaultPageIndex;

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    _provideOutOfBoundsUpdates = YES;
    _showPageIndicator = NO;
    _allowScrollViewUpdates = YES;
    _scrollUpdatesEnabled = YES;
    _infiniteScrollEnabled = NO;
    _currentPage = IRPageViewControllerPageNumberInvalid;
}

#pragma mark - Lifecycle

- (void)loadView {
    [super loadView];
    
    if (!_pageViewController) {
        self.pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                 navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                               options:nil];
        self.pageViewController.dataSource = self;
        self.pageViewController.delegate = self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewHasLoaded = YES;
    
    [self.pageViewController IR_addToParentViewController:self edgeInsets:self.edgeInsets atZIndex:0];
    self.scrollView.delegate = self;
    
    [self setUpPages];
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets {
    _edgeInsets = edgeInsets;
    [self.pageViewController IR_addToParentViewController:self edgeInsets:self.edgeInsets atZIndex:0];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    // disable scroll updates during rotation
    self.scrollUpdatesEnabled = NO;
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.scrollUpdatesEnabled = YES;
    }];
}

#pragma mark - Public

- (void)moveToPageAtIndex:(NSInteger)index {
    [self moveToPageAtIndex:index completion:nil];
}

- (void)moveToPageAtIndex:(NSInteger)index
               completion:(void (^)(UIViewController *, BOOL, BOOL))completion {
    [self moveToPageAtIndex:index animated:YES completion:completion];
}

- (void)moveToPageAtIndex:(NSInteger)index
                 animated:(BOOL)animated
               completion:(IRPageViewControllerPageMoveCompletion)completion {
    
    if (index != self.currentPage && !self.isAnimatingPageUpdate) {
        _animatingPageUpdate = YES;
        self.view.userInteractionEnabled = NO;
        
        BOOL isForwards = index > self.currentPage;
        if (self.infiniteScrollEnabled &&
            self.infiniteScrollPagingBehaviour == IRPageViewControllerInfinitePagingBehaviorStandard) {
            if (index == 0 && self.currentPage == self.viewControllers.count - 1) { // moving to first page
                isForwards = YES;
            } else if (index == self.viewControllers.count - 1 && self.currentPage == 0) { // moving to last page
                isForwards = NO;
            }
        }
        
        UIViewController *viewController = [self viewControllerAtIndex:index];
        UIPageViewControllerNavigationDirection direction = isForwards ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
        
        typeof(self) __weak weakSelf = self;
        [self.pageViewController setViewControllers:@[viewController]
                                          direction:direction
                                           animated:animated
                                         completion:^(BOOL finished) {
                                             typeof(weakSelf) __strong strongSelf = weakSelf;
                                             [strongSelf updateCurrentPage:index];
                                             if (completion) {
                                                 completion(viewController, animated, finished);
                                             }
                                         }];
    } else {
        if (completion) {
            completion(nil, NO, NO);
        }
    }
}

- (BOOL)isDragging {
    return self.scrollView.isDragging;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    self.scrollView.scrollEnabled = scrollEnabled;
}

- (BOOL)isScrollEnabled {
    return self.scrollView.scrollEnabled;
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    self.pageViewController.view.userInteractionEnabled = userInteractionEnabled;
}

- (BOOL)userInteractionEnabled {
    return self.pageViewController.view.userInteractionEnabled;
}

- (void)setDataSource:(id<IRPageViewControllerDataSource>)dataSource {
    if (_viewHasLoaded && dataSource != self.dataSource) {
        _dataSource = dataSource;
        [self setUpPages];
    }
}

- (id<IRPageViewControllerDataSource>)dataSource {
    if (_dataSource) {
        return _dataSource;
    }
    return self;
}

- (id<IRPageViewControllerDelegate>)delegate {
    if (_delegate) {
        return _delegate;
    }
    return self;
}

- (NSInteger)defaultPageIndex {
    if (_defaultPageIndex == 0 && [self.dataSource respondsToSelector:@selector(defaultPageIndexForPageViewController:)]) {
        _defaultPageIndex = [self.dataSource defaultPageIndexForPageViewController:self];
    }
    return _defaultPageIndex;
}

#pragma mark - Internal

- (void)setUpPages {
    
    // view controllers
    if ([self.dataSource respondsToSelector:@selector(viewControllersForPageViewController:)]) {
        _viewControllers = [self.dataSource viewControllersForPageViewController:self];
    }
    
    if (self.viewControllers.count > 0) {
        [self setUpViewControllers:self.viewControllers];
        
        _numberOfPages = self.viewControllers.count;
        _currentPage = self.defaultPageIndex;
        
        if ([self.delegate respondsToSelector:@selector(pageViewController:didPrepareViewControllers:)]) {
            [self.delegate pageViewController:self didPrepareViewControllers:self.viewControllers];
        }
        
        // display initial page
        UIViewController *viewController = [self viewControllerAtIndex:self.currentPage];
        if ([self.delegate respondsToSelector:@selector(pageViewController:willDisplayInitialViewController:)]) {
            [self.delegate pageViewController:self willDisplayInitialViewController:viewController];
        }
        [self.pageViewController setViewControllers:@[viewController]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:nil];
        self.scrollView.userInteractionEnabled = YES;
        
    } else {
        self.scrollView.userInteractionEnabled = NO; // disable scroll view if no pages
    }
}

- (void)setUpViewControllers:(NSArray *)viewControllers {
    NSInteger index = 0;
    for (UIViewController *viewController in viewControllers) {
        viewController.pageViewController = self;
        viewController.pageIndex = index;
        [self setUpViewController:viewController
                            index:index];
        
        index++;
    }
}

- (void)setUpViewController:(UIViewController *)viewController
                      index:(NSInteger)index {
    
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index {
    if (index < self.viewControllers.count) {
        return self.viewControllers[index];
    }
    return nil;
}

- (NSInteger)indexOfViewController:(UIViewController *)viewController {
    if (self.viewControllers.count > 0) {
        return [self.viewControllers indexOfObject:viewController];
    }
    return NSNotFound;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        for (UIView *subview in self.pageViewController.view.subviews) {
            if ([subview isKindOfClass:[UIScrollView class]]) {
                _scrollView = (UIScrollView *)subview;
                break;
            }
        }
    }
    return _scrollView;
}

- (void)updateCurrentPage:(NSInteger)currentPage {
    if (currentPage == self.currentPage) {
        return;
    }
    
    if (self.infiniteScrollEnabled) {
        if (currentPage >= self.numberOfPages) {
            currentPage = 0;
        } else if (currentPage < 0) {
            currentPage = self.numberOfPages - 1;
        }
    }
    
    // has reached page
    _animatingPageUpdate = NO;
    self.view.userInteractionEnabled = YES;
    
    if (currentPage >= 0 && currentPage < self.numberOfPages) {
        _currentPage = currentPage;
        if ([self.delegate respondsToSelector:@selector(pageViewController:didScrollToPage:)]) {
            [self.delegate pageViewController:self didScrollToPage:self.currentPage];
        }
    }
}

#pragma mark - Scroll View delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _animatingPageUpdate = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = scrollView.frame.size.width;
    CGFloat scrollOffset = (scrollView.contentOffset.x - pageWidth);
    
    CGFloat currentXOffset = (self.currentPage * pageWidth) + scrollOffset;
    CGFloat currentPagePosition = currentXOffset / pageWidth;
    IRPageViewControllerScrollDirection direction =
    currentPagePosition > _previousPagePosition ?
    IRPageViewControllerScrollDirectionForward : IRPageViewControllerScrollDirectionBackward;
    
    // check if reached a page as page view controller delegate does not report reliably
    // occurs when scrollview is continuously dragged
    if (!self.isAnimatingPageUpdate && scrollView.isDragging) {
        if (direction == IRPageViewControllerScrollDirectionForward && currentPagePosition >= self.currentPage + 1) {
            [self updateCurrentPage:self.currentPage + 1];
            return; // ignore update if we've changed page
        } else if (direction == IRPageViewControllerScrollDirectionBackward && currentPagePosition <= self.currentPage - 1) {
            [self updateCurrentPage:self.currentPage - 1];
            return;
        }
    }
    
    if (currentPagePosition != self.previousPagePosition) {
        
        CGFloat minPagePosition = 0.0f;
        CGFloat maxPagePosition = (self.viewControllers.count - 1);
        
        // limit updates if out of bounds updates are disabled
        // updates will be limited to min of 0 and max of number of pages
        BOOL outOfBounds = currentPagePosition < minPagePosition || currentPagePosition > maxPagePosition;
        if (outOfBounds) {
            if (self.infiniteScrollEnabled) {
                
                double integral;
                CGFloat progress = modf(fabs(currentPagePosition), &integral); // calculate transition progress
                CGFloat infiniteMaxPosition;
                if (currentPagePosition > 0) { // upper boundary - going to first page
                    progress = 1.0f - progress;
                    infiniteMaxPosition = minPagePosition;
                } else { // lower boundary - going to max page
                    infiniteMaxPosition = maxPagePosition;
                }
                
                // calculate relative position on overall transition
                CGFloat infinitePagePosition = (maxPagePosition - minPagePosition) * progress;
                if ((fmod(progress, 1.0) == 0.0)) {
                    infinitePagePosition = infiniteMaxPosition;
                }
                
                currentPagePosition = infinitePagePosition;
                
            } else if (!self.provideOutOfBoundsUpdates) {
                currentPagePosition = MAX(0.0f, MIN(currentPagePosition, self.numberOfPages - 1));
            }
        }
        
        // check whether updates are allowed
        if (self.scrollUpdatesEnabled && self.allowScrollViewUpdates) {
            if ([self.delegate respondsToSelector:@selector(pageViewController:didScrollToPageOffset:direction:)]) {
                [self.delegate pageViewController:self
                            didScrollToPageOffset:currentPagePosition
                                        direction:direction];
            }
        }
        
        _previousPagePosition = currentPagePosition;
    }
}

#pragma mark - Page View Controller data source

- (UIViewController *)pageViewController:(IRPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger currentIndex = [self indexOfViewController:viewController];
    NSInteger nextIndex = currentIndex;
    
    if (nextIndex != NSNotFound) {
        if (nextIndex != (self.viewControllers.count - 1)) { // standard increment
            nextIndex++;
        } else if (self.infiniteScrollEnabled) { // end of pages - reset to first if infinite scrolling
            nextIndex = 0;
        }
        if (nextIndex != currentIndex) {
            return [self viewControllerAtIndex:nextIndex];
        }
    }
    return nil;
}

- (UIViewController *)pageViewController:(IRPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger currentIndex = [self indexOfViewController:viewController];
    NSInteger nextIndex = currentIndex;
    
    if (nextIndex != NSNotFound) {
        if (nextIndex != 0) { // standard decrement
            nextIndex--;
        } else if (self.infiniteScrollEnabled) { // first index - reset to end if infinite scrolling
            nextIndex = (self.viewControllers.count - 1);
        }
        if (nextIndex != currentIndex) {
            return [self viewControllerAtIndex:nextIndex];
        }
    }
    return nil;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    if (self.showPageIndicator) {
        return self.numberOfPages;
    }
    return 0;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    if (self.showPageIndicator) {
        return self.currentPage;
    }
    return 0;
}

#pragma mark - Page View Controller delegate

- (void)pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    
    if ([self.delegate respondsToSelector:@selector(pageViewController:willScrollToPage:currentPage:)]) {
        NSInteger currentPage = self.currentPage;
        NSInteger nextPage = [self indexOfViewController:pendingViewControllers.firstObject];
        
        [self.delegate pageViewController:self
                         willScrollToPage:nextPage
                              currentPage:currentPage];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    
    if (completed) {
        NSInteger index = [self indexOfViewController:pageViewController.viewControllers.firstObject];
        if (index != NSNotFound) {
            [self updateCurrentPage:index];
        }
    }
}

#pragma mark - IRPageViewController data source

- (NSArray *)viewControllersForPageViewController:(IRPageViewController *)pageViewController {
    return nil;
}

@end
