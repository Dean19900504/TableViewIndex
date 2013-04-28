//
//  DSectionIndexItemView.h
//  TableViewIndex
//
//  Created by Dean on 13-4-28.
//  Copyright (c) 2013年 Dean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSectionIndexItemView : UIView
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;//方便在子类里重写该方法
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
@end
