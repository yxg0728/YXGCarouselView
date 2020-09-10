//
//  UIBaseTableView.m
//  YXGCarouselView
//
//  Created by zengmuqiang on 2020/9/9.
//  Copyright © 2020 ZMQ. All rights reserved.
//

#import "UIBaseTableView.h"

#ifndef WeakSelf
#define WeakSelf(weakSelf)  __weak typeof(self)weakSelf = self;
#endif

@implementation UIBaseTableView {
    NSMutableArray *_registerClassesArray;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setupViews];
        _registerClassesArray = [NSMutableArray array];
        _needRefreshData = YES;
    }
    return self;
}

- (void)dealloc {
    self.dataSource = nil;
    self.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// MARK: - Public

- (Class)cellClassAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell class];
}

- (void)configCell:(__kindof UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)setupViews {
    self.delegate = self;
    self.dataSource = self;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.estimatedRowHeight = 120.f;
}

- (void)updateIndex {
    
}

- (void)setConstraints {

}

- (void)refreshTableView {
    
}

- (void)loadMoreData {
    
}

- (void)beginRefreshing {
    [self.mj_header beginRefreshing];
}

- (void)endRefreshing {
    [self endRefreshingWithDelay:0.3];
}

- (void)endRefreshingWithDelay:(float)sec {
    MJRefreshHeader * header = (MJRefreshHeader *)self.mj_header;
    [header performSelector:@selector(endRefreshing) withObject:nil afterDelay:fabsf(sec)];
}

- (void)endLoadingData:(BOOL)noMoreData {
    if (noMoreData) {
        [self.mj_footer endRefreshingWithNoMoreData];
    } else {
        [self.mj_footer endRefreshing];
    }
}

- (void)updateTableView:(void (^)(void))finished {
    [self updateIndex];
    [self reloadData];
    if (finished) {
        finished();
    }
}

// 解决UIScrollView中有UIControl控件时，触摸滑动时scrollView无法滚动问题
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return YES;
}

// MARK: - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self identifierAtIndexPath:indexPath];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [self configCell:cell atIndexPath:indexPath];
    return cell;
}

// MARK: - Getter & Setter

- (void)setEnablePullRefresh:(BOOL)enablePullRefresh {
    if (_enablePullRefresh == enablePullRefresh) {
        return;
    }
    _enablePullRefresh = enablePullRefresh;
    if (_enablePullRefresh) {
        if (!self.mj_header) {
            WeakSelf(weakSelf);
            MJRefreshHeader *header = [MJRefreshHeader headerWithRefreshingBlock:^{
                [weakSelf refreshTableView];
            }];
            self.mj_header = header;
        }
        self.mj_header.hidden = NO;
    } else {
        self.mj_header.hidden = YES;
    }
}

- (void)setEnableLoadMoreData:(BOOL)enableLoadMoreData {
    if (_enableLoadMoreData == enableLoadMoreData) {
        return;
    }
    _enableLoadMoreData = enableLoadMoreData;
    if (_enableLoadMoreData) {
        if (!self.mj_footer) {
            WeakSelf(weakSelf);
            MJRefreshFooter *footer = [MJRefreshFooter footerWithRefreshingBlock:^{
                [weakSelf loadMoreData];
            }];
            self.mj_footer = footer;
        }
        self.mj_footer.hidden = NO;
    } else {
        self.mj_footer.hidden = YES;
    }
}

// MARK: - Private

- (NSString *)identifierFromClass:(Class)class {
    return NSStringFromClass(class);
}

- (NSString *)identifierAtIndexPath:(NSIndexPath *)indexPath {
    Class class = [self cellClassAtIndexPath:indexPath];
    NSString *identifier = [self identifierFromClass:class];
    
    [self autoRegisterClass:class withIdentifier:identifier];
    
    return identifier;
}

- (void)autoRegisterClass:(Class)class withIdentifier:(NSString *)identifier {
    if (![_registerClassesArray containsObject:class]) {
        [self registerClass:class forCellReuseIdentifier:identifier];
        [_registerClassesArray addObject:class];
    }
}



@end
