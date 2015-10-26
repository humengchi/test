//
//  ADPageIndicatorView.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADPageIndicatorView.h"
#import "NSDate+Helper.h"

@implementation ADPageIndicatorView

- (id)initWithFrame:(CGRect)frame dates:(NSArray *)aDatesArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _font = [UIFont systemFontOfSize:13];
        _dates = aDatesArray;
        NSString *labelStr = [[_dates objectAtIndex:[_dates count] - 2] toStringHasTime:NO];
        CGSize sizeOfLabel = [self sizeOfString:labelStr];
        _label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, sizeOfLabel.width, sizeOfLabel.height)];
        _label1.font = _font;
        _label1.text = labelStr;
        _label1.textColor = [UIColor grayColor];
        _label1.backgroundColor = [UIColor clearColor];
        [self addSubview:_label1];
        
        labelStr = [[_dates objectAtIndex:[_dates count] - 1] toStringHasTime:NO];
        sizeOfLabel = [self sizeOfString:labelStr];
        _label2 = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width - sizeOfLabel.width) / 2, 3, sizeOfLabel.width, sizeOfLabel.height)];
        _label2.font = _font;
        _label2.text = labelStr;
        _label2.textColor = [UIColor grayColor];
        _label2.backgroundColor = [UIColor clearColor];
        [self addSubview:_label2];
        
        _label3 = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - sizeOfLabel.width, 3, sizeOfLabel.width, sizeOfLabel.height)];
        _label3.font = _font;
        _label3.text = @"";
        _label3.textColor = [UIColor grayColor];
        _label3.backgroundColor = [UIColor clearColor];
        [self addSubview:_label3];
        
        UILabel *labelTip=[[UILabel alloc]initWithFrame:CGRectMake(0, sizeOfLabel.height, self.bounds.size.width, self.bounds.size.height-sizeOfLabel.height)];
        labelTip.textAlignment=NSTextAlignmentCenter;
        labelTip.font = _font;
        labelTip.text = NSLocalizedStringFromTable(@"SlideleftandrighttoswitchthecurrentdateKey",@"MyString", @"");
        labelTip.textColor = [UIColor grayColor];
        labelTip.backgroundColor = [UIColor clearColor];
        [self addSubview:labelTip];
    }
    return self;
}

- (void)updateUIByIndex:(NSUInteger)aIndex
{
//    if (aIndex >= [_dates count] - 1) {
//        //最后一个,
//        _label2.text = [self stringByIndex:aIndex];
//        _label2.hidden = NO;
//        
//        _label3.hidden = YES;
//        
//        NSInteger preIndex = aIndex - 1;
//        if (preIndex < 0) {
//            _label1.hidden = YES;
//        } else {
//            _label1.text = [self stringByIndex:preIndex];
//            _label1.hidden = NO;
//        }
//    } else if (aIndex == 0)
//    {
//        _label1.hidden = YES;
//        _label2.text = [self stringByIndex:aIndex];
//        _label3.text = [self stringByIndex:aIndex + 1];
//    } else
//    {
//        _label1.text = [self stringByIndex:aIndex - 1];
//        _label2.text = [self stringByIndex:aIndex];
//        _label3.text = [self stringByIndex:aIndex + 1];
//    }
//    
    _label1.text = [self stringByIndex:aIndex - 1];
    _label2.text = [self stringByIndex:aIndex];
    _label3.text = [self stringByIndex:aIndex + 1];
}

- (NSString *)stringByIndex:(NSInteger)aIndex
{
    if (aIndex > [_dates count] - 1 || aIndex < 0) {
        return @"";
    }
    return [[_dates objectAtIndex:aIndex] toStringHasTime:NO];
}

- (CGSize)sizeOfString:(NSString *)aStr
{
    CGSize labelSize = [aStr sizeWithFont:_font constrainedToSize:CGSizeMake(100, self.bounds.size.height)];
    return labelSize;
}

@end
