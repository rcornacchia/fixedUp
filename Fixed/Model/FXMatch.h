//
//  FXMatch.h
//  Fixed
//
//  Created by Glenn Chirino on 6/9/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXMatch : NSObject
@property (nonatomic, strong) NSString * idString;
@property (nonatomic, strong) NSString * user1_id;
@property (nonatomic, strong) NSString * user1_name;

@property (nonatomic, strong) NSString * user2_id;
@property (nonatomic, strong) NSString * user2_name;

@property (nonatomic, strong) NSString * provider_id;
@property (nonatomic, strong) NSString * provider_name;

@property (nonatomic, strong) NSDate * fix_date;

@property (nonatomic, strong) NSString * comment;


@property (nonatomic, strong) NSString *liked_user_id;
@property (nonatomic, assign) BOOL is_accept;
@property (nonatomic, assign) BOOL is_dislike;
@property (nonatomic, assign) BOOL anonymous;

@property (nonatomic, assign) int expire_day;


-(void)fromDictionary:(NSDictionary *)dic;
+(NSMutableArray *)matchesFromArray:(NSArray *)data;
+(BOOL)likeFriend:(NSString *)match_id withUserId:(NSString *)userId;
+(BOOL)acceptMatch:(NSString *)match_id;
+(BOOL)dislikeMatch:(NSString *)match_id;
@end
