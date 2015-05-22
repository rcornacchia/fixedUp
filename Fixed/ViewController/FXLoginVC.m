//
//  FXLoginVC.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXLoginVC.h"
#import "FXMenuVC.h"


@interface FXLoginVC ()
{
    BOOL  loginFlag;
}

@end

@implementation FXLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)facebookSignIn:(id)sender {
   
    
    [self gotoMainView];
    
    return;
    
    loginFlag = NO;
    
    if([FBSDKAccessToken currentAccessToken]){
        loginFlag = YES;
        [self getFriendList];
    }else{
        //       logInWithReadPermissions logInWithPublishPermissions
        [APP.loginManager logInWithReadPermissions:@[@"emails"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
            if (error != nil) {
                NSString *alertMessage, *alertTitle;
                alertTitle  = @"Something went wrong";
                alertMessage = @"Please try again later.";
                
                [[[UIAlertView alloc] initWithTitle:alertTitle
                                            message:alertMessage
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            }else{
                if (!loginFlag) {
                    
                    loginFlag = YES;
                    [self getFriendList];
                }
            }
            
            
        }];
    }
    
}

-(void)getFriendList
{
    
}


-(void)gotoMainView
{
    JDSideMenu * sideMenu;
    UINavigationController  * contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FXMainNavigationController"];
    FXMenuVC  * menuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FXMenuVC"];
    sideMenu = [[JDSideMenu alloc] initWithContentController:contentViewController menuController:menuVC];
    
    APP.activeContainer = contentViewController;
    
    [APP.window setRootViewController:sideMenu];
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
