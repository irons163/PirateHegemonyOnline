//
//  ArmsDisplayCollectionViewController.m
//  PirateHegemonyOnline
//
//  Created by irons on 2020/9/4.
//  Copyright © 2020 irons163. All rights reserved.
//

#import "ArmsDisplayCollectionViewController.h"
#import "ArmsDisplayViewModel.h"
#import "DrawCardViewController.h"
#import "DBManager.h"
#import "AppDelegate.h"

@interface ArmsDisplayCollectionViewController ()

@property ArmsDisplayViewModel *viewModel;
@property NSArray *arms;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ArmsDisplayCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    _arms = [[DBManager sharedInstance] getAllArms];
    _viewModel = [[ArmsDisplayViewModel alloc] initWithCollectionView:_collectionView];
    _viewModel.arms = _arms;
    
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(0, 0, 10, 0);
    _collectionView.dataSource = _viewModel;
    [_viewModel update];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _arms = [[DBManager sharedInstance] getAllArms];
    _viewModel.arms = _arms;
    [_viewModel update];
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellsAcross = 4;
    CGFloat spaceBetweenCells = 2;
    CGFloat cellProperWidth = (collectionView.bounds.size.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross;
    return CGSizeMake(cellProperWidth, cellProperWidth);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    int position = 0;
    position += indexPath.row;
    
    Arm *arm = _arms[position];
    
    DrawCardViewController *drawCardViewController = [[DrawCardViewController alloc] init];
    drawCardViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
    drawCardViewController.displayArm = arm;
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.window.rootViewController presentViewController:drawCardViewController animated:YES completion:nil];
}

@end
