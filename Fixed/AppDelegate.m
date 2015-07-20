//
//  AppDelegate.m
//  Fixed
//
//  Created by wang on 5/11/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()<CLLocationManagerDelegate>
{
    CLLocationManager * locationManager;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
     

    // Facebook init
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    _loginManager = [[FBSDKLoginManager alloc] init];
    
    
    
    // QuickBlox
    
    [QBApplication sharedApplication].applicationId = QBAppId;
    [QBConnection registerServiceKey:QBServiceKey];
    [QBConnection registerServiceSecret:QBServiceSecret];
    [QBSettings setAccountKey:QBAccountKey];

    // In-App purchase
    
    [MKStoreManager sharedManager];
    
    //
    // Setting PushNotification\
    
    if (IS_OS_8_OR_LATER) {
        
        UIUserNotificationSettings * settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge) categories:nil];
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }
        
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
    }

    
    // Getting Location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 2;
    locationManager.delegate = self;
    
    self.currentLocation = nil;
    if(IS_OS_8_OR_LATER){
        if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [locationManager requestAlwaysAuthorization];
        }
    }
       
    
    [locationManager startUpdatingLocation];

    
    UILocalNotification * notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (notification != nil) {
        
        [self receiveNotification:notification];
        
    }

    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // Logout from chat
    //
  //  [[ChatService shared] logout];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    // Login to QuickBlox Chat
    //
//    [SVProgressHUD showWithStatus:@"Restoring chat session"];
//    [[ChatService shared] loginWithUser:[ChatService shared].currentUser completionBlock:^{
//        [SVProgressHUD dismiss];
//    }];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
      [FBSDKAppEvents activateApp];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    // Attempt to extracct to token from the
    
    
     return  [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    
    

}


/// PUSH notification Service

#ifdef  __IPHONE_8_0

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    if ([identifier isEqualToString:@"declineAction"]) {
        
    }else if([identifier isEqualToString:@"answerAction"])
    {
        
    }
}
#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Subscribe to push notifications
    //
    NSString *deviceIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //
    [QBRequest registerSubscriptionForDeviceToken:deviceToken uniqueDeviceIdentifier:deviceIdentifier
                                     successBlock:^(QBResponse *response, NSArray *subscriptions) {
                                         
                                     } errorBlock:^(QBError *error) {
                                         
                                     }];
    
     self.deviceToken = [self hexadecimalString:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"New Push received\n: %@", userInfo);
    
    NSString *dialogId = userInfo[@"dialog_id"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDialogUpdatedNotification object:nil userInfo:@{@"dialog_id": dialogId}];
    
    [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"New message"
                                                   description:userInfo[@"aps"][@"alert"]
                                                          type:TWMessageBarMessageTypeInfo];
    
    [[SoundService instance] playNotificationSound];
}

- (NSString *)hexadecimalString:(NSData *)data {
    
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength  * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = manager.location;
    
//    if(self.isLoginFlag && ![self.userFB_ID isEqualToString:@""])
//    {
//        NSString * postStr = [NSString stringWithFormat:@"fb_id=%@&latitude=%.6f@&longitude=%.6f",self.userFB_ID,self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude];
//        [serverManager fetchDataOnserverWithAction:USER_LOCATION_UPDATE forView:nil forPostData:postStr];
//    }
    
    //  [manager stopUpdatingLocation];
}


-(void)receiveNotification:(NSDictionary *)userInfo
{
    
}
@end
