//
//  UITextViewCell.m
//  YXGCarouselView
//
//  Created by zengmuqiang on 2020/9/10.
//  Copyright © 2020 ZMQ. All rights reserved.
//

#import "UITextViewCell.h"
#import "UIVerticalCarouselView.h"
#import "UITextItemView.h"

@interface UITextViewCell()

@property (nonatomic, strong) UITextItemView *itemView;

@end

@implementation UITextViewCell

- (void)setupViews {
    [super setupViews];

    self.itemView = [[UITextItemView alloc] init];
    [self.contentView addSubview:self.itemView];
}

- (void)setConstraints {
    [super setConstraints];
    [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.equalTo(@80);
    }];
}

- (void)updateCellContent:(NSDictionary *)listInfo {
    [super updateCellContent:listInfo];
    NSArray *titles = self.listInfo[@"titles"];
    self.itemView.titles = titles;
}

@end
