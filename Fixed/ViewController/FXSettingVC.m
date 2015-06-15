//
//  FXSettingVC.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXSettingVC.h"
#import "UIViewController+JDSideMenu.h"
#import "FXLoginVC.h"

@interface FXSettingVC ()<UITextFieldDelegate>
{
    IBOutlet UITextField *emailTextField;
    
    IBOutlet UIButton *logOutButton;
    IBOutlet UIButton * deleteButton;
    
    IBOutlet UIScrollView *settingScrollView;
    
    IBOutlet UISwitch * fixReminder;
    IBOutlet UISwitch * cashNotification;
    IBOutlet UISwitch * matchNotification;
    IBOutlet UISwitch * chatNotification;
    
    IBOutlet UISwitch * alertSwitch;
    IBOutlet UISwitch * updateSwitch;

}

@end

@implementation FXSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSettingView];
}

-(void)initSettingView
{
    emailTextField.delegate = self;
    logOutButton.layer.cornerRadius = 5;
    deleteButton.layer.cornerRadius = 5;
    
    FXUser * user = [FXUser sharedUser];
    
    [fixReminder setOn:user.fix_reminder];
    [cashNotification setOn:user.cash_notification];
    [matchNotification setOn:user.match_notification];
    [chatNotification setOn:user.chat_notification];
    
    [alertSwitch setOn:user.alert_setting];
    [updateSwitch setOn:user.update_setting];
    
    emailTextField.text = user.email;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)onMenu:(id)sender
{
    if([self.sideMenuController isMenuVisible])
    {
        [self.sideMenuController hideMenuAnimated:YES];
    }else{
        [self.sideMenuController showMenuAnimated:YES];
    }
}

-(IBAction)onLogout:(id)sender
{
    [[FXUser sharedUser] logout];

    [APP.loginManager logOut];
    
    FXLoginVC * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FXLoginVC"];
    APP.window.rootViewController = controller;
}

-(IBAction)onDeleteAccount:(id)sender
{
    if([[FXUser sharedUser] deleteAccount:self.view]){
        [[FXUser sharedUser] logout];
        FXLoginVC * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FXLoginVC"];
        APP.window.rootViewController = controller;
    }else{
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Failed!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }
}

/// TextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [settingScrollView setContentOffset:CGPointZero];
    [textField resignFirstResponder];
    [self saveEmail];
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [settingScrollView setContentOffset:CGPointMake(0, 60)];
    return YES;
}

-(IBAction)onFixReminder:(id)sender
{
    [[FXUser sharedUser] changeSetting:REMINDER_SETTING withValue:fixReminder.isOn];
}

-(IBAction)onCashNotification:(id)sender
{
     [[FXUser sharedUser] changeSetting:CASH_SETTING withValue:cashNotification.isOn];
}

-(IBAction)onMatchNotification:(id)sender{
     [[FXUser sharedUser] changeSetting:MATCH_SETTING withValue:matchNotification.isOn];
}

-(IBAction)onChatNotification:(id)sender{
     [[FXUser sharedUser] changeSetting:CHAT_SETTING withValue:chatNotification.isOn];
}

-(IBAction)onAlert:(id)sender{
     [[FXUser sharedUser] changeSetting:ALET_SETTTING withValue:alertSwitch.isOn];
}

-(IBAction)onUpdate:(id)sender{
     [[FXUser sharedUser] changeSetting:UPDATE_SETTING withValue:updateSwitch.isOn];
}

-(void)saveEmail{
     [[FXUser sharedUser] changeEmail:emailTextField.text];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
