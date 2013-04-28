//
//  DSectionIndexView.h
//  TableViewIndex
//
//  Created by Dean on 13-4-28.
//  Copyright (c) 2013年 Dean. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSectionIndexItemView;
@class DSectionIndexView;

@protocol DSectionIndexViewDataSource <NSObject>

- (DSectionIndexItemView *)sectionIndexView:(DSectionIndexView *)sectionIndexView
                         itemViewForSection:(NSInteger)section;

- (NSInteger)numberOfItemViewForSectionIndexView:(DSectionIndexView *)sectionIndexView;

@optional
- (UIView *)sectionIndexView:(DSectionIndexView *)sectionIndexView
       calloutViewForSection:(NSInteger)section;
- (NSString *)sectionIndexView:(DSectionIndexView *)sectionIndexView
               titleForSection:(NSInteger)section;
@end

@protocol DSectionIndexViewDelegate <NSObject>

- (void)sectionIndexView:(DSectionIndexView *)sectionIndexView
        didSelectSection:(NSInteger)section;

@end


typedef enum {
    SectionIndexCalloutDirectionLeft,
    SectionIndexCalloutDirectionRight
}SectionIndexCalloutDirection;

typedef enum {
    CalloutViewTypeForQQMusic,   //QQ音乐模式现在只支持DSectionIndexView视图在右边和CalloutView视图在左边
    CalloutViewTypeForUserDefined
}CalloutViewType;

@interface DSectionIndexView : UIView

@property (nonatomic, __d_weak) id<DSectionIndexViewDataSource>dataSource;
@property (nonatomic, __d_weak) id<DSectionIndexViewDelegate>delegate;

//选中提示图显示的方向，相对于DSectionIndexView的对象而言
@property (nonatomic, assign) SectionIndexCalloutDirection calloutDirection;

//是否显示选中提示图，默认是YES
@property (nonatomic, assign) BOOL isShowCallout;

//选中提示图的样式,默认是QQ音乐的样式
@property (nonatomic, assign) BOOL calloutViewType;

//itemView的高度，默认是根据itemView的数目均分DSectionIndexView的对象的高度
@property (nonatomic, assign) CGFloat fixedItemHeight;

//选中提示图与DSectionIndexView的对象边缘的距离
@property (nonatomic, assign) CGFloat calloutMargin;


- (void)reloadItemViews;

- (void)setBackgroundViewFrame;


@end
