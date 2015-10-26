//
//  ADReserveViewController.m
//  OBDClient
//
//  Created by hys on 4/11/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADReserveViewController.h"

@interface ADReserveViewController ()

@end

@implementation ADReserveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _reserveModel=[[ADReserveModel alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];
    
    self.title=NSLocalizedStringFromTable(@"reserveKey",@"MyString", @"");
    
    UIBarButtonItem* historyBtn=[[UIBarButtonItem alloc]initWithTitle:@"历史" style:UIBarButtonItemStyleDone target:self action:@selector(reserveHistoryButton:)];
    self.navigationItem.rightBarButtonItem=historyBtn;
    
    if (IOS7_OR_LATER) {
        historyBtn.tintColor=[UIColor lightGrayColor];
    }
//    _datePicker=[[FlatDatePicker alloc]initWithParentView:self.view];
//    [self.view addSubview:_datePicker];
//    _datePicker.delegate=self;
//    _datePicker.datePickerMode=FlatDatePickerModeDate;
//    
//    
//    _timePicker=[[FlatDatePicker alloc]initWithParentView:self.view];
//    [self.view addSubview:_timePicker];
//    _timePicker.delegate=self;
//    _timePicker.datePickerMode=FlatDatePickerModeTime;
//    
//    NSDate* todayDate=[NSDate date];
//    NSTimeInterval tenYear=24*60*60*365;
//    NSDate* maxDate=[NSDate dateWithTimeInterval:tenYear sinceDate:todayDate];
//    
//    [_datePicker setMaximumDate:maxDate];
    _dateView=[[UIView alloc]initWithFrame:CGRectMake(0, 50, WIDTH, 270)];
    [_dateView setBackgroundColor:[UIColor colorWithRed:58.0/255.0 green:58.0/255.0 blue:58.0/255.0 alpha:1.0]];
    [_dateView setHidden:YES];
    [self.view addSubview:_dateView];
    
    _datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 150)];
    [_datePicker setMinimumDate:[NSDate date]];
    _datePicker.datePickerMode=UIDatePickerModeDateAndTime;
    [_dateView addSubview:_datePicker];
    
    UIButton* okBtn=[[UIButton alloc]initWithFrame:CGRectMake(60, 225, 70, 40)];
    [okBtn setBackgroundColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
    [okBtn setTitle:NSLocalizedStringFromTable(@"ensureKey",@"MyString", @"") forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(okButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [okBtn.layer setCornerRadius:5];
    [_dateView addSubview:okBtn];
    
    UIButton* cancleBtn=[[UIButton alloc]initWithFrame:CGRectMake(190, 225, 70, 40)];
    [cancleBtn setBackgroundColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
    [cancleBtn setTitle:NSLocalizedStringFromTable(@"cancelKey",@"MyString", @"") forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn.layer setCornerRadius:5];
    [_dateView addSubview:cancleBtn];
    
    [_dateView setHidden:YES];
    

    _remarksTextView.delegate=self;
    _remarksTextView.backgroundColor = [UIColor whiteColor];
    [_remarksTextView.layer setCornerRadius:5];
    
    NSString* deviceID=[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID;
    [_reserveModel startRequestBlinding4SShopWithArguments:[NSArray arrayWithObjects:deviceID, nil]];
    _reserveModel.reserveDelegate=self;
    
    _type=0;
    _ImgViewZero.image=[UIImage imageNamed:@"circleon.png"];
    _ImgViewOne.image=[UIImage imageNamed:@"circleoff.png"];
    _ImgViewTwo.image=[UIImage imageNamed:@"circleoff.png"];
    _ImgViewThree.image=[UIImage imageNamed:@"circleoff.png"];
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        CGRect frame=_lab1.frame;
        frame.origin.y+=64;
        [_lab1 setFrame:frame];
        
        frame=_lab2.frame;
        frame.origin.y+=64;
        [_lab2 setFrame:frame];
        
        frame=_currentCarLabel.frame;
        frame.origin.y+=64;
        [_currentCarLabel setFrame:frame];

        frame=_shopNameLabel.frame;
        frame.origin.y+=64;
        [_shopNameLabel setFrame:frame];

        frame=_line1.frame;
        frame.origin.y+=64;
        [_line1 setFrame:frame];
        
        frame=_line2.frame;
        frame.origin.y+=64;
        [_line2 setFrame:frame];
        
        frame=_line3.frame;
        frame.origin.y+=64;
        [_line3 setFrame:frame];
        
        frame=_line4.frame;
        frame.origin.y+=64;
        [_line4 setFrame:frame];
        
        frame=_lab3.frame;
        frame.origin.y+=64;
        [_lab3 setFrame:frame];
        
        frame=_ImgViewZero.frame;
        frame.origin.y+=64;
        [_ImgViewZero setFrame:frame];
        
        frame=_lab4.frame;
        frame.origin.y+=64;
        [_lab4 setFrame:frame];
        
        frame=_BtnZero.frame;
        frame.origin.y+=64;
        [_BtnZero setFrame:frame];
        
        frame=_ImgViewOne.frame;
        frame.origin.y+=64;
        [_ImgViewOne setFrame:frame];
        
        frame=_lab5.frame;
        frame.origin.y+=64;
        [_lab5 setFrame:frame];
        
        frame=_BtnOne.frame;
        frame.origin.y+=64;
        [_BtnOne setFrame:frame];
        
        frame=_ImgViewTwo.frame;
        frame.origin.y+=64;
        [_ImgViewTwo setFrame:frame];
        
        frame=_lab6.frame;
        frame.origin.y+=64;
        [_lab6 setFrame:frame];
        
        frame=_BtnTwo.frame;
        frame.origin.y+=64;
        [_BtnTwo setFrame:frame];
        
        frame=_ImgViewThree.frame;
        frame.origin.y+=64;
        [_ImgViewThree setFrame:frame];
        
        frame=_lab7.frame;
        frame.origin.y+=64;
        [_lab7 setFrame:frame];
        
        frame=_BtnThree.frame;
        frame.origin.y+=64;
        [_BtnThree setFrame:frame];
        
        frame=_line5.frame;
        frame.origin.y+=64;
        [_line5 setFrame:frame];
        
        frame=_lab8.frame;
        frame.origin.y+=64;
        [_lab8 setFrame:frame];
        
        frame=_dateLabel.frame;
        frame.origin.y+=64;
        [_dateLabel setFrame:frame];
        
        frame=_dateBtn.frame;
        frame.origin.y+=64;
        [_dateBtn setFrame:frame];
        
        frame=_line6.frame;
        frame.origin.y+=64;
        [_line6 setFrame:frame];
        
        frame=_lab9.frame;
        frame.origin.y+=64;
        [_lab9 setFrame:frame];
        
        frame=_submitBtn.frame;
        frame.origin.y+=64;
        [_submitBtn setFrame:frame];
        
        frame=_remarksTextView.frame;
        frame.origin.y+=64;
        [_remarksTextView setFrame:frame];
        
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];

	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        CGRect frame=_submitBtn.frame;
        frame.origin.y+=75;
        [_submitBtn setFrame:frame];
        
        frame=_remarksTextView.frame;
        frame.size.height+=60;
        [_remarksTextView setFrame:frame];
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        CGRect frame=_lab1.frame;
        frame.origin.y+=64;
        [_lab1 setFrame:frame];
        
        frame=_lab2.frame;
        frame.origin.y+=64;
        [_lab2 setFrame:frame];
        
        frame=_currentCarLabel.frame;
        frame.origin.y+=64;
        [_currentCarLabel setFrame:frame];
        
        frame=_shopNameLabel.frame;
        frame.origin.y+=64;
        [_shopNameLabel setFrame:frame];
        
        frame=_line1.frame;
        frame.origin.y+=64;
        [_line1 setFrame:frame];
        
        frame=_line2.frame;
        frame.origin.y+=64;
        [_line2 setFrame:frame];
        
        frame=_line3.frame;
        frame.origin.y+=64;
        [_line3 setFrame:frame];
        
        frame=_line4.frame;
        frame.origin.y+=64;
        [_line4 setFrame:frame];
        
        frame=_lab3.frame;
        frame.origin.y+=64;
        [_lab3 setFrame:frame];
        
        frame=_ImgViewZero.frame;
        frame.origin.y+=64;
        [_ImgViewZero setFrame:frame];
        
        frame=_lab4.frame;
        frame.origin.y+=64;
        [_lab4 setFrame:frame];
        
        frame=_BtnZero.frame;
        frame.origin.y+=64;
        [_BtnZero setFrame:frame];
        
        frame=_ImgViewOne.frame;
        frame.origin.y+=64;
        [_ImgViewOne setFrame:frame];
        
        frame=_lab5.frame;
        frame.origin.y+=64;
        [_lab5 setFrame:frame];
        
        frame=_BtnOne.frame;
        frame.origin.y+=64;
        [_BtnOne setFrame:frame];
        
        frame=_ImgViewTwo.frame;
        frame.origin.y+=64;
        [_ImgViewTwo setFrame:frame];
        
        frame=_lab6.frame;
        frame.origin.y+=64;
        [_lab6 setFrame:frame];
        
        frame=_BtnTwo.frame;
        frame.origin.y+=64;
        [_BtnTwo setFrame:frame];
        
        frame=_ImgViewThree.frame;
        frame.origin.y+=64;
        [_ImgViewThree setFrame:frame];
        
        frame=_lab7.frame;
        frame.origin.y+=64;
        [_lab7 setFrame:frame];
        
        frame=_BtnThree.frame;
        frame.origin.y+=64;
        [_BtnThree setFrame:frame];
        
        frame=_line5.frame;
        frame.origin.y+=64;
        [_line5 setFrame:frame];
        
        frame=_lab8.frame;
        frame.origin.y+=64;
        [_lab8 setFrame:frame];
        
        frame=_dateLabel.frame;
        frame.origin.y+=64;
        [_dateLabel setFrame:frame];
        
        frame=_dateBtn.frame;
        frame.origin.y+=64;
        [_dateBtn setFrame:frame];
        
        frame=_line6.frame;
        frame.origin.y+=64;
        [_line6 setFrame:frame];
        
        frame=_lab9.frame;
        frame.origin.y+=64;
        [_lab9 setFrame:frame];
        
        frame=_submitBtn.frame;
        frame.origin.y+=139;
        [_submitBtn setFrame:frame];
        
        frame=_remarksTextView.frame;
        frame.origin.y+=64;
        frame.size.height+=60;
        [_remarksTextView setFrame:frame];
        
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];

	}

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDateLabel:nil];
    [self setRemarksTextView:nil];
    [self setShopNameLabel:nil];
    [self setImgViewZero:nil];
    [self setImgViewOne:nil];
    [self setImgViewTwo:nil];
    [self setImgViewThree:nil];
    [self setSubmitBtn:nil];
    [super viewDidUnload];
}


-(void)okButtonAction:(id)sender{
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _date=[formatter stringFromDate:[_datePicker date]];
    _dateLabel.text=_date;
    [_dateView setHidden:YES];
}

-(void)cancleButtonAction:(id)sender{
    [_dateView setHidden:YES];
}

- (IBAction)dateButtonAction:(id)sender {
    [_datePicker setDate:[NSDate date]];
    [_dateView setHidden:NO];
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//UITextField的协议方法，当开始编辑时监听

    NSTimeInterval animationDuration=0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y -=180;//view的X轴上移
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];//设置调整界面的动画效果
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSTimeInterval animationDuration=0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y +=180;//view的X轴上移
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];//设置调整界面的动画效果
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark -handle Request
-(void)handleBlinding4SShop:(NSDictionary *)dictionary{
    NSArray* dataArray=[dictionary objectForKey:@"data"];
    if ([dataArray count]!=0) {
        NSDictionary* datadic=[[dataArray objectAtIndex:0] properties];
        NSString* name=[datadic objectForKey:@"name"];
        _shopNameLabel.text=name;
    }else{
        _shopNameLabel.text=@"can not find";
    }
    
}
- (IBAction)selectType:(id)sender {
    UIButton* Btn=(UIButton*)sender;
    int tag=Btn.tag;
    switch (tag) {
        case 0:
            _ImgViewZero.image=[UIImage imageNamed:@"circleon.png"];
            _ImgViewOne.image=[UIImage imageNamed:@"circleoff.png"];
            _ImgViewTwo.image=[UIImage imageNamed:@"circleoff.png"];
            _ImgViewThree.image=[UIImage imageNamed:@"circleoff.png"];
            break;
        case 1:
            _ImgViewZero.image=[UIImage imageNamed:@"circleoff.png"];
            _ImgViewOne.image=[UIImage imageNamed:@"circleon.png"];
            _ImgViewTwo.image=[UIImage imageNamed:@"circleoff.png"];
            _ImgViewThree.image=[UIImage imageNamed:@"circleoff.png"];
            break;
        case 2:
            _ImgViewZero.image=[UIImage imageNamed:@"circleoff.png"];
            _ImgViewOne.image=[UIImage imageNamed:@"circleoff.png"];
            _ImgViewTwo.image=[UIImage imageNamed:@"circleon.png"];
            _ImgViewThree.image=[UIImage imageNamed:@"circleoff.png"];
            break;
        case 3:
            _ImgViewZero.image=[UIImage imageNamed:@"circleoff.png"];
            _ImgViewOne.image=[UIImage imageNamed:@"circleoff.png"];
            _ImgViewTwo.image=[UIImage imageNamed:@"circleoff.png"];
            _ImgViewThree.image=[UIImage imageNamed:@"circleon.png"];
            break;
            
        default:
            break;
    }
    _type=tag;

}

- (IBAction)submitAction:(id)sender {
    _date=[NSString stringWithFormat:@"%@",_dateLabel.text];
    NSString* vin=[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin;
    NSString* reserveType=[NSString stringWithFormat:@"%d",_type];
    NSString* mark=[NSString stringWithFormat:@"%@",_remarksTextView.text];
    if ([_date isEqualToString:@"请点击选择预约时间"]) {
        [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:@"未选择预约时间，请选择"];
    }else{
        _submitBtn.userInteractionEnabled=NO;
        [_reserveModel startRequestSubmitWithArguments:[NSArray arrayWithObjects:vin,reserveType,_date,mark, nil]];
    }
}

-(void)handleSubmit:(NSDictionary *)dictionary{
    NSString* resultCode=[dictionary objectForKey:@"resultCode"];
    if ([resultCode isEqualToString:@"200"]) {
        NSLog(@"Reserve Submit success");
        [IVToastHUD showAsToastSuccessWithStatus:@"预约提交成功"];
    }else{
        NSLog(@"Reserve Submit failed");
        [IVToastHUD showAsToastErrorWithStatus:@"预约提交失败"];
    }
    _remarksTextView.text=@"";
    _submitBtn.userInteractionEnabled=YES;
}

-(void)reserveHistoryButton:(id)sender{
    ADReserveHistoryViewController* historyViewController=[[ADReserveHistoryViewController alloc]initWithNibName:@"ADReserveHistoryViewController" bundle:nil];
    [self.navigationController pushViewController:historyViewController animated:NO];
}


@end
