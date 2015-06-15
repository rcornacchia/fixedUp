//
//  FXFriend.h
//  Fixed
//
//  Created by Glenn Chirino on 6/10/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXFriend : NSObject

@property (nonatomic, strong) NSString * fb_id;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * interest;
@property (nonatomic, assign) double match_score;
@property (nonatomic, assign) int match_tags;


-(void)fromDictionary:(NSDictionary *)dic;

@end
