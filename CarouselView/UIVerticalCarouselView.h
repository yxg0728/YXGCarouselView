//
//  UIVerticalCarouselView.h
//
//
//  Created by zengmuqiang on 2020/8/28.
//  Copyright © 2020 UPChina. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UIVerticalCarouselView;

NS_ASSUME_NONNULL_BEGIN

@protocol UIVerticalCarouselViewDelegate <NSObject>

@optional
- (Class)carouselView:(UIVerticalCarouselView *)carouselView itemClassForIndex:(NSInteger)index;

- (NSInteger)numberOfItemsInCarouselView:(UIVerticalCarouselView *)carouselView;

- (void)carouselView:(UIVerticalCarouselView *)carouselView configCell:(__kindof UICollectionViewCell *)cell index:(NSInteger)index;

- (void)carouselView:(UIVerticalCarouselView *)carouselView itemDidScrollToIndex:(NSInteger)index;

- (void)carouselView:(UIVerticalCarouselView *)carouselView itemDidSelectAtIndex:(NSInteger)index;

@end

@interface UIVerticalCarouselView : UIView

@property (nonatomic,assign) id <UIVerticalCarouselViewDelegate>delegate;

@property (nonatomic, strong) UICollectionView *collectionView;

/* 滚动方向,默认 UICollectionViewScrollDirectionHorizontal */
@property(nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

/* 自动滚动,默认 YES */
@property(nonatomic, assign) BOOL autoScroll;

/* 滚动时间间隔,默认3秒 */
@property(nonatomic, assign) NSTimeInterval autoScrollInterval;

/* 是否无限循环,默认Yes */
@property (nonatomic,assign) BOOL infiniteLoop;

/* pageControl, 指定则有,未指定没有 */
@property (nonatomic, strong) UIPageControl *pageControl;

/* 是否显示分页控件, 默认是 YES */
@property (nonatomic, assign) BOOL showPageControl;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
