//
//  ADNearContactViewController.h
//  OBDClient
//
//  Created by hmc on 17/1/15.
//  Copyright (c) 2015年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADBaseViewController.h"
#import "ADGroupChatViewController.h"
#import "KKChatDelegate.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <malloc/malloc.h>
#import "TKAddressBook.h"
#import "ADVehiclesModel.h"
#import "ADSingletonUtil.h"

@interface ADNearContactViewController :ADBaseViewController<UITableViewDataSource, UITableViewDelegate,KKChatDelegate, UIAlertViewDelegate, ABNewPersonViewControllerDelegate>
{
    __weak IBOutlet UITableView *myTableView;
    
    NSInteger sectionNumber;
    NSInteger recordID;
    NSString *name;
    NSString *email;
    NSString *tel;
    NSInteger firstGetRoster;
    
    NSInteger isPhoneBook;      //当前列表中显示的是电话薄还是最近联系人
}
@property NSInteger sectionNumber;
@property NSInteger recordID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *tel;

@property (nonatomic, strong) NSMutableArray *rosterArray;   //最近联系人
@property (nonatomic, strong) NSMutableArray *blackArray;   //拉黑的好友
@property (nonatomic, retain) NSMutableArray *theArray;      //在线好友
@property (nonatomic, strong) NSMutableArray *addressBookTemp; //手机电话薄里的好友列表

@property (nonatomic, strong) NSMutableArray *friendLists;  //从服务器上获取的好友列表

@property (nonatomic) ADVehiclesModel *vehiclesModel;




- (IBAction)JumpButton:(id)sender;
@end
