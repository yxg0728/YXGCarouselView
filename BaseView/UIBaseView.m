//
//  UIBaseView.m
//  YXGCarouselView
//
//  Created by zengmuqiang on 2020/9/10.
//  Copyright © 2020 ZMQ. All rights reserved.
//

#import "UIBaseView.h"

@implementation UIBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self setConstraints];
    }
    return self;
}

- (void)setupViews {

}

- (void)setConstraints {
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
