//
//  FXUser.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXUser.h"

#define  RELIGIONS @[@"No Preference",@"Christian" , @"Athiest", @"Catholic", @"Jewish", @"Muslim", @"Agnostic", @"Hindu", @"Buddhist", @"Other"]

static FXUser * instance;

@implementation FXUser


+(FXUser *)sharedUser{
    if (instance == nil) {
        instance = [[FXUser alloc] init];
        instance.activeFixes = 5;
    }
    
    return instance;
}


-(void)fromDictionary:(NSDictionary *)dic
{
        self.fb_id = [dic objectForKey:@"fb_id"] ;
        self.name = [dic objectForKey:@"name"] ;
        self.email = [dic objectForKey:@"email"] == nil ? @"": [dic objectForKey:@"email"];
        self.sex = [[dic objectForKey:@"sex"] boolValue];
        self.birthday = [dic objectForKey:@"birthday"];
        self.age = [FXUser ageFromBirthday:self.birthday];
        self.single = [[dic objectForKey:@"single"]  boolValue];
        self.workplace = [dic objectForKey:@"workplace"] != nil ? [dic objectForKey:@"workplace"] : @"";
        self.schools = [dic objectForKey:@"schools"] != nil ? [dic objectForKey:@"schools"] : @"";
    
        NSString * interestStr = [dic objectForKey:@"interest"];
        
        self.interest = [[NSArray alloc] init];
        if (interestStr != nil && ![interestStr isEqualToString:@""]) {
            NSArray * tempArray = [[SBJsonParser new] objectWithString:interestStr];
            
            if (tempArray != nil) {
                self.interest = tempArray;
            }
        }
    
        self.state = [dic objectForKey:@"state"] != nil ? [dic objectForKey:@"state"] : @"";
        self.city = [dic objectForKey:@"city"] != nil ? [dic objectForKey:@"city"] : @"";
        self.street = [dic objectForKey:@"street"] != nil ? [dic objectForKey:@"street"] : @"";
        self.zipcode = [dic objectForKey:@"zipcode"] != nil ? [dic objectForKey:@"zipcode"] : @"";
        self.latitude = [[dic objectForKey:@"latitude"] doubleValue] ;
        self.longitude = [[dic objectForKey:@"longitude"] doubleValue] ;
    
        self.is_man = [[dic objectForKey:@"is_man"]  boolValue];
        self.is_interested_man = [[dic objectForKey:@"is_interested_man"] boolValue];
        self.is_single = [[dic objectForKey:@"is_single"] boolValue];
        self.religion_priority = [[dic objectForKey:@"religion_priority"] intValue];
        self.match_zipcode = [dic objectForKey:@"match_zipcode"] ;
        self.distance_range = [[dic objectForKey:@"distance_range"] doubleValue];
        self.min_age = [[dic objectForKey:@"min_age"] intValue];
        self.max_age = [[dic objectForKey:@"max_age"] intValue];
        self.min_height = [[dic objectForKey:@"min_height"] intValue];
        self.max_height = [[dic objectForKey:@"max_height"] intValue];
   
        self.tageline = [dic objectForKey:@"tagline"];
        self.height = [[dic objectForKey:@"height"] intValue];
        self.religion = [[dic objectForKey:@"religion"] intValue];
    
    
    self.photo_paths = [[NSMutableArray alloc] init];
    NSString *tempStr = [dic objectForKey:@"photo_path"] ;
    if (tempStr != nil && ![tempStr isEqualToString:@""]){
        NSArray * tempArray = [[SBJsonParser new] objectWithString:tempStr];
        if (tempArray != nil ) {
            self.photo_paths = [NSMutableArray arrayWithArray:tempArray];
        }
    }
    
   
    
        self.fix_reminder = [[dic objectForKey:@"fix_reminder"] boolValue];
        self.cash_notification = [[dic objectForKey:@"cash_notification"] boolValue];
        self.match_notification = [[dic objectForKey:@"match_notification"] boolValue];
        self.chat_notification = [[dic objectForKey:@"chat_notification"] boolValue];
        self.alert_setting = [[dic objectForKey:@"alert_setting"] boolValue];
        self.update_setting = [[dic objectForKey:@"update_setting"] boolValue];
    
        self.activeFixes = [[dic objectForKey:@"fixes"] intValue];
        self.coins = [[dic objectForKey:@"coins"] intValue];
    
        self.myFriendList = (NSArray *)[dic objectForKey:@"my_friend_list"];
    
    self.QBUserId = [dic objectForKey:@"QBUserId"] != nil ?[[dic objectForKey:@"QBUserId"] integerValue]: 0;
    
}


+(NSDate *)dateFromString:(NSString *)dateStr
{
    if (dateStr != nil && ![dateStr isEqualToString:@""]) {
        
        NSString * formatStr = @"yyyy-MM-dd HH:mm:ss";
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:formatStr];
        NSDate * tempDate =[formatter dateFromString:dateStr];
        if (tempDate != nil) {
            return tempDate;
        }
        

    }
    
    return [NSDate date];
}

+(NSDate *)dateFromBirhdayString:(NSString *)dateStr
{
    if (dateStr != nil && ![dateStr isEqualToString:@""]) {
        
        NSString * formatStr = @"MM/dd/yyyy";
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:formatStr];
        NSDate * tempDate =[formatter dateFromString:dateStr];
        if (tempDate != nil) {
            return tempDate;
        }
        
        
    }
    
    return [NSDate date];
}



+ (NSInteger)ageFromBirthday:(NSString *)birthdayStr {
    
    NSDate * birthdate = [FXUser dateFromBirhdayString:birthdayStr];
    NSDate *today = [NSDate date];
    NSDateComponents *ageComponents = [[NSCalendar currentCalendar]
                                       components:NSYearCalendarUnit
                                       fromDate:birthdate
                                       toDate:today
                                       options:0];
    return ageComponents.year;
}

+ (NSString *)religionFromIndex:(NSInteger)index{
    
    if (index >= [RELIGIONS count] || index < 0) {
        return @"Other";
    }
    return [RELIGIONS objectAtIndex:index];
}

+ (NSInteger)indexFromReligionStr:(NSString *) religionStr{
   
    if (religionStr == nil) {
        return 0;
    }
    
    NSArray * components = [religionStr componentsSeparatedByString:@" "];
    if (components != nil) {
        for (int  j = 0 ; j < [components count] ; j++ ) {
            NSString  * tempStr = [components objectAtIndex:j];
            tempStr = [tempStr uppercaseString];
            
            for (int i = 0 ; i <[RELIGIONS count]; i++) {
                NSString * religionStr = [RELIGIONS objectAtIndex:i];
                religionStr = [NSString stringWithFormat:@"%@", religionStr];
                [religionStr uppercaseString];
                
                if ([tempStr isEqualToString:religionStr]) {
                    return i;
                }
            }
        }
    }
  
    return 9;
}


+(NSURL *)photoPathFromId:(NSString *)userId{
    NSString *tempPath = [NSString stringWithFormat:@"%@%@.jpg", APP_RESOURCE_PATH, userId];
    NSURL * url = [NSURL URLWithString:tempPath];
    return url;
}


-(NSURL *)mainPhotoURL{
    NSString * tempPath;
    NSURL * url = nil;
    if (self.photo_paths != nil && [self.photo_paths count] != 0 ) {
        tempPath = [self.photo_paths objectAtIndex:0];
        url = [NSURL URLWithString:tempPath];
     }

    return url;
}

-(FXProfile *)convertUser2Profile{
    FXProfile * profile = [[FXProfile alloc] init];
    
    profile.fb_id =self.fb_id;
    profile.name = self.name;
    profile.birthday =self.birthday;
    profile.age = self.age;
    profile.workplace = self.workplace;
    profile.schools = self.schools;
    profile.interest = self.interest;
    profile.state = self.state;
    profile.city = self.city;
    profile.street = self.street;
    profile.tageline = self.tageline;
    profile.religion =self.religion;
    profile.photo_paths =self.photo_paths;
 //   profile.tags = self.tags;
   
    return profile;
}

-(BOOL)fbSigin:(NSString *)postStr withView:(UIView *)view{
    NSDictionary * tempDic = (NSDictionary *)   [ServiceApiHelper httpRequestWithAction:FIXED_API_SIGNIN contentParam:postStr withView:view];
    
    if (tempDic != nil && [tempDic objectForKey:@"flag"] != nil ) {
        
        FXUser * user = [FXUser sharedUser];
        NSData * mainPhotoData = [NSData dataWithContentsOfURL:[FXUser photoPathFromId:user.fb_id]];
        
        if ([[tempDic objectForKey:@"flag"] isEqualToString:@"new"] || mainPhotoData == nil) {
            
            NSString * userImageUrlStr = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", user.fb_id];
            NSData * imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:userImageUrlStr]];
            if (imageData != nil) {
                UIImage * profileImage  = [[UIImage alloc] initWithData:imageData];
                [[FXUser sharedUser] uploadImage:@[profileImage] withFlag:YES];
            }
        }
            NSDictionary * resultDic = [tempDic objectForKey:@"data"];
            if (resultDic == nil) {
                return  NO;
            }
            
           
            [user fromDictionary:resultDic];
            
            return YES;
       
    }
    
    return NO;
}


-(void)submitQBUserId:(NSInteger)userId;
{
    NSString * postStr = [NSString stringWithFormat:@"fb_id=%@&QBUserId=%i", self.fb_id, userId];
    if(self.QBUserId ==  0){
        NSDictionary *tempDic = (NSDictionary *)[ServiceApiHelper httpRequestWithAction:FIXED_API_SUBMIT_QBID contentParam:postStr withView:nil];
        
        if (tempDic != nil && [tempDic objectForKey:@"success"] != nil ) {
            
            if ([[tempDic objectForKey:@"success"] isEqualToString:@"OK"]) {
                self.QBUserId = userId;
                return ;
            }
        }
    }
    return ;
}


#pragma mark - pic upload

-(NSMutableArray *)uploadImage:(NSArray *)uploadImages withFlag:(BOOL)flag
{
    NSMutableArray * tempPhotoUrls = [[NSMutableArray alloc] init];
    
    for(int i= 0 ; i<[uploadImages count] ; i++){
        UIImage *imgTaken = [uploadImages objectAtIndex:i];

        NSData *dataImage = UIImageJPEGRepresentation(imgTaken, 0.25);
        
        NSString * fileName;
        if (i == 0) {
             fileName = [NSString stringWithFormat:@"%@.jpg", self.fb_id];
        }else{
            fileName = [NSString stringWithFormat:@"%@_%i.jpg", self.fb_id, i];
        }
        
        if(dataImage != nil)
        {
            NSString *url = [NSString stringWithFormat:@"%@uploadPhoto?fb_id=%@&save_flag=%i",API_URL, self.fb_id,flag];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            
            [request setURL:[NSURL URLWithString:url]];
            
            [request setHTTPMethod:@"POST"];
            
            NSString *boundary = @"21312425987239857";
            
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
            [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
            
            NSMutableData *body = [NSMutableData data];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upload_file\"; filename=\"%@\"\r\n",fileName] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:dataImage]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [request setHTTPBody:body];
            
            NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
           
            NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            
            returnString = [returnString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSDictionary * responseDic = [[[SBJsonParser alloc] init] objectWithString:returnString];
            
            if (responseDic != nil) {
                
                NSString * flagStr = [responseDic objectForKey:@"success"];

                if (flagStr != nil && [flagStr isEqualToString:@"OK"]) {

                    [tempPhotoUrls addObject:[responseDic objectForKey:@"image_path"]];

                }
            }
        }
    }
    
    return tempPhotoUrls;
}


-(BOOL)saveMatchReference:(NSString * )postStr withView:(UIView *)view{
    
     NSDictionary * tempDic = (NSDictionary *)   [ServiceApiHelper httpRequestWithAction:FIXED_API_SAVE_MATCH_PREFERENCE contentParam:[NSString stringWithFormat:@"fb_id=%@&%@",self.fb_id,postStr] withView:view];
    
    if (tempDic != nil && [tempDic objectForKey:@"success"] != nil ) {
        if ([[tempDic objectForKey:@"success"] isEqualToString:@"OK"]) {
            return YES;
        }
    }
    return NO;
}


-(BOOL)saveUserProfile:(NSString * )postStr withView:(UIView *)view
{
    NSDictionary * tempDic = (NSDictionary *)[ServiceApiHelper httpRequestWithAction:FIXED_API_SAVE_PROFILE  contentParam:[NSString stringWithFormat:@"fb_id=%@&%@",self.fb_id,postStr] withView:view];
    
    if (tempDic != nil && [tempDic objectForKey:@"success"] != nil ) {
        if ([[tempDic objectForKey:@"success"] isEqualToString:@"OK"]) {
            return YES;
        }
    }
    return NO;
      
}


-(void)changeSetting:(SETTING_TYPE)type withValue:(BOOL)flag
{
    NSMutableString * postStr = [[NSMutableString alloc] initWithString:@"fb_id="];
    [postStr appendString:self.fb_id];
    [postStr appendString:@"&"];
    
    switch (type) {
        case REMINDER_SETTING:
            [postStr appendString:[NSString stringWithFormat:@"fix_reminder=%i", flag]];
            self.fix_reminder = flag;
            break;
        case CASH_SETTING:
             [postStr appendString:[NSString stringWithFormat:@"cash_notification=%i", flag ]];
            self.cash_notification = flag;
            break;
        case MATCH_SETTING:
             [postStr appendString:[NSString stringWithFormat:@"match_notification=%i", flag]];
            self.match_notification = flag;
            break;
        case CHAT_SETTING:
             [postStr appendString:[NSString stringWithFormat:@"chat_notification=%i", flag]];
            self.chat_notification = flag;
            break;
        case ALET_SETTTING:
             [postStr appendString:[NSString stringWithFormat:@"alert_setting=%i", flag]];
            self.alert_setting = flag;
            break;
        case UPDATE_SETTING:
             [postStr appendString:[NSString stringWithFormat:@"update_setting=%i", flag]];
            self.update_setting = flag;
            
            break;
      
        default:
            break;
    }
 

    [ServiceApiHelper httpAsyncRequestWithAction:FIXED_API_CHANGE_SETTING contentParam:postStr withHandler:nil];
    
}


-(void)changeEmail:(NSString *)emailStr{
    
    NSString * postStr = [NSString stringWithFormat:@"fb_id=%@&email=%@", self.fb_id, emailStr];
    [ServiceApiHelper httpAsyncRequestWithAction:FIXED_API_CHANGE_SETTING contentParam:postStr withHandler:nil];
    
}

// Get Suggest Friend

-(void)fetchSuggestedFriends:(UIView *)view{
    NSDictionary * tempDic = (NSDictionary *) [ServiceApiHelper httpRequestWithAction:FIXED_API_SUGGESTED_FRIENDS contentParam:[NSString stringWithFormat:@"fb_id=%@", self.fb_id] withView:view];
    
    if (tempDic != nil && [tempDic objectForKey:@"success"] != nil ) {
        if ([[tempDic objectForKey:@"success"] isEqualToString:@"OK"]) {
            NSArray * tempArray = [tempDic objectForKey:@"data"];
            
            self.suggestedFriendList = [[NSMutableArray alloc] init];
            if (tempArray != nil) {
                
                FXFriend * friend ;
                for (NSArray * array in tempArray) {
                    NSMutableArray * friendList = [[NSMutableArray alloc] init];
                    
                    if (array != nil ) {
                        for (NSDictionary * friendDic in array) {
                            friend = [[FXFriend alloc] init];
                            [friend fromDictionary:friendDic];
                            [friendList addObject:friend];
                        }
                    }
                    
                    [self.suggestedFriendList addObject:friendList];
                }
            }
        }
    }
   
}

-(BOOL)fixIt:(NSString *)postStr  withView:(UIView *)view{
    
    NSDictionary * tempDic = (NSDictionary *) [ServiceApiHelper httpRequestWithAction:FIXED_API_FIX_IT contentParam:[NSString stringWithFormat:@"provider=%@&%@", self.fb_id,postStr] withView:view];
    
    if (tempDic != nil && [tempDic objectForKey:@"success"] != nil ) {
        if ([[tempDic objectForKey:@"success"] isEqualToString:@"OK"]) {
            return YES;
        }
    }
    return NO;
}

-(NSArray *)getSuggestedMatchedByMe:(UIView *)view{
    
    NSDictionary * tempDic = (NSDictionary *) [ServiceApiHelper httpRequestWithAction:FIXED_API_GET_SUGGESTION contentParam:[NSString stringWithFormat:@"fb_id=%@", self.fb_id] withView:view];
    
    if (tempDic != nil && [tempDic objectForKey:@"success"] != nil ) {
        if ([[tempDic objectForKey:@"success"] isEqualToString:@"OK"]) {
            
            NSArray * data = [tempDic objectForKey:@"data"];
            if (data != nil && [data count] != 0) {
                
                return [FXMatch matchesFromArray:data];
            }
            
        }
    }
    return nil;
}

-(NSArray *)getFixedMatchedByMe:(UIView *)view{
    NSDictionary * tempDic = (NSDictionary *) [ServiceApiHelper httpRequestWithAction:FIXED_API_GET_FIXED contentParam:[NSString stringWithFormat:@"fb_id=%@", self.fb_id] withView:view];
    
    if (tempDic != nil && [tempDic objectForKey:@"success"] != nil ) {
        if ([[tempDic objectForKey:@"success"] isEqualToString:@"OK"]) {
            
            NSArray * data = [tempDic objectForKey:@"data"];
            if (data != nil && [data count] != 0) {
                
                return [FXMatch matchesFromArray:data];
            }
            
        }
    }
    return nil;
}




-(NSDictionary *)getStatisticsData:(UIView *)view{
    NSDictionary * tempDic = (NSDictionary *) [ServiceApiHelper httpRequestWithAction:FIXED_API_GET_STATISTICS contentParam:[NSString stringWithFormat:@"fb_id=%@", self.fb_id] withView:view];
    
    if (tempDic != nil && [tempDic objectForKey:@"success"] != nil ) {
        if ([[tempDic objectForKey:@"success"] isEqualToString:@"OK"]) {
            
            NSDictionary  * data = [tempDic objectForKey:@"data"];
          
            return data;

            
        }
    }
    return nil;
}

-(NSDictionary *)getMyMatches:(UIView *)view{

    NSDictionary * tempDic = (NSDictionary *) [ServiceApiHelper httpRequestWithAction:FIXED_API_GET_MYMATCHES contentParam:[NSString stringWithFormat:@"fb_id=%@", self.fb_id] withView:view];
    
    if (tempDic != nil && [tempDic objectForKey:@"success"] != nil ) {
        if ([[tempDic objectForKey:@"success"] isEqualToString:@"OK"]) {
            
            return [tempDic objectForKey:@"data"];
            
        }
    }

    
    return nil;
}

-(BOOL)addCoin:(UIView *)view{
    
    NSString * keyStr = [NSString stringWithFormat:@"%@_addedcoin", self.fb_id];
    NSInteger coin_count = [[NSUserDefaults standardUserDefaults] integerForKey:keyStr];
    
    if (coin_count > 0) {
        NSDictionary * tempDic = (NSDictionary *) [ServiceApiHelper httpRequestWithAction:FIXED_API_ADD_COIN contentParam:[NSString stringWithFormat:@"fb_id=%@&coin_count=%ld", self.fb_id, coin_count] withView:view];
        
        if (tempDic != nil && [tempDic objectForKey:@"success"] != nil ) {
            if ([[tempDic objectForKey:@"success"] isEqualToString:@"OK"]) {
                
                [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:keyStr];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                return YES;
                
            }
        }

    }
    return NO;
}

-(BOOL)withdrawCoin:(UIView *)view{
    NSString * keyStr = [NSString stringWithFormat:@"%@_withdrawcoin", self.fb_id];
    NSInteger coin_count = [[NSUserDefaults standardUserDefaults] integerForKey:keyStr];
    
    if (coin_count > 0) {
        NSDictionary * tempDic = (NSDictionary *) [ServiceApiHelper httpRequestWithAction:FIXED_API_WITHDRAW_COIN contentParam:[NSString stringWithFormat:@"fb_id=%@&coin_count=%ld", self.fb_id, coin_count] withView:view];
        
        if (tempDic != nil && [tempDic objectForKey:@"success"] != nil ) {
            if ([[tempDic objectForKey:@"success"] isEqualToString:@"OK"]) {
                
                [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:keyStr];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                // Reset Coins and Bank Amount
                return YES;
                
            }
        }
        
    }
    
    return NO;
}

-(void)logout{
    [ServiceApiHelper httpRequestWithAction:FIXED_API_LOGOUT contentParam:[NSString stringWithFormat:@"fb_id=%@&device_token=%@", self.fb_id,APP.deviceToken] withView:nil];
    
}


-(BOOL)deleteAccount:(UIView *)view{
    NSDictionary * tempDic = (NSDictionary *) [ServiceApiHelper httpRequestWithAction:FIXED_API_DELETE_ACCOUNT contentParam:[NSString stringWithFormat:@"fb_id=%@", self.fb_id] withView:view];
    
    if (tempDic != nil && [tempDic objectForKey:@"success"] != nil ) {
        if ([[tempDic objectForKey:@"success"] isEqualToString:@"OK"]) {
            return YES;
        }
    }
    return NO;
}


@end
