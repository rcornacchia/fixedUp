//
//  FXProfile.h
//  Fixed
//
//  Created by Glenn Chirino on 6/10/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXProfile : NSObject

@property (nonatomic, strong) NSString * fb_id;
@property (nonatomic, strong) NSString * name;
@property(nonatomic, strong) NSString * birthday;
@property(nonatomic, assign) NSInteger age;
@property(nonatomic, strong) NSString * workplace;
@property(nonatomic, strong) NSString * schools;
@property(nonatomic, strong) NSArray * interest;
@property(nonatomic, strong) NSString * state;
@property(nonatomic, strong) NSString * city;
@property(nonatomic, strong) NSString  *street;

@property(nonatomic, strong) NSString * tageline;
@property(nonatomic, assign) int religion;
@property(nonatomic, strong) NSMutableArray * photo_paths;
//@property (nonatomic, strong) NSArray * tags;

@property(nonatomic, assign) NSInteger QBUserId;

-(void)fromDictionary:(NSDictionary *)dic;


+(FXProfile *)getProfile:(NSString *)userId withView:(UIView *)view;
    

@end
