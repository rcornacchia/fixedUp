//
//  FXMenuVC.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXMenuVC.h"
#import "FXMainVC.h"
#import "FXProfileVC.h"
#import "FXSettingVC.h"
#import "FXMatchPreferenceVC.h"
#import "FXMyMatchVC.h"

#import "UIViewController+JDSideMenu.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface FXMenuVC ()<MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet UIView * menuContainerView;

    NSInteger selectedIndex;
}
@end

@implementation FXMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    selectedIndex = 0;
    menuContainerView.layer.cornerRadius = 15;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onFixFriend:(id)sender
{
    if (selectedIndex != 0) {
        UINavigationController * navController = (UINavigationController *)[self sideMenuController].contentController;
        FXMainVC * mainVC = (FXMainVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"FXMainVC"];
        [navController setViewControllers:@[mainVC] animated:YES];
    }
    
    [[self sideMenuController] hideMenuAnimated:YES];

    selectedIndex = 0;
    
}

-(IBAction)onProfile:(id)sender
{
    if (selectedIndex != 1) {
        UINavigationController * navController = (UINavigationController *)[self sideMenuController].contentController;
        FXProfileVC * profileVC = (FXProfileVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"FXProfileVC"];
        profileVC.isMyProfile = YES;
        
        [navController setViewControllers:@[profileVC] animated:YES];
    }
    
    [[self sideMenuController] hideMenuAnimated:YES];
    
    selectedIndex = 1;
}


-(IBAction)onSetting:(id)sender
{
    if (selectedIndex != 2) {
        UINavigationController * navController = (UINavigationController *)[self sideMenuController].contentController;
        FXSettingVC * profileVC = (FXSettingVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"FXSettingVC"];
        
        [navController setViewControllers:@[profileVC] animated:YES];
    }
    
    [[self sideMenuController] hideMenuAnimated:YES];
    
    selectedIndex = 2;
}

-(IBAction)onPreference:(id)sender
{
    if (selectedIndex != 3) {
        UINavigationController * navController = (UINavigationController *)[self sideMenuController].contentController;
        FXMatchPreferenceVC * profileVC = (FXMatchPreferenceVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"FXMatchPreferenceVC"];
        
        
        [navController setViewControllers:@[profileVC] animated:YES];
    }
    
    [[self sideMenuController] hideMenuAnimated:YES];
    
    selectedIndex = 3;
}


-(IBAction)onMyMatches:(id)sender
{
    if (selectedIndex != 6) {
        UINavigationController * navController = (UINavigationController *)[self sideMenuController].contentController;
        FXMyMatchVC * profileVC = (FXMyMatchVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"FXMyMatchVC"];
        
        
        [navController setViewControllers:@[profileVC] animated:YES];
    }
    
    [[self sideMenuController] hideMenuAnimated:YES];
    
    selectedIndex = 6;
}

-(IBAction)onFeedBack:(id)sender
{
    if (![MFMailComposeViewController canSendMail])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert", @"Alert")
                                                        message:NSLocalizedString(@"Your device doesn't support this feature.", @"Your device doesn't support this feature.")
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                              otherButtonTitles: nil];
        
        alert.tag = -1;
        [alert show];
        return;
    }
    
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    NSString* strSubject = [NSString stringWithFormat:@"Fixed APP"];
    [picker setSubject:strSubject];
    [picker setToRecipients:@[@"fixedApp@gmail.com"]];
    [self presentViewController:picker animated:YES completion:nil];

}



- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
            
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Email", @"Email") message:NSLocalizedString(@"Sending Failed - Unknown Error :-(", @"Sending Failed - Unknown Error :-(")
                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles: nil];
            alert.tag = -1;
            [alert show];
            
        }
            
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
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
