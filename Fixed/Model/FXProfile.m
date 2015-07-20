//
//  FXProfile.m
//  Fixed
//
//  Created by Glenn Chirino on 6/10/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXProfile.h"

@implementation FXProfile


-(void)fromDictionary:(NSDictionary *)dic
{
    self.fb_id = [dic objectForKey:@"fb_id"] ;
    self.name = [dic objectForKey:@"name"] ;
      
    self.birthday = [dic objectForKey:@"birthday"];
    self.age = [FXUser ageFromBirthday:self.birthday];

  
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

    self.tageline = [dic objectForKey:@"tagline"];
    self.religion = [[dic objectForKey:@"religion"] intValue];
    
    self.photo_paths = [[NSMutableArray alloc] init];
    NSString *tempStr = [dic objectForKey:@"photo_path"] ;
    if (tempStr != nil && ![tempStr isEqualToString:@""]){
        NSArray * tempArray = [[SBJsonParser new] objectWithString:tempStr];
        if (tempArray != nil ) {
            self.photo_paths = [NSMutableArray arrayWithArray:tempArray];
        }
    }
    
    self.QBUserId = [dic objectForKey:@"QBUserId"] != nil ? [[dic objectForKey:@"QBUserId"] integerValue] : -1;
//    NSString * tagsStr = [dic objectForKey:@"tags"];
//    
//    self.tags = [[NSArray alloc] init];
//    if (tagsStr != nil && ![tagsStr isEqualToString:@""]) {
//        NSArray * tempArray = [[SBJsonParser new] objectWithString:tagsStr];
//        
//        if (tempArray != nil) {
//            self.tags = tempArray;
//        }
//    }
    
}


+(FXProfile *)getProfile:(NSString *)userId withView:(UIView *)view{
    
     NSDictionary * tempDic = (NSDictionary *) [ServiceApiHelper httpRequestWithAction:FIXED_API_GET_PROFILE contentParam:[NSString stringWithFormat:@"fb_id=%@", userId] withView:view];
    
    if (tempDic != nil && [tempDic objectForKey:@"success"] != nil ) {
        if ([[tempDic objectForKey:@"success"] isEqualToString:@"OK"]) {
            NSDictionary *profileDic = [tempDic objectForKey:@"data"];
            
            FXProfile * profile = [[FXProfile alloc] init];
            [profile fromDictionary:profileDic];
            
            return  profile;
            
        }
    }
    
    return nil;
}

@end
