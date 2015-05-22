//
//  ServerManager.h
//  eMenu
//
//  Created by glenn on 12/24/14.
//  Copyright (c) 2014 glenn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyNetHelper.h"

@protocol ServerManagerDelegate <NSObject>

-(void)serviceResponse:(NSDictionary *)responseDic withActionName:(NSString *)actionName;
-(void)failToGetResponseWithError:(NSError *)error withActionName:(NSString *)actionName;

@end


@interface ServerManager : NSObject
{
    NSURLConnection *connection ;
    NSMutableData *receivedData;
    MBProgressHUD *activityIndicator;
    
    NSString * currentActionName;
    
    NSTimer * timer;
    
}

@property(strong,nonatomic)id<ServerManagerDelegate>delegate;

+(ServerManager*)sharedManager;
-(void)fetchDataOnserverWithAction:(NSString *)actionName forView:(UIView *)baseView forPostData:(NSString *)postStr;

@end
