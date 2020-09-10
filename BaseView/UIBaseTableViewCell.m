//
//  UIBaseTableViewCell.m
//  YXGCarouselView
//
//  Created by zengmuqiang on 2020/9/10.
//  Copyright © 2020 ZMQ. All rights reserved.
//

#import "UIBaseTableViewCell.h"

@interface UIBaseTableViewCell()

@property(nonatomic, strong) UIView *baseTopLineView;
@property(nonatomic, strong) UIView *baseBottomLineView;

@end

@implementation UIBaseTableViewCell {
    BOOL _showTopLineView;
    BOOL _showBottomLineView;
    MASConstraint *_topLineViewLeftConstraint;
    MASConstraint *_topLineViewRightContraint;
    MASConstraint *_bottomLineViewLeftConstraint;
    MASConstraint *_bottomLineViewRightContraint;
    
    CGFloat _topLeftOffset;
    CGFloat _topRightOffset;
    CGFloat _bottomLeftOffset;
    CGFloat _bottomRightOffset;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
        [self setConstraints];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIView *selectBackgroundView = [[UIView alloc] init];
    selectBackgroundView.backgroundColor = [UIColor lightGrayColor];
    self.selectedBackgroundView = selectBackgroundView;
    
}

- (void)setConstraints {
}

- (void)showTopLineViewWithLeftMargin:(CGFloat)left rightMargin:(CGFloat)right {
    if (_showTopLineView) {
        return;
    }
    
    if (!self.baseTopLineView.superview) {
        _topLeftOffset = 15;
        _topRightOffset = 0;
        [self.contentView addSubview:self.baseTopLineView];
        [self.baseTopLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            _topLineViewLeftConstraint = make.left.equalTo(self.contentView).offset(_topLeftOffset);
            _topLineViewRightContraint = make.right.equalTo(self.contentView).offset(-_topRightOffset);
            make.height.equalTo(@((0.5)));
            make.top.equalTo(self.contentView);
        }];
    }
    
    self.baseTopLineView.hidden = NO;
    _showTopLineView = YES;
    
    if (left != _topLeftOffset) {
        _topLeftOffset = left;
        _topLineViewLeftConstraint.offset(left);
    }
    
    if (right != _topRightOffset) {
        _topRightOffset = right;
        _topLineViewRightContraint.offset(right);
    }
}

- (void)hideTopLineView {
    _showTopLineView = NO;
    self.baseTopLineView.hidden = YES;
}

- (void)showBottomLineViewWithLeftMargin:(CGFloat)left rightMargin:(CGFloat)right {
    if (_showBottomLineView) {
        return;
    }
    
    if (!self.baseBottomLineView.superview) {
        [self.contentView addSubview:self.baseBottomLineView];
        
        _bottomLeftOffset = 15;
        _bottomRightOffset = 0;
        [self.baseBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            _bottomLineViewLeftConstraint = make.left.equalTo(self.contentView).offset(_bottomLeftOffset);
            _bottomLineViewRightContraint = make.right.equalTo(self.contentView).offset(-_bottomRightOffset);
            make.height.equalTo(@((0.5)));
            make.bottom.equalTo(self.contentView);
        }];
    }
    
    self.baseBottomLineView.hidden = NO;
    _showBottomLineView = YES;
    
    if (left != _bottomLeftOffset) {
        _bottomLeftOffset = left;
        _bottomLineViewLeftConstraint.offset(left);
    }
    
    if (right != _bottomRightOffset) {
        _bottomRightOffset = right;
        _bottomLineViewRightContraint.offset(right);
    }
}

// MARK: - Getter & Setter

- (void)hideBottomLineView {
    _showBottomLineView = NO;
    self.baseBottomLineView.hidden = YES;
}

- (UIView *)baseTopLineView {
    if (!_baseTopLineView) {
        _baseTopLineView = [[UIView alloc] init];
        _baseTopLineView.backgroundColor = [UIColor grayColor];
    }
    return _baseTopLineView;
}

- (UIView *)baseBottomLineView {
    if (!_baseBottomLineView) {
        _baseBottomLineView = [[UIView alloc] init];
        _baseBottomLineView.backgroundColor = [UIColor grayColor];
    }
    return _baseBottomLineView;
}

- (void)updateCellContent:(NSDictionary *)listInfo {
    _listInfo = listInfo;
}

@end
