//
//  AppDelegate.h
//  Fixed
//
//  Created by wang on 5/11/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property(strong, nonatomic) FBSDKLoginManager  *loginManager;
@property (nonatomic, strong) UINavigationController * activeContainer;

@end

