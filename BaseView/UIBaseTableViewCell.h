//
//  UIBaseTableViewCell.h
//  YXGCarouselView
//
//  Created by zengmuqiang on 2020/9/10.
//  Copyright © 2020 ZMQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBaseTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *listInfo;

/*
 初始化控件
 */
- (void)setupViews;

/*
 约束布局
 */
- (void)setConstraints;

/*
 显示顶部分割线

 @param left 分割线左边距
 @param right 分割线右边距
 */
- (void)showTopLineViewWithLeftMargin:(CGFloat)left rightMargin:(CGFloat)right;

/*
 显示底部分割线

 @param left 分割线左边距
 @param right 分割线右边距
 */
- (void)showBottomLineViewWithLeftMargin:(CGFloat)left rightMargin:(CGFloat)right;

/*
 隐藏顶部分割线
 */
- (void)hideTopLineView;

/*
 隐藏底部分割线
 */
- (void)hideBottomLineView;

- (void)updateCellContent:(NSDictionary *)listInfo;

@end

NS_ASSUME_NONNULL_END
