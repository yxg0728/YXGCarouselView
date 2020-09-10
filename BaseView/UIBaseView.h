//
//  UIBaseView.h
//  YXGCarouselView
//
//  Created by zengmuqiang on 2020/9/10.
//  Copyright © 2020 ZMQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBaseView : UIView

/*
 初始化控件
 */
- (void)setupViews;

/*
 约束布局
 */
- (void)setConstraints;

@end

NS_ASSUME_NONNULL_END
