//
//  FXMatch.m
//  Fixed
//
//  Created by Glenn Chirino on 6/9/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXMatch.h"

@implementation FXMatch

-(void)fromDictionary:(NSDictionary *)dic
{
    self.idString = [dic objectForKey:@"id"]  != nil ? [dic objectForKey:@"id"] :@"" ;
    
    self.user1_id = [dic objectForKey:@"user1"] ;
    self.user1_name = [dic objectForKey:@"name1"] ;
    
    self.user2_id = [dic objectForKey:@"user2"] ;
    self.user2_name = [dic objectForKey:@"name2"] ;
    
    self.provider_id  = [dic objectForKey:@"provider"] ;
    self.provider_name = [dic objectForKey:@"provider_name"] ;
    
    self.fix_date = [FXUser dateFromString:[dic objectForKey:@"fix_date"]];
    
    self.comment = [dic objectForKey:@"comment"] ;
    self.liked_user_id = [dic objectForKey:@"liked_user"] ;
    
    self.is_accept = [[dic objectForKey:@"is_accept"] boolValue];
    self.is_dislike = [[dic objectForKey:@"is_dislike"] boolValue];
    self.anonymous = [[dic objectForKey:@"anonymous"] boolValue];
    
    self.expire_day = [dic objectForKey:@"expire_day"] != nil ? [[dic objectForKey:@"expire_day"] intValue] : -1;

}


+(NSMutableArray *)matchesFromArray:(NSArray *)data{
    
    if (data == nil) {
        return nil;
    }
    FXMatch * tempMatch;
    NSMutableArray * tempArray = [[NSMutableArray alloc] init];
    for (NSDictionary * matchDic in data) {
        tempMatch = [[FXMatch alloc] init];
        [tempMatch fromDictionary:matchDic];
        [tempArray addObject:tempMatch];
    }
    
    return  tempArray;
}

+(BOOL)likeFriend:(NSString *)match_id withUserId:(NSString *)userId
{
    NSDictionary * tempDic = (NSDictionary *) [ServiceApiHelper httpRequestWithAction:FIXED_API_LIKE contentParam:[NSString stringWithFormat:@"id=%@&fb_id=%@", match_id, userId] withView:nil];
    
    if (tempDic != nil && [tempDic objectForKey:@"success"] != nil ) {
        if ([[tempDic objectForKey:@"success"] isEqualToString:@"OK"]) {
            
            return YES;
            
        }
    }

    
    return NO;
}

+(BOOL)acceptMatch:(NSString *)match_id{
    NSDictionary * tempDic = (NSDictionary *) [ServiceApiHelper httpRequestWithAction:FIXED_API_ACCEPT contentParam:[NSString stringWithFormat:@"id=%@", match_id] withView:nil];
    
    if (tempDic != nil && [tempDic objectForKey:@"success"] != nil ) {
        if ([[tempDic objectForKey:@"success"] isEqualToString:@"OK"]) {
            
            return YES;
            
        }
    }
    
    
    return NO;
}
+(BOOL)dislikeMatch:(NSString *)match_id
{
    NSDictionary * tempDic = (NSDictionary *) [ServiceApiHelper httpRequestWithAction:FIXED_API_DISLIKE contentParam:[NSString stringWithFormat:@"id=%@", match_id] withView:nil];
    
    if (tempDic != nil && [tempDic objectForKey:@"success"] != nil ) {
        if ([[tempDic objectForKey:@"success"] isEqualToString:@"OK"]) {
            
            return YES;
            
        }
    }
    
    
    return NO;
}
@end
