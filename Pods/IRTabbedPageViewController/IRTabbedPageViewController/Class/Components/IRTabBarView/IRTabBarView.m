//
//  IRTabBarView.m
//  IRTabbedPageViewController
//
//  Created by Phil on 2019/7/12.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "IRTabBarView.h"
#import "IRTabBarView+Private.h"
#import "UIView+IRAutoLayout.h"
#import "IRTabBarCollectionViewCell+Private.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

NSString *  const IRTabBarViewCellIdentifier = @"tabCell";

// defaults
CGFloat     const IRTabBarViewDefaultHeight = 44.0f;
CGFloat     const IRTabBarViewDefaultTabIndicatorHeight = 2.0f;
CGFloat     const IRTabBarViewDefaultTabPadding = 0.0f;
CGFloat     const IRTabBarViewDefaultTabUnselectedAlpha = 0.3f;
CGFloat     const IRTabBarViewDefaultHorizontalContentInset = 0.0f;
NSString *  const IRTabBarViewDefaultTabTitleFormat = @"Tab %li";
BOOL        const IRTabBarViewDefaultScrollEnabled = NO;

NSInteger   const IRTabBarViewMaxDistributedTabs = 5;
CGFloat     const IRTabBarViewTabTransitionSnapRatio = 0.5f;

CGFloat     const IRTabBarViewTabOffsetInvalid = -1.0f;

@interface IRTabBarView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *tabTitles;
@property (nonatomic, assign) NSInteger tabCount;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) IRTabBarCollectionViewCell *selectedCell;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) UIView *indicatorContainer;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, assign) CGFloat lineIndicatorHeight;
@property (nonatomic, assign) CGFloat lineIndicatorInset;

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat previousTabOffset;
@property (nonatomic, assign) NSInteger defaultTabIndex;

@property (nonatomic, assign) CGFloat tabDeselectedAlpha;

@property (nonatomic, assign) BOOL hasRespectedDefaultTabIndex;

@property (nonatomic, assign) BOOL animateDataSourceTransition;

@property (nonatomic, strong) NSMutableDictionary *cellsWidth;

@end

static IRTabBarCollectionViewCell *_sizingCell;

@implementation IRTabBarView

#pragma mark - Init

- (instancetype)init {
    if (self = [super init]) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if ([super initWithCoder:coder]) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithHeight:(CGFloat)height {
    if (self = [super init]) {
        _height = height;
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    
    // General
    _tabPadding = IRTabBarViewDefaultTabPadding;
    CGFloat horizontalInset = IRTabBarViewDefaultHorizontalContentInset;
    _contentInset = UIEdgeInsetsMake(0.0f, horizontalInset, 0.0f, horizontalInset);
    _tabOffset = IRTabBarViewTabOffsetInvalid;
    
    if (_height == 0.0f) {
        _height = IRTabBarViewDefaultHeight;
    }
    
    // Collection view
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = _tabPadding;
    layout.minimumLineSpacing = 0;
    layout.headerReferenceSize = CGSizeZero;
    //    layout.itemSize = UICollectionViewFlowLayoutAutomaticSize;
    layout.estimatedItemSize = CGSizeZero;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    //    _collectionView.viewRespectsSystemMinimumLayoutMargins
    //    _collectionView.preservesSuperviewLayoutMargins = NO;
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    self.scrollEnabled = IRTabBarViewDefaultScrollEnabled;
    _tabTextColor = [UIColor blackColor];
    
    // Tab indicator
    _indicatorContainer = [UIView new];
    _indicatorStyle = IRIndicatorStyleLine;
    _indicatorContainer.userInteractionEnabled = NO;
    _indicatorAttributes = @{IRTabIndicatorLineHeight : @(IRTabBarViewDefaultTabIndicatorHeight),
                             NSForegroundColorAttributeName : self.tintColor};
    
    _cellsWidth = [NSMutableDictionary dictionary];
    
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //        _collectionView.adjustedContentInset = UIEdgeInsetsZero;
    }
}

#pragma mark - Lifecycle

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (!self.collectionView.superview) {
        
        // create sizing cell if required
        UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([IRTabBarCollectionViewCell class])
                                        bundle:[NSBundle bundleForClass:[IRTabBarCollectionViewCell class]]];
        [self.collectionView registerNib:cellNib
              forCellWithReuseIdentifier:IRTabBarViewCellIdentifier];
        if (!_sizingCell) {
            _sizingCell = [[cellNib instantiateWithOwner:self options:nil]objectAtIndex:0];
        }
        
        // collection view
        [self IR_addExpandingSubview:self.collectionView];
        self.collectionView.contentInset = self.contentInset;
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.showsHorizontalScrollIndicator = NO;
    }
    
    if (!self.indicatorContainer.superview) {
        [self.collectionView addSubview:self.indicatorContainer];
        [self updateIndicatorForStyle:self.indicatorStyle];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateTabBarForTabIndex:self.tabOffset];
    
    _collectionView.layoutMargins = UIEdgeInsetsZero;
    if (@available(iOS 11.0, *)) {
        _collectionView.directionalLayoutMargins = NSDirectionalEdgeInsetsZero;
    }
    
    // if default tab has not yet been displayed
    if (self.tabCount > 0 && !self.selectedCell) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.defaultTabIndex inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:self.animateDataSourceTransition];
    }
}

#pragma mark - Collection View data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    [_cellsWidth removeAllObjects];
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return [self evaluateDataSource];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    IRTabBarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IRTabBarViewCellIdentifier
                                                                                  forIndexPath:indexPath];
    [self updateCellAppearance:cell];
    
    // default contents
    cell.tabStyle = self.tabStyle;
    cell.title = [self titleAtIndex:indexPath.row];
    
    // populate cell
    if ([self.dataSource respondsToSelector:@selector(tabBarView:populateTab:atIndex:)]) {
        [self.dataSource tabBarView:self populateTab:cell atIndex:indexPath.item];
    }
    
    cell.selectionProgress = self.tabDeselectedAlpha;
    
    if ((!self.hasRespectedDefaultTabIndex && indexPath.row == self.defaultTabIndex) ||
        ([self.selectedIndexPath isEqual:indexPath] && self.tabOffset == IRTabBarViewTabOffsetInvalid)) {
        _hasRespectedDefaultTabIndex = YES;
        [self setTabCellActive:cell indexPath:indexPath];
    }
    
    return cell;
}

#pragma mark - Collection View delegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewFlowLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize cellSize = CGSizeZero;
    
    if (self.sizingStyle == IRTabSizingStyleDistributed && self.tabCount <= IRTabBarViewMaxDistributedTabs) { // distributed in frame
        
        CGFloat contentInsetTotal = self.contentInset.left + self.contentInset.right;
        CGFloat totalSpacing = collectionViewLayout.minimumInteritemSpacing * (self.tabCount - 1);
        CGFloat totalWidth = collectionView.bounds.size.width - contentInsetTotal - totalSpacing;
        
        [_cellsWidth setValue:@(totalWidth / self.tabCount) forKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
        
        return CGSizeMake(totalWidth / self.tabCount, collectionView.bounds.size.height);
        
    } else { // wrap tab contents
        
        // update sizing cell with population
        if ([self.dataSource respondsToSelector:@selector(tabBarView:populateTab:atIndex:)]) {
            [self.dataSource tabBarView:self populateTab:_sizingCell atIndex:indexPath.item];
        } else  {
            _sizingCell.title = [self titleAtIndex:indexPath.row];
        }
        
        CGSize requiredSize = [_sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize
                                                     withHorizontalFittingPriority:UILayoutPriorityFittingSizeLevel
                                                           verticalFittingPriority:UILayoutPriorityFittingSizeLevel];
        requiredSize.width += self.tabPadding;
        cellSize = requiredSize;
    }
    
    [_cellsWidth setValue:@(cellSize.width) forKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
    
    return cellSize;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(tabBarView:tabSelectedAtIndex:)]) {
        [self.delegate tabBarView:self tabSelectedAtIndex:indexPath.row];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    NSInteger cellCount = [collectionView.dataSource collectionView:collectionView numberOfItemsInSection:section];
    if( cellCount >0 )
    {
        //        CGFloat cellWidth = ((UICollectionViewFlowLayout*)collectionViewLayout).itemSize.width+((UICollectionViewFlowLayout*)collectionViewLayout).minimumInteritemSpacing;
        //        CGFloat totalCellWidth = cellWidth*cellCount + spacing*(cellCount-1);
        //        CGFloat cellWidth = ((UICollectionViewFlowLayout*)collectionViewLayout).itemSize.width;
        //        NSInteger itemsNumber = [collectionView numberOfItemsInSection:section];
        //        for (int i = 0; i < itemsNumber; i++) {
        //
        //        }
        
        CGFloat cellsWidth = 0;
        for (NSNumber* width in _cellsWidth.allValues) {
            cellsWidth += [width floatValue];
        }
        
        CGFloat spacing = ((UICollectionViewFlowLayout*)collectionViewLayout).minimumInteritemSpacing;
        CGFloat totalCellWidth = cellsWidth + spacing*(cellCount-1);
        CGFloat contentWidth = collectionView.frame.size.width-collectionView.contentInset.left-collectionView.contentInset.right;
        
        if( totalCellWidth<contentWidth ) {
            if (self.sizeToFitAlginStyle == IRSizeToFitAlginCenterWithCells) {
                CGFloat padding = (contentWidth - totalCellWidth) / 2.0;
                return UIEdgeInsetsMake(0, padding, 0, padding);
            } else {
                CGFloat centerMiddleCell = 0;
                int counter = 0;
                CGFloat spacing = ((UICollectionViewFlowLayout*)collectionViewLayout).minimumInteritemSpacing;
                for (NSNumber* width in _cellsWidth.allValues) {
                    counter++;
                    if (counter <= [_cellsWidth.allValues count] / 2) {
                        centerMiddleCell += [width floatValue];
                        centerMiddleCell += spacing;
                    } else {
                        if ([_cellsWidth.allValues count] % 2 == 0) {
                            centerMiddleCell -= spacing / 2;
                        } else {
                            centerMiddleCell += [width floatValue] / 2;
                        }
                        break;
                    }
                }
                
                CGFloat padding = (contentWidth / 2.0 - centerMiddleCell) ;
                return UIEdgeInsetsMake(0, padding, 0, 0);
            }
        }
        
        
        
    }
    return UIEdgeInsetsZero;
}

#pragma mark - Public

- (void)setTabPadding:(CGFloat)tabPadding {
    _tabPadding = tabPadding;
    ((UICollectionViewFlowLayout*)_collectionView.collectionViewLayout).minimumInteritemSpacing = _tabPadding;
    [self reloadData];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    
    // add selection indicator height to bottom of collection view inset
    CGFloat indicatorHeight;
    if (self.indicatorAttributes) {
        indicatorHeight = [self.indicatorAttributes[IRTabIndicatorLineHeight]floatValue];
    } else {
        indicatorHeight = self.selectionIndicatorHeight;
    }
    contentInset.bottom += indicatorHeight;
    
    self.collectionView.contentInset = contentInset;
}

- (void)setTabIndex:(NSInteger)index animated:(BOOL)animated {
    if (animated) {
        _animatingTabChange = YES;
        [UIView animateWithDuration:0.25f animations:^{
            [self updateTabBarForTabIndex:index];
        } completion:^(BOOL finished) {
            _animatingTabChange = NO;
        }];
    } else {
        [self updateTabBarForTabIndex:index];
    }
}

- (void)setTabOffset:(CGFloat)offset {
    _previousTabOffset = _tabOffset;
    _tabOffset = offset;
    [self updateTabBarForTabOffset:offset];
}

- (void)setDefaultTabIndex:(NSInteger)defaultTabIndex {
    if (self.tabOffset == IRTabBarViewTabOffsetInvalid) { // only allow default to be set if tab is runtime default
        self.hasRespectedDefaultTabIndex = NO;
        _defaultTabIndex = defaultTabIndex;
    }
}

- (void)setTabIndicatorColor:(UIColor *)tabIndicatorColor {
    _tabIndicatorColor = tabIndicatorColor;
    if (self.indicatorStyle == IRIndicatorStyleLine) {
        self.indicatorView.backgroundColor = tabIndicatorColor;
    }
}

- (void)setSelectionIndicatorHeight:(CGFloat)selectionIndicatorHeight {
    self.lineIndicatorHeight = selectionIndicatorHeight;
}

- (void)setTabTextColor:(UIColor *)tabTextColor {
    _tabTextColor = tabTextColor;
    [self reloadData];
}

- (void)setTabTextFont:(UIFont *)tabTextFont {
    _tabTextFont = tabTextFont;
    [self reloadData];
}

- (void)setTabSelected:(NSInteger) index animated:(BOOL)animated {
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView selectItemAtIndexPath:indexPath animated:animated scrollPosition:UICollectionViewScrollPositionNone];
    [self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
}

- (void)setBackgroundView:(UIView *)backgroundView {
    _backgroundView = backgroundView;
    [self IR_addExpandingSubview:backgroundView];
    [self sendSubviewToBack:backgroundView];
}

- (void)setDataSource:(id<IRTabBarViewDataSource>)dataSource {
    self.animateDataSourceTransition = NO;
    [self doSetDataSource:dataSource];
}

- (void)setDataSource:(id<IRTabBarViewDataSource>)dataSource animated:(BOOL)animated {
    self.animateDataSourceTransition = animated;
    [self doSetDataSource:dataSource];
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    self.collectionView.scrollEnabled = scrollEnabled;
}

- (BOOL)scrollEnabled {
    return self.collectionView.scrollEnabled;
}

- (void)setAllowsSelection:(BOOL)allowsSelection {
    self.collectionView.allowsSelection = allowsSelection;
}

- (BOOL)allowsSelection {
    return self.collectionView.allowsSelection;
}

- (void)setUserScrollEnabled:(BOOL)userScrollEnabled {
    self.scrollEnabled = userScrollEnabled;
}

- (BOOL)userScrollEnabled {
    return self.scrollEnabled;
}

- (void)setSizingStyle:(IRTabSizingStyle)sizingStyle {
    if ((sizingStyle == IRTabSizingStyleDistributed && self.tabCount <= IRTabBarViewMaxDistributedTabs) ||
        sizingStyle == IRTabSizingStyleSizeToFit) {
        _sizingStyle = sizingStyle;
        [self reloadData];
    } else {
        NSLog(@"%@ - Distributed tab spacing is unavailable when using a tab count greater than %li", NSStringFromClass([self class]), (long)IRTabBarViewMaxDistributedTabs);
    }
}

- (void)setTabStyle:(IRTabStyle)tabStyle {
    _tabStyle = tabStyle;
    _sizingCell.tabStyle = tabStyle;
    [self reloadData];
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    self.tabIndicatorColor = tintColor;
}

- (void)setTransitionStyle:(IRTabTransitionStyle)transitionStyle {
    self.selectionIndicatorTransitionStyle = transitionStyle;
    self.tabTransitionStyle = transitionStyle;
}

- (void)setTabAttributes:(NSDictionary<NSString *,id> *)tabAttributes {
    _tabAttributes = tabAttributes;
    [self reloadData];
}

- (void)setSelectionIndicatorTransitionStyle:(IRTabTransitionStyle)selectionIndicatorTransitionStyle {
    self.indicatorTransitionStyle = selectionIndicatorTransitionStyle;
}

- (void)setIndicatorAttributes:(NSDictionary<NSString *,id> *)indicatorAttributes {
    _indicatorAttributes = indicatorAttributes;
    [self updateIndicatorAppearance];
}

- (void)setIndicatorStyle:(IRIndicatorStyle)indicatorStyle {
    if (indicatorStyle != _indicatorStyle) {
        _indicatorStyle = indicatorStyle;
        [self updateIndicatorForStyle:indicatorStyle];
    }
}

- (void)setLineIndicatorHeight:(CGFloat)lineIndicatorHeight {
    if (lineIndicatorHeight != _lineIndicatorHeight) {
        _lineIndicatorHeight = lineIndicatorHeight;
        [self updateIndicatorFrames];
    }
}

#pragma mark - Tab Bar State

- (void)updateTabBarForTabOffset:(CGFloat)tabOffset {
    
    // calculate the percentage progress of the current tab transition
    float integral;
    CGFloat progress = (CGFloat)modff(tabOffset, &integral);
    BOOL isBackwards = !(tabOffset >= self.previousTabOffset);
    
    if (tabOffset <= 0.0f) { // stick at bottom of tab bar
        
        IRTabBarCollectionViewCell *firstTabCell = [self collectionViewCellAtTabIndex:0];
        [self updateTabsWithCurrentTabCell:firstTabCell nextTabCell:firstTabCell progress:1.0f backwards:NO];
        [self updateIndicatorViewWithCurrentTabCell:firstTabCell
                                        nextTabCell:firstTabCell
                                           progress:1.0f];
        
    } else if (tabOffset >= self.tabCount - 1) { // stick at top of tab bar
        
        IRTabBarCollectionViewCell *lastTabCell = [self collectionViewCellAtTabIndex:self.tabCount - 1];
        [self updateTabsWithCurrentTabCell:lastTabCell nextTabCell:lastTabCell progress:1.0f backwards:NO];
        [self updateIndicatorViewWithCurrentTabCell:lastTabCell
                                        nextTabCell:lastTabCell
                                           progress:1.0f];
        
    } else { // update as required
        if (progress != 0.0f) {
            
            // get the current and next tab cells
            NSInteger currentTabIndex = isBackwards ? ceil(tabOffset) : floor(tabOffset);
            NSInteger nextTabIndex = MAX(0, MIN(self.tabCount - 1, isBackwards ? floor(tabOffset) : ceil(tabOffset)));
            
            IRTabBarCollectionViewCell *currentTabCell = [self collectionViewCellAtTabIndex:currentTabIndex];
            IRTabBarCollectionViewCell *nextTabCell = [self collectionViewCellAtTabIndex:nextTabIndex];
            
            // update tab bar components
            if (currentTabCell != nextTabCell && (currentTabCell && nextTabCell)) {
                [self updateTabsWithCurrentTabCell:currentTabCell
                                       nextTabCell:nextTabCell
                                          progress:progress
                                         backwards:isBackwards];
                [self updateIndicatorViewWithCurrentTabCell:currentTabCell
                                                nextTabCell:nextTabCell
                                                   progress:progress];
            }
        } else { // finished update - on a tab cell
            
            NSInteger index = floor(tabOffset);
            IRTabBarCollectionViewCell *selectedCell = [self collectionViewCellAtTabIndex:index];
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:selectedCell];
            
            if (selectedCell && indexPath) {
                [self setTabCellActive:selectedCell indexPath:indexPath];
            }
        }
    }
}

- (void)updateTabBarForTabIndex:(NSInteger)tabIndex {
    IRTabBarCollectionViewCell *cell = [self collectionViewCellAtTabIndex:tabIndex];
    if (cell) {
        if ([self.delegate respondsToSelector:@selector(tabBarView:populateTab:tabWillSelectAtIndex:)]) {
            [self.delegate tabBarView:self populateTab:cell tabWillSelectAtIndex:tabIndex];
        }
        // update tab offsets
        _previousTabOffset = _tabOffset;
        _tabOffset = tabIndex;
        
        // update tab bar cells
        [self setTabCellsInactiveExceptTabIndex:tabIndex];
        [self setTabCellActive:cell indexPath:[NSIndexPath indexPathForItem:tabIndex inSection:0]];
    }
}

- (void)setTabCellsInactiveExceptTabIndex:(NSInteger)index {
    for (NSInteger item = 0; item < self.tabCount; item++) {
        if (item != index) {
            IRTabBarCollectionViewCell *cell = [self collectionViewCellAtTabIndex:item];
            [self setTabCellInactive:cell];
        }
    }
}

- (void)setTabCellActive:(IRTabBarCollectionViewCell *)cell
               indexPath:(NSIndexPath *)indexPath {
    _selectedCell = cell;
    _selectedIndexPath = indexPath;
    
    cell.selectionProgress = 1.0f;
    
    if (self.animateDataSourceTransition) {
        [UIView animateWithDuration:0.25f animations:^{
            [self updateIndicatorViewFrameWithXOrigin:cell.frame.origin.x
                                             andWidth:cell.frame.size.width
                                    accountForPadding:YES];
        }];
    } else {
        [self updateIndicatorViewFrameWithXOrigin:cell.frame.origin.x
                                         andWidth:cell.frame.size.width
                                accountForPadding:YES];
    }
}

- (void)setTabCellInactive:(IRTabBarCollectionViewCell *)cell {
    cell.selectionProgress = self.tabDeselectedAlpha;
}

- (void)updateTabsWithCurrentTabCell:(IRTabBarCollectionViewCell *)currentTabCell
                         nextTabCell:(IRTabBarCollectionViewCell *)nextTabCell
                            progress:(CGFloat)progress
                           backwards:(BOOL)isBackwards {
    
    // Calculate updated alpha values for tabs
    progress = isBackwards ? 1.0f - progress : progress;
    
    if (self.tabTransitionStyle == IRTabTransitionStyleProgressive) { // progressive
        
        CGFloat unselectedAlpha = self.tabDeselectedAlpha;
        CGFloat alphaDiff = (1.0f - unselectedAlpha) * progress;
        CGFloat nextAlpha = unselectedAlpha + alphaDiff;
        CGFloat currentAlpha = 1.0f - alphaDiff;
        
        currentTabCell.selectionProgress = currentAlpha;
        nextTabCell.selectionProgress = nextAlpha;
        
    } else { // snap
        
        CGFloat currentAlpha = (progress > IRTabBarViewTabTransitionSnapRatio) ? self.tabDeselectedAlpha : 1.0f;
        CGFloat targetAlpha = (progress > IRTabBarViewTabTransitionSnapRatio) ? 1.0f : self.tabDeselectedAlpha;
        
        BOOL requiresUpdate = (nextTabCell.selectionProgress != targetAlpha);
        if (requiresUpdate) {
            [UIView animateWithDuration:0.25f animations:^{
                currentTabCell.selectionProgress = currentAlpha;
                nextTabCell.selectionProgress = targetAlpha;
            }];
        }
    }
}

- (void)updateIndicatorViewWithCurrentTabCell:(IRTabBarCollectionViewCell *)currentTabCell
                                  nextTabCell:(IRTabBarCollectionViewCell *)nextTabCell
                                     progress:(CGFloat)progress {
    if (self.tabCount == 0) {
        return;
    }
    
    // calculate the upper and lower x origins for cells
    CGFloat upperXPos = MAX(nextTabCell.frame.origin.x, currentTabCell.frame.origin.x);
    CGFloat lowerXPos = MIN(nextTabCell.frame.origin.x, currentTabCell.frame.origin.x);
    
    // swap cells according to which has lowest X origin
    BOOL backwards = (nextTabCell.frame.origin.x == lowerXPos);
    if (backwards) {
        IRTabBarCollectionViewCell *temp = nextTabCell;
        nextTabCell = currentTabCell;
        currentTabCell = temp;
    }
    
    CGFloat newX = 0.0f;
    CGFloat newWidth = 0.0f;
    
    if (self.indicatorTransitionStyle == IRTabTransitionStyleProgressive) {
        
        // calculate width difference
        CGFloat currentTabWidth = currentTabCell.frame.size.width;
        CGFloat nextTabWidth = nextTabCell.frame.size.width;
        CGFloat widthDiff = (nextTabWidth - currentTabWidth) * progress;
        
        // calculate new frame for indicator
        newX = lowerXPos + ((upperXPos - lowerXPos) * progress);
        newWidth = currentTabWidth + widthDiff;
        
        [self updateIndicatorViewFrameWithXOrigin:newX
                                         andWidth:newWidth
                                accountForPadding:YES];
        
    } else if (self.indicatorTransitionStyle == IRTabTransitionStyleSnap) {
        
        IRTabBarCollectionViewCell *cell = progress > IRTabBarViewTabTransitionSnapRatio ? nextTabCell : currentTabCell;
        
        newX = cell.frame.origin.x;
        newWidth = cell.frame.size.width;
        
        BOOL requiresUpdate = self.indicatorContainer.frame.origin.x != newX;
        if (requiresUpdate) {
            [UIView animateWithDuration:0.25f animations:^{
                [self updateIndicatorViewFrameWithXOrigin:newX
                                                 andWidth:newWidth
                                        accountForPadding:YES];
            }];
        }
    }
}

- (void)updateIndicatorViewFrameWithXOrigin:(CGFloat)xOrigin
                                   andWidth:(CGFloat)width
                          accountForPadding:(BOOL)padding {
    if (self.tabCount == 0) {
        return;
    }
    
    if (padding) {
        CGFloat tabInternalPadding = self.tabPadding;
        width -= tabInternalPadding;
        xOrigin += (tabInternalPadding / 2.0f);
    }
    
    self.indicatorContainer.frame = CGRectMake(xOrigin,
                                               0.0f,
                                               width,
                                               self.bounds.size.height);
    [self updateIndicatorFrames];
    [self updateCollectionViewScrollOffset];
}

- (void)updateCollectionViewScrollOffset {
    if (self.sizingStyle != IRTabSizingStyleDistributed) {
        
        //        [self.collectionView scrollToItemAtIndexPath:<#(nonnull NSIndexPath *)#> atScrollPosition:<#(UICollectionViewScrollPosition)#> animated:<#(BOOL)#>
        
        // scroll collection view to center selection indicator if possible
        CGFloat collectionViewWidth = self.collectionView.bounds.size.width - self.contentInset.left - self.contentInset.right;
        CGFloat scrollViewX = MAX(0, self.indicatorContainer.center.x - (collectionViewWidth / 2.0f));
        //        NSLog(@"collectionView.layoutMargins %f",self.collectionView.layoutMargins.left);
        //        dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat adjustedContentInsetBottom = 0;
        if (@available(iOS 11.0, *)) {
            adjustedContentInsetBottom = self.collectionView.adjustedContentInset.bottom;
        }
        [self.collectionView scrollRectToVisible:CGRectMake(scrollViewX,
                                                            self.collectionView.frame.origin.y,
                                                            collectionViewWidth,
                                                            self.collectionView.frame.size.height - adjustedContentInsetBottom)
                                        animated:NO];
        //        });
        
        //        [self.collectionView setNeedsLayout];
        //        [self.collectionView layoutIfNeeded];
    }
}

- (IRTabBarCollectionViewCell *)collectionViewCellAtTabIndex:(NSInteger)tabIndex {
    if (tabIndex >= 0 && tabIndex < self.tabCount) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:tabIndex inSection:0];
        return (IRTabBarCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    }
    return nil;
}

#pragma mark - Internal

- (NSArray *)evaluateTabTitles {
    NSArray *tabTitles = [[self.dataSource tabTitlesForTabBarView:self]copy];
    return tabTitles;
}

- (NSInteger)evaluateDataSource {
    NSInteger tabCount = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsForTabBarView:)]) {
        tabCount = [self.dataSource numberOfItemsForTabBarView:self];
        
    } else if ([self.dataSource respondsToSelector:@selector(tabTitlesForTabBarView:)]) {
        
        self.tabTitles = [self evaluateTabTitles];
        tabCount = self.tabTitles.count;
    }
    _tabCount = tabCount;
    return tabCount;
}

- (NSString *)titleAtIndex:(NSInteger)index {
    if (self.tabTitles) {
        return self.tabTitles[index];
    } else {
        return [NSString stringWithFormat:IRTabBarViewDefaultTabTitleFormat, (long)(index + 1)];
    }
}

- (void)reset {
    _selectedCell = nil;
    _selectedIndexPath = nil;
    _hasRespectedDefaultTabIndex = NO;
    _tabOffset = IRTabBarViewTabOffsetInvalid;
    _previousTabOffset = IRTabBarViewTabOffsetInvalid;
}

- (void)doSetDataSource:(id<IRTabBarViewDataSource>)dataSource {
    _dataSource = dataSource;
    [self reset];
    if ([dataSource respondsToSelector:@selector(defaultTabIndexForTabBarView:)]) {
        self.defaultTabIndex = [dataSource defaultTabIndexForTabBarView:self];
    }
    [self.collectionView reloadData];
    [self setNeedsLayout];
}

- (void)reloadData {
    if (self.tabOffset == IRTabBarViewTabOffsetInvalid) {
        _hasRespectedDefaultTabIndex = NO;
    }
    [self.collectionView reloadData];
}

- (void)updateCellAppearance:(IRTabBarCollectionViewCell *)cell {
    
    // default appearance
    if (self.tabAttributes) {
        UIColor *tabTextColor;
        if ((tabTextColor = self.tabAttributes[IRTabTextColor]) ||
            (tabTextColor = self.tabAttributes[NSForegroundColorAttributeName])) {
            
            cell.textColor = tabTextColor;
        }
        
        UIFont *tabTextFont;
        if ((tabTextFont = self.tabAttributes[IRTabTextFont]) ||
            (tabTextFont = self.tabAttributes[NSFontAttributeName])) {
            cell.textFont = tabTextFont;
        }
        
        UIOffset tabTextOffset;
        tabTextOffset = [self.tabAttributes[IRTabTextOffset] UIOffsetValue];
        cell.textOffset = tabTextOffset;
        
        UIColor *tabBackgroundColor;
        if ((tabBackgroundColor = self.tabAttributes[NSBackgroundColorAttributeName])) {
            cell.tabBackgroundColor = tabBackgroundColor;
        }
        
        NSNumber *alphaEffectEnabled;
        if ((alphaEffectEnabled = self.tabAttributes[IRTabTransitionAlphaEffectEnabled])) {
            cell.alphaEffectEnabled = [alphaEffectEnabled boolValue];
        }
        
        NSNumber *deselectedAlphaValue;
        if ((deselectedAlphaValue = self.tabAttributes[IRTabTitleAlpha])) {
            self.tabDeselectedAlpha = [deselectedAlphaValue floatValue];
        }
        
    } else {
        cell.textColor = self.tabTextColor;
        if(self.tabTextFont){
            cell.textFont = self.tabTextFont;
        }
    }
    
    // selected appearance
    if (self.selectedTabAttributes) {
        UIColor *selectedTabTextColor;
        if ((selectedTabTextColor = self.selectedTabAttributes[IRTabTextColor]) ||
            (selectedTabTextColor = self.selectedTabAttributes[NSForegroundColorAttributeName])) {
            
            cell.selectedTextColor = selectedTabTextColor;
        }
        
        UIFont *selectedTabTextFont;
        if ((selectedTabTextFont = self.selectedTabAttributes[IRTabTextFont]) ||
            (selectedTabTextFont = self.selectedTabAttributes[NSFontAttributeName])) {
            
            cell.selectedTextFont = selectedTabTextFont;
        }
        
        UIColor *selectedTabBackgroundColor;
        if ((selectedTabBackgroundColor = self.selectedTabAttributes[NSBackgroundColorAttributeName])) {
            cell.selectedTabBackgroundColor = selectedTabBackgroundColor;
        }
    }
    
    cell.backgroundColor = [UIColor clearColor];
    [cell setContentBottomMargin:[self.indicatorAttributes[IRTabIndicatorLineHeight]floatValue]];
}

- (void)updateIndicatorForStyle:(IRIndicatorStyle)indicatorStyle {
    [self.indicatorContainer IR_clearSubviews];
    
    UIView *indicatorView;
    switch (indicatorStyle) {
        case IRIndicatorStyleLine: {
            UIView *indicatorLineView = [UIView new];
            [self.indicatorContainer addSubview:indicatorLineView];
            
            indicatorView = indicatorLineView;
        }
            break;
            
        case IRIndicatorStyleImage: {
            UIImageView *imageView = [UIImageView new];
            imageView.contentMode = UIViewContentModeBottom;
            [self.indicatorContainer addSubview:imageView];
            
            indicatorView = imageView;
        }
            break;
            
        default:
            break;
    }
    
    self.indicatorView = indicatorView;
    [self updateIndicatorAppearance];
}

- (void)updateIndicatorAppearance {
    if (self.indicatorAttributes) {
        
        switch (self.indicatorStyle) {
            case IRIndicatorStyleLine: {
                
                UIColor *indicatorColor;
                if ((indicatorColor = self.indicatorAttributes[NSForegroundColorAttributeName])) {
                    self.indicatorView.backgroundColor = indicatorColor;
                }
                
                NSNumber *indicatorHeight;
                if ((indicatorHeight = self.indicatorAttributes[IRTabIndicatorLineHeight])) {
                    self.lineIndicatorHeight = [indicatorHeight floatValue];
                }
            }
                break;
                
            case IRIndicatorStyleImage: {
                UIImageView *indicatorImageView = (UIImageView *)self.indicatorView;
                
                UIImage *indicatorImage;
                if ((indicatorImage = self.indicatorAttributes[IRTabIndicatorImage])) {
                    indicatorImageView.image = [indicatorImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                }
                
                UIColor *indicatorTintColor;
                if ((indicatorTintColor = self.indicatorAttributes[IRTabIndicatorImageTintColor])) {
                    indicatorImageView.tintColor = indicatorTintColor;
                }
            }
                break;
        }
    }
}

- (void)updateIndicatorFrames {
    CGRect containerBounds = self.indicatorContainer.bounds;
    
    CGFloat height = 0.0f;
    switch (self.indicatorStyle) {
        case IRIndicatorStyleLine:
            height = self.lineIndicatorHeight;
            break;
            
        case IRIndicatorStyleImage:
            height = self.indicatorContainer.bounds.size.height;
            break;
    }
    
    self.indicatorView.frame = CGRectMake(0.0f,
                                          containerBounds.size.height - height,
                                          containerBounds.size.width,
                                          height);
}

- (CGFloat)tabDeselectedAlpha {
    if (_tabDeselectedAlpha == 0.0f) {
        return IRTabBarViewDefaultTabUnselectedAlpha;
    } else {
        return _tabDeselectedAlpha;
    }
}

#pragma clang diagnostic pop

@end

