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
        //       logInWithReadPermissions logInWithPublishPermissions
        // user_interests user_relationships user_birthday user_work_history  read_custom_friendlists  user_religion_politics  user_education_history
        
        NSArray * permissions = [[NSArray alloc] initWithObjects:@"email",@"user_interests",@"user_relationships",@"user_birthday",@"user_work_history",@"read_custom_friendlists",@"user_religion_politics",@"user_education_history", nil];
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
            NSDictionary * dic;
            
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
            user.interest = [tempDic objectForKey:@"quotes"] == nil ? @"" : [tempDic objectForKey:@"quotes"];
            
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
                 
                 NSString * postStr = [NSString stringWithFormat:@"fb_id=%@&name=%@&email=%@&sex=%i&birthday=%@&single=%i&workplace=%@&schools=%@&interest=%@&state=%@&city=%@&street=%@&zipcode=%@&latitude=%.6f&longitude=%.6f&religion=%i&devicetoken=%@&fb_friend_list=%@",user.fb_id, user.name,user.email, user.sex,user.birthday, user.single, user.workplace, user.schools, user.interest, user.state, user.city, user.street, user.zipcode, APP.currentLocation.coordinate.latitude, APP.currentLocation.coordinate.longitude, user.religion,APP.deviceToken,fbFriendListStr];
                 
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
