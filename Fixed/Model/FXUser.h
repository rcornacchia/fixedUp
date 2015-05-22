//
//  FXUser.h
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FXUser : NSObject

@property (nonatomic, strong) NSString * idString;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) int  score;
@property (nonatomic, assign) int friendCount;
@property (nonatomic, strong) NSString * categories;
@property (nonatomic, strong) NSString * imageUrl;

@end
