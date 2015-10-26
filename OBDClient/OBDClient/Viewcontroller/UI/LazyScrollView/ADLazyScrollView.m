//
//  ADLazyScrollView.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADLazyScrollView.h"

@implementation ADLazyScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentPage = NSNotFound;
        _positionArray  = [[NSMutableArray alloc] initWithCapacity:5];
        for (int i = 0; i < 5; i ++) {
            [_positionArray addObject:[NSNumber numberWithFloat:i * WIDTH]];
        }

        
        _lastScrollX = [self positionInfoByIndex:(NSUInteger)(([_positionArray count] - 1) / 2)];
        _displayViewControllers = [NSArray arrayWithObjects:[NSNull null], [NSNull null], [NSNull null], nil];// 3 个viewController
        
        self.directionalLockEnabled = YES;
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.delegate = self;

        
        _view0 = [[UIView alloc] initWithFrame:CGRectMake(WIDTH, 0, self.bounds.size.width, self.bounds.size.height)];
        _view0.backgroundColor = [UIColor redColor];
        _view0.tag = 1000;
        [self addSubview:_view0];
        
        _view1 = [[UIView alloc] initWithFrame:CGRectMake(WIDTH*2, 0, self.bounds.size.width, self.bounds.size.height)];
        _view1.backgroundColor = [UIColor blueColor];
        _view1.tag = 10001;
        [self addSubview:_view1];
        
        _view2 = [[UIView alloc] initWithFrame:CGRectMake(WIDTH*3, 0, self.bounds.size.width, self.bounds.size.height)];
        _view2.backgroundColor = [UIColor grayColor];
        _view2.tag = 10002;
        [self addSubview:_view2];
    }
    return self;
}

//UI 5个位置,按索引取坐标.
- (float)positionInfoByIndex:(NSUInteger)aIndex
{
    return [(NSNumber *)[_positionArray objectAtIndex:aIndex] floatValue];
}

- (void)reloadData
{
    self.contentSize = CGSizeMake([_positionArray count] * WIDTH, self.contentSize.height);
    self.contentOffset = CGPointMake([self positionInfoByIndex:2], 0);
    
    _currentPage = 0;
    [self loadControllerAtIndex:_currentPage replaceAtIndex:2];
    [self loadControllerAtIndex:_currentPage + 1 replaceAtIndex:3];
    
}

- (void)setPageIndex:(NSUInteger)aIndex
{
    
}

- (void)loadControllerAtIndex:(NSUInteger)index replaceAtIndex:(NSUInteger)destIndex
{
    UIViewController *viewcontroll = [_dataSourceDelegate viewControllersAtIndex:index];
    if (destIndex == 1) {
        viewcontroll.view.frame = CGRectMake(WIDTH, 0, self.bounds.size.width, self.bounds.size.height);
        [_view0 removeFromSuperview];
        _view0 = viewcontroll.view;
        [self addSubview:_view0];
    } else if (destIndex == 2) {
        viewcontroll.view.frame = CGRectMake(WIDTH*2, 0, self.bounds.size.width, self.bounds.size.height);
        [_view1 removeFromSuperview];
        _view1 = viewcontroll.view;
        [self addSubview:_view1];
    } else if (destIndex == 3) {
        viewcontroll.view.frame = CGRectMake(WIDTH*3, 0, self.bounds.size.width, self.bounds.size.height);
        [_view2 removeFromSuperview];
        _view2 = viewcontroll.view;
        [self addSubview:_view2];
    }
}

#pragma mark - UIScrollViewDelegate

// any offset changes
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float currentPosition = self.contentOffset.x;
    if (currentPosition - _lastScrollX > 25) {
        //direction:right
        if (_currentPage <= 0) {
            //超出索引.不能继续滑动.
            [self scrollRectToVisible:CGRectMake(WIDTH, 0, self.bounds.size.width, self.bounds.size.height) animated:NO];
            //[self setContentOffset:self.contentOffset];
        }
    } else if (currentPosition - _lastScrollX < -25) {
        //direction:left        
        if (_currentPage + 1 > [_dataSourceDelegate numbersOfControllers] - 1) {
            //超出索引.不能继续滑动.
            [self setContentOffset:self.contentOffset];
        }
    }
}

// called on start of dragging (may require some time and or distance to move)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView 
{
    
}

// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.contentOffset.x < 160) {
        // +1 next page
        
    }
}

// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
}

- (void)pageNextWithAnimated:(BOOL)aAnimated
{
    if (_currentPage + 1 > [_dataSourceDelegate numbersOfControllers] - 1)
    {
        //超出
        return;
    }
    _isPaging = YES;
    _currentPage += 1;
    
    //翻页动画
    [UIView animateWithDuration:0.25 animations:^{
        [self setContentOffset:CGPointMake(WIDTH*3, 0)];
    } completion:^(BOOL finished) {
        if (finished) {
            _isPaging = NO;
            //UIView *view = [self viewByPositionIndex:0];
        }
    }];
}

- (UIView *)viewByPositionIndex:(NSUInteger)aIndex
{
    return ((UIViewController *)[_displayViewControllers objectAtIndex:aIndex]).view;
}

- (void)recoverUI
{
    
}

@end