//
//  Contants.h
//  Fixed
//
//  Created by guangxian on 5/13/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#ifndef Fixed_Constants_h
#define Fixed_Constants_h

//#define DEBUG_FLAG YES

#ifdef DEBUG_FLAG
    #define API_URL @"http://172.16.1.148:8083/api/"
    #define SERVER_IP @"http://172.16.1.148:8083"
    #define APP_RESOURCE_PATH @"http://172.16.1.148:8083/photos/"

#else
    #define API_URL @"http://ec2-52-25-207-152.us-west-2.compute.amazonaws.com/api/"
    #define SERVER_IP @"http://ec2-52-25-207-152.us-west-2.compute.amazonaws.com"
    #define APP_RESOURCE_PATH @"http://ec2-52-25-207-152.us-west-2.compute.amazonaws.com/photos/"
#endif

#define APP ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

/// App FONT
#define FIXED_FONT_12px_BOLD [UIFont fontWithName:@"Kefa" size:12.0]
#define FIXED_FONT_12px_NORMAL [UIFont fontWithName:@"Kefa" size:12.0]

// APP COLOR

#define FIXED_GREEN_COLOR [UIColor colorWithRed:55/255.0 green:144/255.0 blue:28/255.0 alpha:1.0]
#define FIXED_LIGHT_GREEN_COLOR [UIColor colorWithRed:208/255.0 green:236/255.0 blue:199/255.0 alpha:1.0]
#define FIXED_RED_COLOR [UIColor colorWithRed:55/255.0 green:144/255.0 blue:28/255.0 alpha:1.0]
#define FIXED_LIGHT_RED_COLOR [UIColor colorWithRed:224/255.0 green:174/255.0 blue:189/255.0 alpha:1.0]
#define FIXED_DARK_GRAY_COLOR [UIColor colorWithRed:72/255.0 green:72/255.0 blue:72/255.0 alpha:1.0]
#define FIXED_LIGHT_GRAY_COLOR [UIColor colorWithRed:182/255.0 green:182/255.0 blue:182/255.0 alpha:1.0]



// API Action Name

#define FIXED_API_SIGNIN @"fb_login"
#define FIXED_API_SUGGESTED_FRIENDS @"getSuggestedFriendList"
#define FIXED_API_GET_PROFILE @"getFriendProfile"
#define FIXED_API_FIX_IT @"fixIt"
#define FIXED_API_GET_SUGGESTION @"getSuggestedMatchByMe"
#define FIXED_API_GET_FIXED @"getFixedMatchByMe"
#define FIXED_API_GET_STATISTICS @"getStatistics"
#define FIXED_API_SAVE_MATCH_PREFERENCE @"savePreference"
#define FIXED_API_SAVE_PROFILE @"saveProfile"
#define FIXED_API_CHANGE_SETTING @"changeSetting"

//my matches
#define FIXED_API_GET_MYMATCHES @"getMyMatches"
#define FIXED_API_LIKE @"likeFriend"
#define FIXED_API_ACCEPT @"acceptMatch"
#define FIXED_API_DISLIKE @"dislikeMatch"

#define FIXED_API_LOGOUT @"logout"
#define FIXED_API_DELETE_ACCOUNT @"deleteAccount"

// Coins purchase and Withdraw
#define FIXED_API_ADD_COIN @"addCoin"
#define FIXED_API_WITHDRAW_COIN @"withdrawCoin"






#endif
