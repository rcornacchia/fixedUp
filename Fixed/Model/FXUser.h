//
//  FXUser.h
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SETTING_TYPE)  {
    REMINDER_SETTING =0 ,
    CASH_SETTING,
    MATCH_SETTING,
    CHAT_SETTING,
    ALET_SETTTING,
    UPDATE_SETTING
};

@class FXProfile;

@interface FXUser : NSObject

// User Profile (main)

@property (nonatomic, strong) NSString * fb_id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * email;
@property(nonatomic, assign) BOOL sex;
@property(nonatomic, strong) NSString * birthday;
@property(nonatomic, assign) BOOL single;
@property(nonatomic, assign) NSInteger age;


    // Location

@property(nonatomic, strong) NSString * workplace;
@property(nonatomic, strong) NSString * schools;
@property(nonatomic, strong) NSString * interest;
@property(nonatomic, strong) NSString * state;
@property(nonatomic, strong) NSString * city;
@property(nonatomic, strong) NSString  *street;
@property(nonatomic, strong) NSString  *zipcode;
@property(nonatomic, assign) double  latitude;
@property(nonatomic, assign) double  longitude;

// Match Reference

@property(nonatomic, assign) BOOL is_man;
@property(nonatomic, assign) BOOL is_single;
@property(nonatomic, assign) BOOL is_interested_man;
@property(nonatomic, assign) int religion_priority ;
@property(nonatomic, strong) NSString * match_zipcode ;
@property(nonatomic, assign) double distance_range ;
@property(nonatomic, assign) int min_age;
@property(nonatomic, assign) int max_age;
@property(nonatomic, assign) int min_height;
@property(nonatomic, assign) int max_height;

// profile Editing

@property(nonatomic, strong) NSString * tageline;
@property(nonatomic, assign) int height;
@property(nonatomic, assign) int religion;
@property(nonatomic, strong) NSMutableArray * photo_paths;

// Setting

@property(nonatomic, assign) BOOL fix_reminder;
@property(nonatomic, assign) BOOL cash_notification;
@property(nonatomic, assign) BOOL match_notification;
@property(nonatomic, assign) BOOL chat_notification;

@property(nonatomic, assign) BOOL alert_setting;
@property(nonatomic, assign) BOOL update_setting;

@property (nonatomic, assign) int activeFixes;
@property (nonatomic, assign) int coins;

@property(nonatomic, strong) NSArray * myFriendList;

@property (nonatomic, strong) NSMutableArray * suggestedFriendList;

@property (nonatomic, strong) NSMutableArray * mySuggestMatches;
@property (nonatomic, strong) NSMutableArray * myMatches;

+(FXUser *)sharedUser;

+(NSDate *)dateFromBirhdayString:(NSString *)dateStr;
+(NSDate *)dateFromString:(NSString *)dateStr;
+ (NSInteger)ageFromBirthday:(NSString *)birthdayStr ;
+ (NSString *)religionFromIndex:(NSInteger)index;
+ (NSInteger)indexFromReligionStr:(NSString *) religionStr;
+(NSURL *)photoPathFromId:(NSString *)userId;


-(NSURL *)mainPhotoURL;
-(FXProfile *)convertUser2Profile;

-(BOOL)fbSigin:(NSString *)postStr withView:(UIView *)view;
-(NSMutableArray *)uploadImage:(NSArray *)uploadImages withFlag:(BOOL)flag;
-(BOOL)saveMatchReference:(NSString * )postStr withView:(UIView *)view;
-(BOOL)saveUserProfile:(NSString * )postStr withView:(UIView *)view;
-(void)logout;
-(BOOL)deleteAccount:(UIView *)view;

// Settting

-(void)changeSetting:(SETTING_TYPE)type withValue:(BOOL)flag;
-(void)changeEmail:(NSString *)emailStr;

-(void)fetchSuggestedFriends:(UIView *)view;
-(BOOL)fixIt:(NSString *)postStr  withView:(UIView *)view;
-(NSArray *)getSuggestedMatchedByMe:(UIView *)view;
-(NSArray *)getFixedMatchedByMe:(UIView *)view;

// Statistics Data

-(NSDictionary *)getStatisticsData:(UIView *)view;

// My Matches

-(NSDictionary *)getMyMatches:(UIView *)view;

// Coin Purchase And Withdraw

-(BOOL)addCoin:(UIView *)view;
-(BOOL)withdrawCoin:(UIView *)view;

@end
