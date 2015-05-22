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
    
    FXLoginVC * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FXLoginVC"];
    APP.window.rootViewController = controller;
}

-(IBAction)onDeleteAccount:(id)sender
{
    
}

/// TextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [settingScrollView setContentOffset:CGPointZero];
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [settingScrollView setContentOffset:CGPointMake(0, 60)];
    return YES;
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
