//
//  ListTableView.m
//  YXGCarouselView
//
//  Created by zengmuqiang on 2020/9/9.
//  Copyright © 2020 ZMQ. All rights reserved.
//

#import "ListTableView.h"
#import "UIBaseTableViewCell.h"
#import "UIImageViewCell.h"
#import "UITextViewCell.h"
#import "UIHImageViewCell.h"
#import "UIIconTextViewCell.h"

@interface ListTableView()

@property (nonatomic, strong) NSArray *dataArray;

@property(nonatomic, strong) NSMutableDictionary <NSString *, NSNumber *> *heightDic;

@end

@implementation ListTableView

- (void)setupViews {
    [super setupViews];
    
    self.enablePullRefresh = NO;
    self.enableLoadMoreData = NO;
    self.heightDic = [NSMutableDictionary dictionary];
    
    self.dataArray = @[@{@"type":@"hImage",@"images":@[@"img1",@"img2",@"img3"]},
                       @{@"type":@"text",@"titles":@[@"武汉加油武汉加油武汉加油武汉加油武汉加油武汉加油武汉加油武汉加油武汉加油武汉加油武汉加油武汉加油武汉加油武汉加油武汉加油武汉加油武汉加油武汉加油武汉加油武汉加油武汉加油武汉加油武汉加油武汉加油武汉加油武汉加油武汉加油武汉加油！",@"湖北加油！",@"中国加油！"]},
                       @{@"type":@"image",@"images":@[@"img1",@"img2",@"img3"]},
                       @{@"type":@"iconText",@"titles":@[@"武汉加油！",@"湖北加油！",@"中国加油！"]}];
}

- (Class)cellClassAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *listInfo = self.dataArray[indexPath.row];
    if ([listInfo[@"type"] isEqualToString: @"image"]) {
        return [UIImageViewCell class];
    } else if ([listInfo[@"type"] isEqualToString: @"text"]) {
        return [UITextViewCell class];
    } else if ([listInfo[@"type"] isEqualToString: @"hImage"]) {
        return [UIHImageViewCell class];
    } else if ([listInfo[@"type"] isEqualToString: @"iconText"]) {
        return [UIIconTextViewCell class];
    } else {
        return [UITextViewCell class];
    }
}

- (void)configCell:(__kindof UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *listInfo = self.dataArray[indexPath.row];
    UIBaseTableViewCell *tabCell = cell;
    [tabCell showBottomLineViewWithLeftMargin:5.f rightMargin:-5.f];
    [tabCell updateCellContent:listInfo];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = cell.frame.size.height;
    if (height) {
        NSDictionary *listInfo = self.dataArray[indexPath.row];
        NSString *newsID = listInfo[@"type"];
        if (newsID.length) {
            self.heightDic[newsID] = @(height);
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *listInfo = self.dataArray[indexPath.row];
    NSString *newsID = listInfo[@"type"];
    CGFloat height = [self.heightDic[newsID] floatValue];
    return height > 0 ? height : UITableViewAutomaticDimension;
}

@end
