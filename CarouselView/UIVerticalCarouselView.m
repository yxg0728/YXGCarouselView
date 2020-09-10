//
//  UIVerticalCarouselView.m
// 
//
//  Created by zengmuqiang on 2020/8/28.
//  Copyright © 2020 UPChina. All rights reserved.
//

#import "UIVerticalCarouselView.h"

static const NSInteger kMaxCount = 3000;

@interface UIVerticalCarouselView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) NSTimer *timer;

@property (nonatomic, assign) NSInteger totalItemsCount;

@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) NSMutableArray *registerClassesArray;

@end

@implementation UIVerticalCarouselView

@synthesize pageControl = _pageControl;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        [self setupCollectionView];
        [self setupPageControl];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self initialization];
    [self setupCollectionView];
    [self setupPageControl];
}

- (void)initialization {
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.autoScroll = YES;
    self.autoScrollInterval = 3;
    self.infiniteLoop = YES;
    self.showPageControl = YES;
    
    self.registerClassesArray = NSMutableArray.array;
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.flowLayout = flowLayout;

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.scrollsToTop = NO;
    [self addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)setupPageControl {
    [self addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-5);
        make.centerX.equalTo(self);
        make.height.equalTo(@10);
        make.width.equalTo(@30);
    }];
}

// MARK: Public

// MARK: - Life circles
- (void)layoutSubviews {
    [super layoutSubviews];

    _flowLayout.itemSize = self.frame.size;

    _collectionView.frame = self.bounds;
    if (_collectionView.contentOffset.x == 0 &&  self.totalItemsCount) {
        int targetIndex = 0;
        if (self.infiniteLoop) {
            targetIndex = self.totalItemsCount * 0.5;
        }else{
            targetIndex = 0;
        }
        
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self invalidateTimer];
    }
}

//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

// MARK: - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self identifierAtIndexPath:indexPath];
    
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [self.delegate carouselView:self configCell:cell index:itemIndex];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    [self.delegate carouselView:self itemDidSelectAtIndex:itemIndex];
}

// MARK: - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollViewcurrentPage {
    [self updatePage];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:self.collectionView];
    [self updatePage];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];

    if ([self.delegate respondsToSelector:@selector(carouselView:itemDidScrollToIndex:)]) {
        [self.delegate carouselView:self itemDidScrollToIndex:indexOnPageControl];
    }
}

- (void)updatePage {
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];

    if ([self.pageControl isKindOfClass:[UIPageControl class]]) {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.numberOfPages = [self.delegate numberOfItemsInCarouselView:self];
        pageControl.currentPage = indexOnPageControl;
    }
}

// MARK: Private

- (void)setupTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer {
    [_timer invalidate];
    _timer = nil;
}

- (void)automaticScroll {
    if (0 == self.totalItemsCount) {
        return;
    }
    int currentIndex = [self currentIndex];
    int targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex];
}

- (void)scrollToIndex:(int)targetIndex {
    if (targetIndex >= self.totalItemsCount) {
        if (self.infiniteLoop) {
            targetIndex = self.totalItemsCount * 0.5;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (int)currentIndex {
    if (self.collectionView.frame.size.width == 0 || self.collectionView.frame.size.height == 0) {
        return 0;
    }

    int index = 0;
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (self.collectionView.contentOffset.x + self.flowLayout.itemSize.width * 0.5) / self.flowLayout.itemSize.width;
    } else {
        index = (self.collectionView.contentOffset.y + self.flowLayout.itemSize.height * 0.5) / self.flowLayout.itemSize.height;
    }

    return MAX(0, index);
}

- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index {
    NSInteger count = [self.delegate numberOfItemsInCarouselView:self];

    return count == 0 ? 0 : (int)index % count;
}

- (NSString *)identifierAtIndexPath:(NSIndexPath *)indexPath {
    Class class = [self.delegate carouselView:self itemClassForIndex:indexPath.row];
    NSString *identifier = NSStringFromClass(class);
    
    [self autoRegisterClass:class withIdentifier:identifier];
    
    return identifier;
}

- (void)autoRegisterClass:(Class)class withIdentifier:(NSString *)identifier {
    if (![self.registerClassesArray containsObject:class]) {
        [self.collectionView registerClass:class forCellWithReuseIdentifier:identifier];
        [self.registerClassesArray addObject:class];
    }
}

- (void)reloadData {
    [self.collectionView reloadData];
}

// MARK: Getter & Setter

- (void)setAutoScroll:(BOOL)autoScroll {
    _autoScroll = autoScroll;
    
    [self invalidateTimer];

    if (_autoScroll) {
        [self setupTimer];
    }
}

- (NSInteger)totalItemsCount {
    NSInteger count = [self.delegate numberOfItemsInCarouselView:self];
    return self.infiniteLoop && count > 1 ? count * kMaxCount : count;
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    
    self.flowLayout.scrollDirection = scrollDirection;
}

- (void)setAutoScrollInterval:(NSTimeInterval)autoScrollInterval {
    _autoScrollInterval = autoScrollInterval;
    
    [self setAutoScroll:self.autoScroll];
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.userInteractionEnabled = NO;
        
        _pageControl = pageControl;
    }
    
    return _pageControl;
}

- (void)setPageControl:(UIPageControl *)pageControl {
    if (_pageControl && _pageControl.superview) {
        [_pageControl removeFromSuperview];
    }
    
    _pageControl = pageControl;
    
    [self addSubview:pageControl];
}

- (void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;

    self.pageControl.hidden = !showPageControl;
}

@end

