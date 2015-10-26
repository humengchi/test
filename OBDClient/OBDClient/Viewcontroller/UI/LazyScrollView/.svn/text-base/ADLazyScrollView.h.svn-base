//
//  ADLazyScrollView.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HZLazyScrollViewDelegate <NSObject>

@optional

@end

@protocol HZLazyScrollViewDataSource <NSObject>

- (NSInteger)numbersOfControllers;
- (UIViewController *)viewControllersAtIndex:(NSInteger)aIndex;

@end

@interface ADLazyScrollView : UIScrollView <UIScrollViewDelegate>
{
    float _lastScrollX;
    NSMutableArray *_displayViewControllers; // index: 对应UI上位置编号, value: UIViewController
    NSUInteger _displayIndex;
    NSMutableArray *_positionArray; //far left 0 , 1, center 2 , 3, far right 4; UI上的5个位置
    NSMutableArray *_positionOfViewController; // UI上三个ViewController 对应的坐标信息
    BOOL _isPaging;
    
    UIView *_view0;
    UIView *_view1;
    UIView *_view2;
}

@property (nonatomic) NSUInteger currentPage;

@property (nonatomic, assign) id<HZLazyScrollViewDataSource> lazyDelegate;

@property (nonatomic, assign) id<HZLazyScrollViewDataSource> dataSourceDelegate;

- (void)reloadData;

- (void)setPageIndex:(NSUInteger)aIndex;

@end
