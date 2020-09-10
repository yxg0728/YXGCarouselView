//
//  UIImageViewCell.m
//  YXGCarouselView
//
//  Created by zengmuqiang on 2020/9/10.
//  Copyright © 2020 ZMQ. All rights reserved.
//

#import "UIImageViewCell.h"
#import "UIVerticalCarouselView.h"

@interface UIImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageV;

@end

@implementation UIImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    _imageV = [[UIImageView alloc] init];
    [self addSubview:_imageV];
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(15);
        make.right.bottom.equalTo(self).offset(-15);
    }];
}

- (void)setImageVWithString:(NSString *)imgStr {
    self.imageV.image = [UIImage imageNamed:imgStr];
}

@end

@interface UIImageViewCell()<UIVerticalCarouselViewDelegate>

@property (nonatomic, strong) UIVerticalCarouselView *vCarouselView;

@property (nonatomic, strong) NSArray *scrollImageArray;

@end

@implementation UIImageViewCell

- (NSArray *)scrollImageArray {
    if (!_scrollImageArray) {
        _scrollImageArray = [NSArray array];
    }
    return _scrollImageArray;
}

- (void)setupViews {
    [super setupViews];
    
    self.vCarouselView = [[UIVerticalCarouselView alloc] init];
    self.vCarouselView.delegate = self;
    self.vCarouselView.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.vCarouselView.showPageControl = NO;
    self.vCarouselView.autoScrollInterval = 3;
    self.vCarouselView.collectionView.scrollEnabled = NO; // 禁止垂直滚动视图被用户手势滚动
    [self.contentView addSubview:self.vCarouselView];
}

- (void)setConstraints {
    [super setConstraints];
    
    [self.vCarouselView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.equalTo(@96);
    }];
}

- (void)updateCellContent:(NSDictionary *)listInfo {
    [super updateCellContent:listInfo];
    NSArray *images = listInfo[@"images"];
    self.scrollImageArray = images.copy;
    [self.vCarouselView reloadData];
}

//MARK: - UIVerticalcarouselViewDelegate
- (Class)carouselView:(UIVerticalCarouselView *)carouselView itemClassForIndex:(NSInteger)index {
    return UIImageCollectionViewCell.class;
}

- (NSInteger)numberOfItemsInCarouselView:(UIVerticalCarouselView *)carouselView {
    return self.scrollImageArray.count;
}

- (void)carouselView:(UIVerticalCarouselView *)carouselView configCell:(__kindof UICollectionViewCell *)cell index:(NSInteger)index {
    if ([cell isKindOfClass:[UIImageCollectionViewCell class]]) {
        UIImageCollectionViewCell *imgCell = (UIImageCollectionViewCell *)cell;
        if (index < self.scrollImageArray.count) {
            NSString *imageStr = self.scrollImageArray[index];
            [imgCell setImageVWithString:imageStr];
        }
    }
}

- (void)carouselView:(UIVerticalCarouselView *)carouselView itemDidScrollToIndex:(NSInteger)index {
    
}

- (void)carouselView:(UIVerticalCarouselView *)carouselView itemDidSelectAtIndex:(NSInteger)index {
    
}

@end
