//
//  UIBaseTableView.h
//  YXGCarouselView
//
//  Created by zengmuqiang on 2020/9/9.
//  Copyright © 2020 ZMQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/*
基础tableView
*/
@interface UIBaseTableView : UITableView<UITableViewDelegate, UITableViewDataSource>

/*
 是否启用下拉刷新
 */
@property (nonatomic, assign) BOOL enablePullRefresh;

/*
 是否启用上拉加在更多数据
 */
@property (nonatomic, assign) BOOL enableLoadMoreData;

/*
 是否需要刷新数据 默认YES
 */
@property (nonatomic, assign) BOOL needRefreshData;

/*
 刷新tableView数据
 @param finished _tableView完成loadData后调用的block
 */
- (void)updateTableView:(void (^)(void))finished;

/*
 初始化视图控件
 */
- (void)setupViews;

/*
 设置页面约束
 */
- (void)setConstraints;

/*
 计算cell的indexPath索引
 */
- (void)updateIndex;

/*
 下拉刷新时调用
 */
- (void)refreshTableView;

/*
 上拉刷行时调用
 */
- (void)loadMoreData;

/**
 下拉刷新
 */
- (void)beginRefreshing;

/*
 刷新结束 隐藏mj_header
 */
- (void)endRefreshing;

/*
 * 指定延迟后 停止刷新
 * */
- (void)endRefreshingWithDelay:(float)sec;

/*
 * 结束上拉刷新
 * */
- (void)endLoadingData:(BOOL)noMoreData;

/*
 设置indexPath对应的cell 并自动将其注册
 */
- (Class)cellClassAtIndexPath:(NSIndexPath *)indexPath;

/*
 对各个cell 做自定义操作
 该方法会在cellForRow 调用时调用
 */
- (void)configCell:(__kindof UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
