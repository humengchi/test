//
//  ADNearContactViewController.m
//  OBDClient
//
//  Created by hmc on 17/1/15.
//  Copyright (c) 2015年 AnyData.com. All rights reserved.
//

#import "ADNearContactViewController.h"
#import "ADUserFriendsCell.h"
#import "ADAppDelegate.h"
#import "NSString+TKUtilities.h"
#import "UIImage+TKUtilities.h"
#import "ADAppDelegate.h"
#import "ADRoomChatViewController.h"
#define PHONEBOOK_FRIEND

@interface ADNearContactViewController (){
    
    //在线用户
    //    NSMutableArray *onlineUsers;
    
    NSString *chatUserName;
    
    BOOL table_cell_device;
    BOOL table_cell_auth;
    BOOL table_cell_other;
    
    NSInteger hmc_friend;
}

@end

@implementation ADNearContactViewController
@synthesize theArray = _theArray;
@synthesize name, email, tel, recordID, sectionNumber;
@synthesize addressBookTemp;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _theArray = [[NSMutableArray alloc] init];
        addressBookTemp = [[NSMutableArray alloc] init];
        _rosterArray = [[NSMutableArray alloc] init];
        _blackArray = [[NSMutableArray alloc] init];
        _vehiclesModel = [[ADVehiclesModel alloc] init];
        _friendLists = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isPhoneBook = 0;
    hmc_friend = 0;
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    TKAddressBook *book = [[TKAddressBook alloc] init];
//    book.tel = @"15061364721";
//    book.name = @"ddd";
//    NSString *userContacts = [NSString stringWithFormat:@"%@", book.name];
//    if([_rosterArray containsObject:userContacts])
//        [_rosterArray removeObject:userContacts];
//    [_rosterArray insertObject:[NSString stringWithFormat:@"%@", book.name] atIndex:0];
//    [userDefaults setObject:_rosterArray forKey:[NSString stringWithFormat:@"%@_nearContactFriends", [self xmppStream].myJID.user]];
//    [userDefaults synchronize];
    
    myTableView.backgroundColor = [UIColor blackColor];
    
    //设定在线用户委托
    ADAppDelegate *del = [self appDelegate];
    del.chatDelegate = self;
    
    firstGetRoster = 1;
    //    [self getPhoneBookFirend];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTableView)
                                                 name:@"refreshTableView"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getFriendLists:)
                                                 name:@"GETFRIENDLISTS"
                                               object:nil];
    if (IOS7_OR_LATER) {
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(-WIDTH, 0, WIDTH*3, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
    }
    
    //    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    //    UIView* view_show = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //    view_show.backgroundColor = [[UIColor alloc] initWithRed:1 green:1 blue:1 alpha:0.5];
    //    view_show.tag = 3333;
    //    [mainWindow addSubview:view_show];
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView_show)];
    //    tap.numberOfTapsRequired = 1;
    //    [view_show addGestureRecognizer:tap];
    
    [self viewWillAppear:YES];
    
}

- (void)dismissView_show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *view_show = (UIView*)[keyWindow viewWithTag:3333];
    [view_show removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated
{
    //    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [super viewWillAppear:animated];
    self.title=@"最近";
    self.view.backgroundColor=[UIColor blackColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"< 选择车辆" style:UIBarButtonItemStylePlain target:self action:@selector(returnBack)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:0.0/255.0f green:148.0/255.0f blue:255.0/255.0f alpha:0.8];
    if (IOS7_OR_LATER){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        view.backgroundColor = [UIColor grayColor];
        [self.view addSubview:view];
    }
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithTitle:@"车友通讯薄" style:UIBarButtonItemStylePlain target:self action:@selector(openPhoneBook)];
    //                               initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openPhoneBook)];
    barBtn.tintColor = [UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem = barBtn;
    NSString *login = [[NSUserDefaults standardUserDefaults] objectForKey:@"ChattingUsername"];
    if (login) {
        if ([[self appDelegate] connect]) {
            NSLog(@"show buddy list");
        }
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有设置账号" delegate:self cancelButtonTitle:@"设置" otherButtonTitles:nil, nil];
        [alert show];
    }
    
//    //最近联系人
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    if([userDefaults objectForKey:[NSString stringWithFormat:@"%@_nearContactFriends", [self xmppStream].myJID.user]]){
//        if(_rosterArray.count){
//            [_rosterArray removeAllObjects];
//        }
//        _rosterArray = [[userDefaults objectForKey:[NSString stringWithFormat:@"%@_nearContactFriends", [self xmppStream].myJID.user]] mutableCopy];
//    }
//    if([userDefaults objectForKey:@"blacklist"]){
//        if(_blackArray.count){
//            [_blackArray removeAllObjects];
//        }
//        _blackArray = [[userDefaults objectForKey:@"blacklist"] mutableCopy];
//    }
    dispatch_queue_t dispatch = dispatch_queue_create("com.anydata.obdfriend", NULL);
    dispatch_async(dispatch, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getPhoneBookFirend];
        });
    });
    dispatch_async(dispatch, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getFriendListsByUserTel];
        });
    });
    dispatch_async(dispatch, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if(isPhoneBook == 1){
                [self openPhoneBook];
            }
        });
        
    });
//    dispatch_release(dispatch);
    
    //    [myTableView reloadData];
    
}

- (void)viewDidUnload
{
    //    [self setTView:nil];
    myTableView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"refreshTableView"
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"GETFRIENDLISTS"
                                                  object:nil];
}



#pragma mark -methods
//根据用户名获取服务器上的好友列表
- (void)getFriendListsByUserTel
{
    //    GETFRIENDLISTS
    NSMutableArray *phoneBookArray = [[NSMutableArray alloc] init];
    for(TKAddressBook *addressBook in addressBookTemp){
        if(addressBook.tel.length == 11)
            [phoneBookArray addObject:addressBook.tel];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"ChattingUsername"];
    [_vehiclesModel getFriendListsByUsername:@[username, phoneBookArray]];
}
//打开联系人列表
- (void)openPhoneBook
{
    if(hmc_friend == 0){
        [UIView beginAnimations:@"animations1" context:nil];
        [UIView setAnimationDuration:0.4f];
        [UIView setAnimationDelegate:self];
        self.view.frame = CGRectMake(WIDTH, self.view.frame.origin.y, WIDTH, self.view.frame.size.height);
        [UIView commitAnimations];
        [UIView beginAnimations:@"animations2" context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationDelegate:self];
        self.view.frame = CGRectMake(0, self.view.frame.origin.y, WIDTH, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    hmc_friend = 0;
    
    isPhoneBook = 1;
    self.navigationItem.rightBarButtonItem = nil;
    self.title=@"车友联系列表";
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriendInBook)];
    barBtn.tintColor = [UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem = barBtn;
    
    self.view.backgroundColor=[UIColor blackColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"< 返回" style:UIBarButtonItemStylePlain target:self action:@selector(openNearContacts)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:0.0/255.0f green:148.0/255.0f blue:255.0/255.0f alpha:0.8];
    //    [self getFriendListsByUserTel];
//    if(addressBookTemp.count == 0){  //addressBookTemp
//        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未获取访问通讯录的权限，若想访问，请进入“设置”->“隐私”->“通讯录”，获取权限。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        alertview.tag = 2222;
//        [alertview show];
//    }else if(_friendLists.count == 0){  //addressBookTemp
//        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前通讯录中的联系人，没有车随行的用户。" delegate:self cancelButtonTitle:@"添加" otherButtonTitles:@"取消", nil];
//        alertview.tag = 2223;
//        [alertview show];
//    }
    [myTableView reloadData];
}

//在通讯录中添加新的联系人
- (void)addFriendInBook
{
    ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
    picker.newPersonViewDelegate = self;
    if (IOS7_OR_LATER) {
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [picker.view addSubview:view];
    }
    picker.navigationItem.rightBarButtonItem.tintColor = [UIColor lightGrayColor];
    [self.navigationController pushViewController:picker animated:YES];
}

#pragma mark
#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 2222){
        [self openNearContacts];
    }else if (alertView.tag == 2223){
        if(buttonIndex == 1){
            [self openNearContacts];
        }else{
            ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
            picker.newPersonViewDelegate = self;
            if (IOS7_OR_LATER) {
                UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
                [view setBackgroundColor:[UIColor grayColor]];
                [picker.view addSubview:view];
            }
            picker.navigationItem.backBarButtonItem.tintColor = [UIColor lightGrayColor];
            picker.navigationItem.leftBarButtonItem.tintColor = [UIColor lightGrayColor];
            picker.navigationItem.rightBarButtonItem.tintColor = [UIColor lightGrayColor];
            [self.navigationController pushViewController:picker animated:YES];
        }
    }
}

#pragma mark
#pragma mark -ABNewPersonViewControllerDelegate
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonView didCompleteWithNewPerson:(ABRecordRef)person
{
    [self.navigationController popViewControllerAnimated:YES];
    hmc_friend = 1;
}

//打开最近联系人列表
- (void)openNearContacts
{
    [UIView beginAnimations:@"animations3" context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    self.view.frame = CGRectMake(-WIDTH, self.view.frame.origin.y, WIDTH, self.view.frame.size.height);
    [UIView commitAnimations];
    [UIView beginAnimations:@"animations4" context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    self.view.frame = CGRectMake(0, self.view.frame.origin.y, WIDTH, self.view.frame.size.height);
    [UIView commitAnimations];
    
    isPhoneBook = 0;
    self.title=@"最近联系人";
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithTitle:@"车友通讯薄" style:UIBarButtonItemStylePlain target:self action:@selector(openPhoneBook)];
    //    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openPhoneBook)];
    barBtn.tintColor = [UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem = barBtn;
    self.view.backgroundColor=[UIColor blackColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"< 选择车辆" style:UIBarButtonItemStylePlain target:self action:@selector(returnBack)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:0.0/255.0f green:148.0/255.0f blue:255.0/255.0f alpha:0.8];
    //    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:0.0/255.0f green:148.0/255.0f blue:255.0/255.0f alpha:0.8];
    [myTableView reloadData];
}

//获取电话薄中的联系人
- (void)getPhoneBookFirend
{
    //================获取通讯录中的联系人的联系方式========================================
    if(addressBookTemp.count != 0){
        [addressBookTemp removeAllObjects];
    }
    ABAddressBookRef tmpAddressBook = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        tmpAddressBook=ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(tmpAddressBook, ^(bool greanted, CFErrorRef error){
            dispatch_semaphore_signal(sema);
        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        //        dispatch_release(sema);
    }
    else{
        tmpAddressBook =ABAddressBookCreate();
    }
    //新建一个通讯录类
    ABAddressBookRef addressBooks = ABAddressBookCreate();
    //获取通讯录中的所有人
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
    //通讯录中人数
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
    //循环，获取每个人的个人信息
    for (NSInteger i = 0; i < nPeople; i++){
        //新建一个addressBook model类
        TKAddressBook *addressBook = [[TKAddressBook alloc] init];
        //获取个人
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        //获取个人名字
        CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
        CFStringRef abFullName = ABRecordCopyCompositeName(person);
        NSString *nameString = (__bridge NSString *)abName;
        NSString *lastNameString = (__bridge NSString *)abLastName;
        
        if ((__bridge id)abFullName != nil) {
            nameString = (__bridge NSString *)abFullName;
        } else {
            if ((__bridge id)abLastName != nil){
                nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
            }
        }
        addressBook.name = nameString;
        addressBook.recordID = (int)ABRecordGetRecordID(person);
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            //获取电话号码和email
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        //                        addressBook.tel = (__bridge NSString*)value;
                        addressBook.tel = [[(__bridge NSString*)value stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@"+86" withString:@""];
                        
                        break;
                    }
                    case 1: {// Email
                        addressBook.email = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
        [addressBookTemp addObject:addressBook];
        if (abName) CFRelease(abName);
        if (abLastName) CFRelease(abLastName);
        if (abFullName) CFRelease(abFullName);
    }
    if(allPeople)
        CFRelease(allPeople);
    if(addressBooks)
        CFRelease(addressBooks);
}


#pragma mark -NSNotification
//处理从服务器上获取的联系人
- (void)getFriendLists:(NSNotification*)notification
{
    NSArray *resultArray = [(NSDictionary*)[notification object] objectForKey:@"data"];
    if(resultArray.count > 0){
        if(_friendLists.count){
            [_friendLists removeAllObjects];
        }
        for(NSDictionary *dict in resultArray){
            TKAddressBook *addressBook = [[TKAddressBook alloc] init];
            addressBook.name = [dict objectForKey:@"uname"];
            addressBook.tel = [dict objectForKey:@"smsNum"];
            if(![_friendLists containsObject:addressBook])
                [_friendLists addObject:addressBook];
            
        }
    }
    //最近联系人
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:[NSString stringWithFormat:@"%@_nearContactFriends", [self xmppStream].myJID.user]]){
        if(_rosterArray.count){
            [_rosterArray removeAllObjects];
        }
        _rosterArray = [[userDefaults objectForKey:[NSString stringWithFormat:@"%@_nearContactFriends", [self xmppStream].myJID.user]] mutableCopy];
    }
    if([userDefaults objectForKey:@"blacklist"]){
        if(_blackArray.count){
            [_blackArray removeAllObjects];
        }
        _blackArray = [[userDefaults objectForKey:@"blacklist"] mutableCopy];
    }
    [myTableView reloadData];
}

//刷新
- (void)refreshTableView
{
    if(_rosterArray.count)
        [_rosterArray removeAllObjects];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:[NSString stringWithFormat:@"%@_nearContactFriends", [self xmppStream].myJID.user]]){
        _rosterArray = [[userDefaults objectForKey:[NSString stringWithFormat:@"%@_nearContactFriends", [self xmppStream].myJID.user]] mutableCopy];
    }
    [myTableView reloadData];
}

//返回上一级
- (void)returnBack
{
    //    [(ADMainWindow *)self.view.window transitionToMainViewController];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//跳转到聊天界面
- (IBAction)JumpButton:(id)sender {
    ADGroupChatViewController* groupchat=[[ADGroupChatViewController alloc]initWithNibName:@"ADGroupChatViewController" bundle:nil];
    [self.navigationController pushViewController:groupchat animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isPhoneBook == 0){
        return _rosterArray.count;
    }else{
        //        return addressBookTemp.count;
        return _friendLists.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isPhoneBook == 0){
        static NSString *indentify = @"ADUserFriendsCell";
        ADUserFriendsCell *cell = (ADUserFriendsCell*)[tableView dequeueReusableCellWithIdentifier:indentify];
        if(cell==nil){
            cell = [[ADUserFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
        }
        NSLog(@"%d  ===   %d", _rosterArray.count, indexPath.row);
        NSString *names = [_rosterArray objectAtIndex:indexPath.row];
        
        NSString *telnumber = [self getPhoneByUsername:names];
        if([_blackArray containsObject:names]){
            cell.callNumber.text = @"屏蔽";
            if(![self getUsernameByPhonenumber:telnumber]){
                cell.groupName.text = [NSString stringWithFormat:@"%@(陌生人)", names];
            }else{
                cell.groupName.text = [self getUsernameByPhonenumber:telnumber];
            }
            [cell.imageview setImage:[UIImage imageNamed:@"chattingBtnUnselected.png"]];
        }else{
            if([_theArray containsObject:names]){
                cell.groupName.text = [self getUsernameByPhonenumber:telnumber];;
                [cell.imageview setImage:[UIImage imageNamed:@"chattingBtnSelected"]];
            }else{
                if(![self getUsernameByPhonenumber:telnumber]){
                    cell.groupName.text = [NSString stringWithFormat:@"%@(陌生人)", names];
                }else{
                    cell.groupName.text = [self getUsernameByPhonenumber:telnumber];
                }
                [cell.imageview setImage:[UIImage imageNamed:@"chattingBtnSelected.png"]];
            }
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            NSString *key = [NSString stringWithFormat:@"%@_newsnumber", [NSString stringWithFormat:@"%@_%@", [userDefault objectForKey:@"ChattingUsername"], names]];
            NSString *newsNumber = [userDefault objectForKey:key];
            if (newsNumber == nil || [newsNumber isEqualToString:@"0"]) {
                cell.newsNum.hidden = YES;
                cell.callNumber.hidden = YES;
            }else{
                cell.callNumber.text = newsNumber;
            }
        }
        cell.backgroundColor = [UIColor blackColor];
        return cell;
    }else{
        //        TKAddressBook *book = [addressBookTemp objectAtIndex:indexPath.row];
        TKAddressBook *book = [_friendLists objectAtIndex:indexPath.row];
        //        XMPPJID *FriendJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@pc163.anydata.sh", book.tel]];
        static NSString *indentify = @"ADUserFriendsCell";
        ADUserFriendsCell *cell = (ADUserFriendsCell*)[tableView dequeueReusableCellWithIdentifier:indentify];
        if(cell==nil){
            cell = [[ADUserFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
        }
        if([_blackArray containsObject:[book name]]){
            cell.callNumber.text = @"屏蔽";
            cell.groupName.text = [self getUsernameByPhonenumber:[book tel]];
            [cell.imageview setImage:[UIImage imageNamed:@"chattingBtnUnselected.png"]];
        }else{
            if([_theArray containsObject:[book name]]){
                cell.groupName.text = [self getUsernameByPhonenumber:[book tel]];
                [cell.imageview setImage:[UIImage imageNamed:@"chattingBtnSelected"]];
            }else{
                cell.groupName.text = [self getUsernameByPhonenumber:[book tel]];
                [cell.imageview setImage:[UIImage imageNamed:@"chattingBtnSelected.png"]];
            }
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            NSString *key = [NSString stringWithFormat:@"%@_newsnumber", [NSString stringWithFormat:@"%@_%@", [userDefault objectForKey:@"ChattingUsername"], [book name]]];
            NSString *newsNumber = [userDefault objectForKey:key];
            if (newsNumber == nil || [newsNumber isEqualToString:@"0"]) {
                cell.newsNum.hidden = YES;
                cell.callNumber.hidden = YES;
            }else{
                cell.callNumber.text = newsNumber;
            }
        }
        cell.backgroundColor = [UIColor blackColor];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    ADRoomChatViewController *roomVC = [[ADRoomChatViewController alloc] init];
    //    [self.navigationController pushViewController:roomVC animated:YES];
    //    return;
    if(isPhoneBook == 0){
        ADGroupChatViewController* groupchat=[[ADGroupChatViewController alloc]initWithNibName:@"ADGroupChatViewController" bundle:nil];
        //        groupchat.title = [[_rosterArray objectAtIndex:indexPath.row] user];
        //        groupchat.chatWithUsers = [_rosterArray objectAtIndex:indexPath.row];
        
        NSString *names = [_rosterArray objectAtIndex:indexPath.row];
        NSString *telnumber = [self getPhoneByUsername:names];
        if(telnumber.length == 0){
            groupchat.title = names;
        }else{
            groupchat.title = [self getUsernameByPhonenumber:telnumber];
        }
        
        groupchat.chatWithUsers = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@pc163.anydata.sh", names]];
        groupchat.scene = indexPath.section;
        [self.navigationController pushViewController:groupchat animated:YES];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *userContacts = [NSString stringWithFormat:@"%@", names];
        if([_rosterArray containsObject:userContacts])
            [_rosterArray removeObject:userContacts];
        [_rosterArray insertObject:userContacts atIndex:0];
        
        [userDefaults setObject:_rosterArray forKey:[NSString stringWithFormat:@"%@_nearContactFriends", [self xmppStream].myJID.user]];
        [userDefaults synchronize];
    }else{
        ADGroupChatViewController* groupchat=[[ADGroupChatViewController alloc]initWithNibName:@"ADGroupChatViewController" bundle:nil];
        groupchat.title = [self getUsernameByPhonenumber:[[_friendLists objectAtIndex:indexPath.row] tel]];
        groupchat.chatWithUsers = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@pc163.anydata.sh", [[_friendLists objectAtIndex:indexPath.row] name]]];
        groupchat.scene = indexPath.section;
        self.title = @"最近联系人";
        [self.navigationController pushViewController:groupchat animated:YES];
        
        //#ifdef NEARCONTACTFRIEND
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        TKAddressBook *book = [_friendLists objectAtIndex:indexPath.row];
        NSString *userContacts = [NSString stringWithFormat:@"%@", book.name];
        if([_rosterArray containsObject:userContacts])
            [_rosterArray removeObject:userContacts];
        [_rosterArray insertObject:[NSString stringWithFormat:@"%@", book.name] atIndex:0];
        [userDefaults setObject:_rosterArray forKey:[NSString stringWithFormat:@"%@_nearContactFriends", [self xmppStream].myJID.user]];
        [userDefaults synchronize];
        //#endif
        isPhoneBook = 0;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete && isPhoneBook == 0) {
        
        //先行删除阵列中的物件
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [_rosterArray removeObjectAtIndex:indexPath.row];
        [userDefaults setObject:_rosterArray forKey:[NSString stringWithFormat:@"%@_nearContactFriends", [self xmppStream].myJID.user]];
        [userDefaults synchronize];
        
        //删除 UITableView 中的物件，并设定动画模式
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

//获取好友列表的方法
- (void)queryRoster {
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    XMPPJID *myJID = [self xmppStream].myJID;
    [iq addAttributeWithName:@"from" stringValue:myJID.description];
    [iq addAttributeWithName:@"to" stringValue:myJID.domain];
    [iq addAttributeWithName:@"id" stringValue:@"111111"];
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    [iq addChild:query];
    [self.xmppStream sendElement:iq];
}


//取得当前程序的委托
-(ADAppDelegate *)appDelegate{
    
    return (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
    
}

//取得当前的XMPPStream
-(XMPPStream *)xmppStream{
    return [[self appDelegate] xmppStream];
}

#pragma mark -chatDelegate
//在线好友
-(void)newBuddyOnline:(NSString *)buddyName{
    return;
    if (![_theArray containsObject:buddyName]) {
        [_theArray addObject:buddyName];
        if(isPhoneBook == 0)
            [myTableView reloadData];
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"blacklist"])
        _blackArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"blacklist"] mutableCopy];
}

//好友下线
-(void)buddyWentOffline:(NSString *)buddyName{
    return;
    [_theArray removeObject:buddyName];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"blacklist"])
        _blackArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"blacklist"] mutableCopy];
    if(isPhoneBook == 0)
        [myTableView reloadData];
    
}

//获取好友列表
- (void)getRoster:(NSArray *)theArray
{
    return;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"blacklist"])
        _blackArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"blacklist"] mutableCopy];
    [myTableView reloadData];
    if(firstGetRoster){
        _rosterArray = [theArray mutableCopy];
        if(isPhoneBook == 0)
            [myTableView reloadData];
        firstGetRoster = 0;
    }
}


#pragma mark -getUsernameByPhonenumber
//在本地的电话薄中根据手机号获取备注名
- (NSString*)getUsernameByPhonenumber:(NSString*)phone
{
    for(TKAddressBook *book in addressBookTemp){
        if([book.tel isEqualToString:phone]){
            return book.name;
        }
    }
    return nil;
}

//从服务器上获取的电话联系人列表中获取用户名
- (NSString*)getUsernameByPhonenumber_net:(NSString*)phone
{
    for(TKAddressBook *book in _friendLists){
        if([book.tel isEqualToString:phone]){
            return book.name;
        }
    }
    return nil;
}

//从服务器上获取的电话联系人列表,根据用户名获取手机号
- (NSString*)getPhoneByUsername:(NSString*)Username
{
    for(TKAddressBook *book in _friendLists){
        if([book.name isEqualToString:Username]){
            return book.tel;
        }
    }
    return nil;
}

@end

