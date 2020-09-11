//
//  ViewController.m
//  YXGCarouselView
//
//  Created by zengmuqiang on 2020/9/9.
//  Copyright © 2020 ZMQ. All rights reserved.
//

#import "ViewController.h"
#import "ListTableView.h"

@interface ViewController ()
//123
@property (nonatomic, strong) ListTableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    self.title = @"轮播ing";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kTopHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (ListTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ListTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}

@end
