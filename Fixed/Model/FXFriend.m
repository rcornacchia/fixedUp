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
    self.interest = [dic objectForKey:@"interest"] != nil ? [dic objectForKey:@"interest"] :@"";
    self.match_score = [[dic objectForKey:@"match_score"] doubleValue];
    self.match_tags = [[dic objectForKey:@"match_tags"] intValue];
}

@end
