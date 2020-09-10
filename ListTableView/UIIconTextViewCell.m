//
//  UIIconTextViewCell.m
//  YXGCarouselView
//
//  Created by zengmuqiang on 2020/9/10.
//  Copyright © 2020 ZMQ. All rights reserved.
//

#import "UIIconTextViewCell.h"
#import "UIVerticalCarouselView.h"

@interface UIIconTextCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation UIIconTextCollectionViewCell

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

@interface UIIconTextViewCell()<UIVerticalCarouselViewDelegate>

@property (nonatomic, strong) UIImageView *iconImgV;

@property (nonatomic, strong) UIVerticalCarouselView *vCarouselView;

@property (nonatomic, strong) NSArray *scrollTextArray;

@end

@implementation UIIconTextViewCell

- (NSArray *)scrollTextArray {
    if (!_scrollTextArray) {
        _scrollTextArray = [NSArray array];
    }
    return _scrollTextArray;
}

- (void)setupViews {
    [super setupViews];
    
    self.iconImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon"]];
    [self.contentView addSubview:self.iconImgV];
    
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
    
    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    [self.vCarouselView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImgV.mas_right);
        make.top.right.bottom.equalTo(self.contentView);
    }];
}

- (void)updateCellContent:(NSDictionary *)listInfo {
    [super updateCellContent:listInfo];
    NSArray *titles = self.listInfo[@"titles"];
    self.scrollTextArray = titles.copy;
    [self.vCarouselView reloadData];
}

//MARK: - UIVerticalcarouselViewDelegate
- (Class)carouselView:(UIVerticalCarouselView *)carouselView itemClassForIndex:(NSInteger)index {
    return UIIconTextCollectionViewCell.class;
}

- (NSInteger)numberOfItemsInCarouselView:(UIVerticalCarouselView *)carouselView {
    return self.scrollTextArray.count;
}

- (void)carouselView:(UIVerticalCarouselView *)carouselView configCell:(__kindof UICollectionViewCell *)cell index:(NSInteger)index {
    if ([cell isKindOfClass:[UIIconTextCollectionViewCell class]]) {
        UIIconTextCollectionViewCell *textCell = (UIIconTextCollectionViewCell *)cell;
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
