//
//  FXFriend.m
//  Fixed
//
//  Created by Glenn Chirino on 6/10/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXFriend.h"

@implementation FXFriend


-(void)fromDictionary:(NSDictionary *)dic
{
    self.fb_id = [dic objectForKey:@"fb_id"] ;
    self.name = [dic objectForKey:@"name"] ;
    NSString * interestStr = [dic objectForKey:@"interest"];
    
    self.interest = [[NSArray alloc] init];
    if (interestStr != nil && ![interestStr isEqualToString:@""]) {
        NSArray * tempArray = [[SBJsonParser new] objectWithString:interestStr];
        
        if (tempArray != nil) {
            self.interest = tempArray;
        }
    }
    self.match_score = [[dic objectForKey:@"match_score"] doubleValue];
    self.match_tags = [[dic objectForKey:@"match_tags"] intValue];
}

@end
