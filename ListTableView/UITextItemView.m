//
//  UITextItemView.m
//  YXGCarouselView
//
//  Created by zengmuqiang on 2020/9/10.
//  Copyright © 2020 ZMQ. All rights reserved.
//

#import "UITextItemView.h"
#import "UIVerticalCarouselView.h"

@interface UITextCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation UITextCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor redColor];
    _titleLabel.font = kSystemFont(13.f);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.numberOfLines = 0;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(15);
        make.right.bottom.equalTo(self).offset(-15);
    }];
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end


@interface UITextItemView()<UIVerticalCarouselViewDelegate>

@property (nonatomic, strong) UIVerticalCarouselView *vCarouselView;

@property (nonatomic, strong) NSArray *scrollTextArray;

@end

@implementation UITextItemView

- (NSArray *)scrollTextArray {
    if (!_scrollTextArray) {
        _scrollTextArray = [NSArray array];
    }
    return _scrollTextArray;
}

- (void)setupViews {
    [super setupViews];
    
    self.vCarouselView = [[UIVerticalCarouselView alloc] init];
    self.vCarouselView.delegate = self;
    self.vCarouselView.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.vCarouselView.showPageControl = NO;
    self.vCarouselView.autoScrollInterval = 3;
    self.vCarouselView.collectionView.scrollEnabled = NO; // 禁止垂直滚动视图被用户手势滚动
    [self addSubview:self.vCarouselView];
}

- (void)setConstraints {
    [super setConstraints];
    
    [self.vCarouselView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    self.scrollTextArray = titles.copy;
    [self.vCarouselView reloadData];
}

//MARK: - UIVerticalcarouselViewDelegate
- (Class)carouselView:(UIVerticalCarouselView *)carouselView itemClassForIndex:(NSInteger)index {
    return UITextCollectionViewCell.class;
}

- (NSInteger)numberOfItemsInCarouselView:(UIVerticalCarouselView *)carouselView {
    return self.scrollTextArray.count;
}

- (void)carouselView:(UIVerticalCarouselView *)carouselView configCell:(__kindof UICollectionViewCell *)cell index:(NSInteger)index {
    if ([cell isKindOfClass:[UITextCollectionViewCell class]]) {
        UITextCollectionViewCell *textCell = (UITextCollectionViewCell *)cell;
        if (index < self.scrollTextArray.count) {
            NSString *titleStr = self.scrollTextArray[index];
            [textCell setTitle:titleStr];
        }
    }
}

- (void)carouselView:(UIVerticalCarouselView *)carouselView itemDidScrollToIndex:(NSInteger)index {
    
}

- (void)carouselView:(UIVerticalCarouselView *)carouselView itemDidSelectAtIndex:(NSInteger)index {
    
}


@end
