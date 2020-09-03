//
//  IRTabNavigationBar.m
//  IRTabbedPageViewController
//
//  Created by Phil on 2019/7/12.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRTabNavigationBar.h"
#import "IRTabNavigationBar+Private.h"

CGFloat const kIRTabNavigationBarLayoutParameterInvalid = -1.0f;
CGFloat const kIRTabNavigationBarBottomPadding = 4.0f;

@interface IRTabNavigationBar () <IRTabBarViewDelegate, IRTabBarViewDataSource>

@property (nonatomic, weak) IRTabbedPageViewController *activeTabbedPageViewController;

@end

@implementation IRTabNavigationBar

@synthesize tabBarHeight = _tabBarHeight;
@synthesize tabBarBottomPadding = _tabBarBottomPadding;

#pragma mark - Init

- (void)baseInit {
    [super baseInit];
    
    _tabBarHeight = kIRTabNavigationBarLayoutParameterInvalid;
    _tabBarBottomPadding = kIRTabNavigationBarLayoutParameterInvalid;
    
    IRTabBarView *tabBarView = [IRTabBarView new];
    tabBarView.dataSource = self;
    tabBarView.delegate = self;
    tabBarView.tintColor = self.tintColor;
    [self addSubview:tabBarView];
    _tabBarView = tabBarView;
    
    self.tabBarRequired = self.tabBarRequired;
}

#pragma mark - Lifecycle

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat tabBarHeight = [self heightIncreaseValue] - self.tabBarBottomPadding;
    CGFloat yOffset = self.heightIncreaseRequired ? 0.0f : -[self heightIncreaseValue]; // offset y if tab hidden to animate up
    
    self.tabBarView.frame = CGRectMake(0.0f,
                                       self.bounds.size.height + yOffset,
                                       self.bounds.size.width,
                                       tabBarHeight);
}

- (CGFloat)heightIncreaseValue {
    return self.tabBarHeight + self.tabBarBottomPadding;
}

- (BOOL)heightIncreaseRequired {
    return self.tabBarRequired;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (CGRectContainsPoint(self.tabBarView.frame, point) && self.tabBarView.userInteractionEnabled && self.tabBarRequired) {
        CGPoint tabBarPoint = [self.tabBarView convertPoint:point fromView:self];
        return [self.tabBarView hitTest:tabBarPoint withEvent:event];
    }
    
    UIView *hitView = [super hitTest:point withEvent:event];
    return hitView;
}

#pragma mark - Public

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    self.tabBarView.tintColor = tintColor;
}

- (void)setTitleTextAttributes:(NSDictionary<NSString *,id> *)titleTextAttributes {
    [super setTitleTextAttributes:titleTextAttributes];
    
    UIColor *foregroundColor = nil;
    if ((foregroundColor = titleTextAttributes[NSForegroundColorAttributeName])) {
        NSMutableDictionary *tabAttributes = self.tabBarView.tabAttributes ?
        [NSMutableDictionary dictionaryWithDictionary:self.tabBarView.tabAttributes] : [NSMutableDictionary new];
        [tabAttributes setObject:foregroundColor forKey:NSForegroundColorAttributeName];
        self.tabBarView.tabAttributes = tabAttributes;
    }
}

- (void)setTabBarHeight:(CGFloat)tabBarHeight {
    _tabBarHeight = tabBarHeight;
    [self setNeedsLayout];
}

- (CGFloat)tabBarHeight {
    if (_tabBarHeight == kIRTabNavigationBarLayoutParameterInvalid) {
        return IRTabBarViewDefaultHeight;
    }
    return _tabBarHeight;
}

- (void)setTabBarBottomPadding:(CGFloat)tabBarBottomPadding {
    _tabBarBottomPadding = tabBarBottomPadding;
    [self setNeedsLayout];
}

- (CGFloat)tabBarBottomPadding {
    if (_tabBarBottomPadding == kIRTabNavigationBarLayoutParameterInvalid) {
        return kIRTabNavigationBarBottomPadding;
    }
    return _tabBarBottomPadding;
}

#pragma mark - Private

- (void)tabbedPageViewController:(IRTabbedPageViewController *)tabbedPageViewController viewWillAppear:(BOOL)animated isInitial:(BOOL)isInitial {
    _activeTabbedPageViewController = tabbedPageViewController;
    
    [self setOffsetTransformRequired:isInitial];
    [self setTabBarRequired:YES animated:animated];
}

- (void)tabbedPageViewController:(IRTabbedPageViewController *)tabbedPageViewController viewWillDisappear:(BOOL)animated {
    if (tabbedPageViewController == self.activeTabbedPageViewController) {
        [self setTabBarRequired:NO animated:animated];
    }
}

- (void)setTabBarRequired:(BOOL)tabBarRequired {
    _tabBarRequired = tabBarRequired;
    self.tabBarView.alpha = tabBarRequired;
    self.tabBarView.userInteractionEnabled = tabBarRequired;
}

#pragma mark - Internal

- (void)setTabBarRequired:(BOOL)required animated:(BOOL)animated {
    if (self.tabBarRequired != required) {
        
        // show or hide tab bar view
        void (^tabVisiblityBlock)() = ^void() {
            self.tabBarRequired = required;
            [self layoutIfNeeded];
        };
        
        if (animated) {
            [UIView animateWithDuration:0.3f animations:^{
                tabVisiblityBlock();
            }];
        } else {
            tabVisiblityBlock();
        }
    }
}

#pragma mark - Tab Bar data source

- (NSInteger)numberOfItemsForTabBarView:(IRTabBarView *)tabBarView {
    return 0;
}

- (void)tabBarView:(IRTabBarView *)tabBarView
       populateTab:(IRTabBarCollectionViewCell *)tab
           atIndex:(NSInteger)index {
    
}

@end

