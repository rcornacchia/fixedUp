//
//  FXLoginVC.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXLoginVC.h"
#import "FXMenuVC.h"
#import "FXUser.h"

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
   
    
    [FXUser sharedUser];
    
//    [self gotoMainView];
//    
//    return;
    
    loginFlag = NO;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if([FBSDKAccessToken currentAccessToken]){
        loginFlag = YES;
        [self fetchFacebookUserProfile];
    }else{
        
        
        NSArray * permissions = [[NSArray alloc] initWithObjects:@"email",@"user_hometown",@"user_location",@"user_relationships",@"user_birthday",@"user_work_history",@"user_religion_politics",@"user_education_history",@"user_friends", nil];
        [APP.loginManager logInWithReadPermissions:permissions handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
            if (error != nil) {
                NSString *alertMessage, *alertTitle;
                alertTitle  = @"Something went wrong";
                alertMessage = @"Please try again later.";
                
                [[[UIAlertView alloc] initWithTitle:alertTitle
                                            message:alertMessage
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }else{
                if (!loginFlag) {
                    loginFlag = YES;
                    [self fetchFacebookUserProfile];
              
                }
            }
            
            
        }];
    }
    
}


-(void)fetchFacebookUserProfile
{
   
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if(!error){
            NSDictionary * tempDic = (NSDictionary *)result;
            if (tempDic == nil) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [[[UIAlertView alloc] initWithTitle:@"" message:@"Can not fetch your profile now ." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                return ;
            }
            FXUser * user = [FXUser sharedUser];
            
            NSString * tempStr;
            NSArray * tempArray;
           
            
            user.fb_id = [tempDic objectForKey:@"id"];
            user.name = [tempDic objectForKey:@"name"]; // last_name, middle_name,
            user.email = [tempDic objectForKey:@"email"];
            user.sex = [[tempDic objectForKey:@"gender"] isEqualToString:@"male"] ? NO:YES; // male = NO, female = YES
            
            user.birthday = [tempDic objectForKey:@"birthday"];  // MM/ddd/yyyy
            
            tempStr = [tempDic objectForKey:@"relationship_status"];
            if (tempStr == nil || [tempStr isEqualToString:@""]) {
                user.single = NO;
            }else if([tempStr isEqualToString:@"Single"]){
                user.single = YES;
            }else{
                user.single = NO;
            }
            
            // Work Place
            tempArray = [tempDic objectForKey:@"work"];
            NSMutableString * workStr = [[NSMutableString alloc] initWithString:@""];
            if (tempArray !=nil ) {
                
                for (int i = 0 ; i < [tempArray count] ; i++){
                    if (i != 0 ) {
                        [workStr appendString:@","];
                    }
                    
                    NSDictionary * workDic = [tempArray objectAtIndex:i];
                    NSDictionary * employerDic = [workDic objectForKey:@"employer"];
                    [workStr appendString:[employerDic objectForKey:@"name"]];
                    
                }
            }
           
            user.workplace = workStr;
            
            // Education History
            
            tempArray = [tempDic objectForKey:@"education"];
            NSMutableString * educationStr = [[NSMutableString alloc] initWithString:@""];
            if (tempArray !=nil ) {
                
                for (int i = 0 ; i < [tempArray count] ; i++){
                    if (i != 0 ) {
                        [educationStr appendString:@","];
                    }
                    
                    NSDictionary * educationDic = [tempArray objectAtIndex:i];
                    NSDictionary * schoolDic = [educationDic objectForKey:@"school"];
                    [educationStr appendString:[schoolDic objectForKey:@"name"]];
                    
                }
            }
            
            user.schools = educationStr;
           
            NSDictionary * locationDic = [tempDic objectForKey:@"address"];
            NSString * stateStr = @"";
            NSString * cityStr = @"";
            NSString * streetStr = @"";
            NSString * zipcodeStr = @"";

            
            if (locationDic != nil) {
                stateStr = [locationDic objectForKey:@"state"] != nil ? [locationDic objectForKey:@"state"] :@"";
                cityStr = [locationDic objectForKey:@"city"] != nil ? [locationDic objectForKey:@"city"] :@"";
                streetStr = [locationDic objectForKey:@"street"] != nil ? [locationDic objectForKey:@"street"] :@"";
                zipcodeStr = [locationDic objectForKey:@"zip"] != nil ? [locationDic objectForKey:@"zip"] :@"";
            }
            
            user.state = stateStr;
            user.city = cityStr;
            user.street = streetStr;
            user.zipcode = zipcodeStr;
            
            user.religion = (int) [FXUser indexFromReligionStr:[tempDic objectForKey:@"religion"]];
            [self fectchUserFacebookFriendList];
            return;
            
        }
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
         [[[UIAlertView alloc] initWithTitle:@"" message:@"Facebook Connection Failed !" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        
        }];
    
}

        
-(void)fectchUserFacebookFriendList{

    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends" parameters:nil] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
             {
                 NSString * fbFriendListStr =@"";
                 
                 if(!error){
                     NSDictionary * tempDic = (NSDictionary *)result;
                     if (tempDic == nil) {
                         [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                         [[[UIAlertView alloc] initWithTitle:@"" message:@"Can not fetch Friend List now ." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                      
                     }else{
                         NSArray * fbFriendList = [tempDic objectForKey:@"data"];
                         
                         NSMutableArray * friendIds = [[NSMutableArray alloc] init];
                         if (fbFriendList != nil) {
                             NSDictionary * friendDic;
                             for (int i = 0 ; i < [fbFriendList count];  i++) {
                                 friendDic = [fbFriendList objectAtIndex:i];
                                 [friendIds addObject:[friendDic objectForKey:@"id"]];
                             }
                         }
                         
                         SBJsonWriter * writer  = [[SBJsonWriter alloc] init];
                         fbFriendListStr = [writer stringWithObject:friendIds];
                     }
                 }
                 
                  FXUser * user = [FXUser sharedUser];
                 
                 if(APP.deviceToken == nil){
                     APP.deviceToken = @"";
                 }
                 
                 NSString * postStr = [NSString stringWithFormat:@"fb_id=%@&name=%@&email=%@&sex=%i&birthday=%@&single=%i&workplace=%@&schools=%@&state=%@&city=%@&street=%@&zipcode=%@&latitude=%.6f&longitude=%.6f&religion=%i&devicetoken=%@&fb_friend_list=%@",user.fb_id, user.name,user.email, user.sex,user.birthday, user.single, user.workplace, user.schools, user.state, user.city, user.street, user.zipcode, APP.currentLocation.coordinate.latitude, APP.currentLocation.coordinate.longitude, user.religion,APP.deviceToken,fbFriendListStr];
                 
                 if ([[FXUser sharedUser] fbSigin:postStr withView:self.view]) {
                     
                     [[FXUser sharedUser] fetchSuggestedFriends:self.view];
                     
                     [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                     [self gotoMainView];
                     
                     return ;
                 }

                 
                  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 
             }];
}


-(void)gotoMainView
{
    JDSideMenu * sideMenu;
    UINavigationController  * contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FXMainNavigationController"];
    FXMenuVC  * menuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FXMenuVC"];
    sideMenu = [[JDSideMenu alloc] initWithContentController:contentViewController menuController:menuVC];
    
    APP.activeContainer = contentViewController;
    
    [APP.window setRootViewController:sideMenu];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self QBChatLogin];
    });
   
}


-(void)QBChatLogin{
    
    QBSessionParameters *extendedAuthRequest = [[QBSessionParameters alloc] init];
    
    extendedAuthRequest.userLogin = [FXUser sharedUser].fb_id;
    extendedAuthRequest.userPassword = DEFAULT_QBPASSWORD;
    
    //
    __weak __typeof(self)weakSelf = self;
    [QBRequest createSessionWithExtendedParameters:extendedAuthRequest successBlock:^(QBResponse *response, QBASession *session) {
        
        
        // Save current user
        //
        QBUUser *currentUser = [QBUUser user];
        currentUser.ID = session.userID;
    
        currentUser.login = [FXUser sharedUser].fb_id;;
        currentUser.password = DEFAULT_QBPASSWORD;
        
        // Login to QuickBlox Chat
        //
        [[ChatService shared] loginWithUser:currentUser completionBlock:^{
        
             [[FXUser sharedUser] submitQBUserId:currentUser.ID];
            
            NSLog(@"QB Log in !");
   
        }];
        
    } errorBlock:^(QBResponse *response)
    {
        if (response.status == QBResponseStatusCodeUnAuthorized) {
            
            [self QBSignup];
        }else{
        
        NSLog(@"QB Create Session Failed!");
        }
        
    }];
}

// Create QuickBlox User entity
-(void)QBSignup{
    
    [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session) {
        
        QBUUser *user = [QBUUser user];
        user.password = DEFAULT_QBPASSWORD;
        user.login = [FXUser sharedUser].fb_id;
        user.fullName = [FXUser sharedUser].name;
        
        // create User
        [QBRequest signUp:user successBlock:^(QBResponse *response, QBUUser *user) {
            
            [[FXUser sharedUser] submitQBUserId:user.ID];
            
            [self QBChatLogin];
            
        } errorBlock:^(QBResponse *response) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", "")
                                                            message:[response.error description]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", "")
                                                  otherButtonTitles:nil];
            [alert show];
            
        }];

    } errorBlock:^(QBResponse *response) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", "")
                                                        message:[response.error description]
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", "")
                                              otherButtonTitles:nil];
        [alert show];
    }];
   
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
