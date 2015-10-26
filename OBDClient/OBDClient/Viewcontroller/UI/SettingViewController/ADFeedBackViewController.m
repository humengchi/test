//
//  ADFeedBackViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-12-13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADFeedBackViewController.h"

@interface ADFeedBackViewController ()<UITextViewDelegate>
@property (nonatomic) ADUserDetailModel *userModel;
@end

@implementation ADFeedBackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _userModel=[[ADUserDetailModel alloc]init];
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter addObserver:self
                       selector:@selector(feedbackSubmitSuccess:)
                           name:ADUserUserFeedbackSubmitSuccessNotification
                         object:nil];
    }
    return self;
}

- (void)dealloc{
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self
                          name:ADUserUserFeedbackSubmitSuccessNotification
                        object:nil];
    [_userModel cancel];
}

- (void)feedbackSubmitSuccess:(NSNotification *)aNoti{
    [IVToastHUD showSuccessWithStatus:@"提交成功"];
    _feedBackText.text=@"";
}

- (void)viewDidLoad
{
    self.title=NSLocalizedStringFromTable(@"feedbackKey",@"MyString", @"");
    [super viewDidLoad];
    UIBarButtonItem *submitButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(submitTapFeedBakc:)];
    self.navigationItem.rightBarButtonItem=submitButton;
    submitButton.tintColor=[UIColor lightGrayColor];
    // Do any additional setup after loading the view from its nib.
    if (IOS7_OR_LATER) {
        CGRect frame=_feedBackText.frame;
        frame.origin.y+=64;
        [_feedBackText setFrame:frame];
        submitButton.tintColor=[UIColor lightGrayColor];
    }
    [_feedBackText.layer setCornerRadius:7];
    _feedBackText.delegate = self;
    _feedBackText.text = @"请留下您宝贵的意见和建议，我们讲不胜感激！";
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [_feedBackText.layer setBorderWidth:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFeedBackText:nil];
    [super viewDidUnload];
}
- (void)submitTapFeedBakc:(id)sender {
    [self.view endEditing:YES];
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];
    [_userModel submitFeedBackWithArguments:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].globalUserBase.userID,_feedBackText.text, nil]];
}

#pragma mark 
#pragma mark -UITextView
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _feedBackText.text = nil;
    _feedBackText.textColor = [UIColor blackColor];
}

@end
