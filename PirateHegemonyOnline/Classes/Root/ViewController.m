//
//  ViewController.m
//  PirateHegemonyOnline
//
//  Created by irons on 2020/9/3.
//  Copyright © 2020 irons163. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"
#import "ArmsDisplayCollectionViewController.h"
#import "RootTabButton.h"
#import "UIColor+Helper.h"
#import "Utilities.h"
#import <IRSingleButtonGroup/IRSingleButtonGroup.h>
#import <Masonry/Masonry.h>

@interface ViewController ()<IRSingleButtonGroupDelegate, IRTabbedPageViewControllerDelegate> {
    IRTabBarView* tabBarView;
    IRSingleButtonGroup* singleButtonGroup;
//    NSInteger checkCounter;
//    NSTimer* checkTimer;
//    NSURL* currentFilePath;
}

@property (nonatomic, strong) IRTabControllerStyle *style;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    self.tabbedDelegate = self;
    
    if(!self.tabBarView){
//        tabBarView = [[MSSTabBarView alloc] initWithFrame:CGRectMake(0, 0, 140, 55)];
        tabBarView = [[IRTabBarView alloc] init];
        [self.view addSubview:tabBarView];
        CGFloat barHeight = 55;
        [tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.top.equalTo(self.mas_bottomLayoutGuideTop).mas_offset(-barHeight);
        }];
        self.tabBarView = tabBarView;
        self.tabBarView.dataSource = self;
        self.tabBarView.delegate = self;
        self.tabBarView.hidden = NO;
        
        UIView *tabBackgroundView = [UIView new];
        tabBackgroundView.backgroundColor = UIColor.blueColor;
        [self.view insertSubview:tabBackgroundView belowSubview:self.tabBarView];
        [tabBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.tabBarView);
            make.width.mas_equalTo(self.view);
        }];
    }
    
    _style = [IRTabControllerStyle styleWithName:@"Default"
                                      tabStyle:IRTabStyleCustomView
                                   sizingStyle:IRTabSizingStyleDistributed
                                  numberOfTabs:2];
    
    [self.tabBarView setTransitionStyle:self.style.transitionStyle];
    self.tabBarView.tabStyle = self.style.tabStyle;
    self.tabBarView.sizingStyle = self.style.sizingStyle;
    self.tabBarView.tabPadding = 0;
    self.tabBarView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tabBarView.backgroundColor = [UIColor colorWithColorCodeString:@"DDDDDD"];
    self.tabBarView.allowsSelection = NO;
    self.tabBarView.sizeToFitAlginStyle = IRSizeToFitAlginCenterWithCells;
    
    self.tabBarView.tabAttributes = @{IRTabTransitionAlphaEffectEnabled : @NO};
    
    self.tabBarView.indicatorAttributes = @{IRTabIndicatorLineHeight : [NSNumber numberWithInteger:0]};
    
    singleButtonGroup = [[IRSingleButtonGroup alloc] init];
    singleButtonGroup.delegate = self;
    
    NSMutableArray *tabButtons = [NSMutableArray array];
    RootTabButton* apTabButton = [RootTabButton buttonWithType:UIButtonTypeCustom];
    [apTabButton setTitle:@"Home" forState:UIControlStateNormal];
    UIImage *homeIcon = [Utilities imageWithImage:[UIImage imageNamed:@"catapult"] scaledToSize:CGSizeMake(20, 20)];
    [apTabButton setImage:homeIcon forState:UIControlStateNormal];
    [apTabButton addTarget:self action:@selector(tabButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [tabButtons addObject:apTabButton];
    
    
    RootTabButton* enSkyTabButton = [RootTabButton buttonWithType:UIButtonTypeCustom];
    [enSkyTabButton setTitle:@"Arm" forState:UIControlStateNormal];
    [enSkyTabButton setImage:homeIcon forState:UIControlStateNormal];
    [enSkyTabButton addTarget:self action:@selector(tabButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [tabButtons addObject:enSkyTabButton];
    
    singleButtonGroup.buttons = [NSArray arrayWithArray:tabButtons];
//    [singleButtonGroup selected:singleButtonGroup.buttons[self.currentPage < 0 ? 0 : self.currentPage]];
    [singleButtonGroup setInitSelected:singleButtonGroup.buttons[self.currentPage < 0 ? 0 : self.currentPage]];
}

#pragma mark - IRPageViewControllerDataSource

- (NSArray *)viewControllersForPageViewController:(IRPageViewController *)pageViewController {
    HomeViewController *homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    UINavigationController* navigationHomeViewController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    
    ArmsDisplayCollectionViewController *armsDisplayCollectionViewController = [[ArmsDisplayCollectionViewController alloc] initWithNibName:@"ArmsDisplayCollectionViewController" bundle:nil];
    UINavigationController* navigationArmsDisplayCollectionViewController = [[UINavigationController alloc] initWithRootViewController:armsDisplayCollectionViewController];
    
    NSArray *childViewControllers;
    childViewControllers = [[NSArray alloc]initWithObjects: navigationHomeViewController, navigationArmsDisplayCollectionViewController, nil];
    
    return childViewControllers;
}

#pragma mark - IRTabBarViewDataSource

- (void)tabBarView:(IRTabBarView *)tabBarView populateTab:(IRTabBarCollectionViewCell *)tab atIndex:(NSInteger)index {
    if(singleButtonGroup.buttons){
        tab.customView = singleButtonGroup.buttons[index];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tabBarView.backgroundColor = [UIColor clearColor];
        });
    }
}

#pragma mark - IRTabBarViewDelegate
- (void)tabBarView:(nonnull IRTabBarView *)tabBarView tabSelectedAtIndex:(NSInteger)index {
    [super tabBarView:tabBarView tabSelectedAtIndex:index];
    
    if ([[self viewControllers][index] isKindOfClass:[UINavigationController class]])
    {
        [(UINavigationController *)[self viewControllers][index] popToRootViewControllerAnimated:NO];
    }
}

- (void)tabBarView:(IRTabBarView *)tabBarView populateTab:(IRTabBarCollectionViewCell *)tab tabWillSelectAtIndex:(NSInteger)index {
    UIButton *willSelectTabButton = singleButtonGroup.buttons[index];
    [singleButtonGroup setInitSelected:willSelectTabButton];
}

- (void)gotLogoutNotification
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)tabButtonClick:(UIButton*)sender {
    [singleButtonGroup selected:sender];
}

#pragma mark - UITabBarControllerDelegate
-(void)ir_tabbedController:(IRTabbedPageViewControllerImp *)tabbedPageViewController didSelectIndex:(NSInteger)index {
    [tabbedPageViewController.tabBarView setTabIndex:index animated:YES];
}

#pragma mark - SingleButtonGroupDelegate

- (void)didSelectedButton:(UIButton *)button {
    [self.tabBarView setTabSelected:[singleButtonGroup.buttons indexOfObject:button] animated:YES];
}

- (void)didDeselectedButton:(UIButton *)button {
    
}

@end
