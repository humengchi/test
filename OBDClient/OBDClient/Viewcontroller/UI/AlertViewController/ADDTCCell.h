//
//  ADDTCCell.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-24.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADBaseCell.h"
#import "ADDTCBase.h"

@interface ADDTCCell : ADBaseCell
{
    ADDTCBase *_dtcBase;
}

- (void)updateUIByDTCBase:(ADDTCBase *)aDTCBase;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
            dtcBase:(ADDTCBase *)aDTCBase;

@end
