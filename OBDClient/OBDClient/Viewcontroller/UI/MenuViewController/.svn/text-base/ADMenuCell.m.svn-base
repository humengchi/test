//
//  ADMenuCell.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-2.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADMenuCell.h"
#import "UIUtil.h"

@implementation ADMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIColor *labelColor = COLOR_RGB(255, 255, 255);
        self.textLabel.textColor = labelColor;
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.imageSize = CGSizeMake(32, 24.727);
        
        UIImage *imageOfTop = [UIImage imageNamed:@"cell_separator_line_top.png"];
        UIImage *imageOfBottom = [UIImage imageNamed:@"menu_line.png"];
        [self setSeparatorWithTopImage:imageOfTop bottomImage:imageOfBottom];
        
        
        
        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView = selectedBackgroundView;
        [self setCellBackgroundColor:[UIColor clearColor]
             selectedBackgroundColor:CELL_SELECTED_COLOR];
    }
    return self;
}

@end
