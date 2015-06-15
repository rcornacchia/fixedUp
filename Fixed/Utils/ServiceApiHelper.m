//
//  ServiceApiHelper.m
//  Recipe
//
//  Created by Thomas Taussi on 12/19/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import "ServiceApiHelper.h"

@implementation ServiceApiHelper

//+ (NSDictionary*) fbLogin:(NSDictionary*) params{
//    ///return [ServiceApiHelper jsonHttpRequest:API_URL_FACEBOOK_LOGIN jsonParam:params];
//}

#pragma mark - Common Httl Request Methods

+ (id) commonHttpRequest:(NSString*) urlStr {
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *jsonResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", jsonResult);
    return [[SBJsonParser new] objectWithString:jsonResult];
}


+ (id) jsonHttpRequest:(NSString*) urlStr jsonParam:(NSDictionary*)params  withView:(UIView *)view{
    
    if (view != nil ) {
        MBProgressHUD * mHud =   [MBProgressHUD showHUDAddedTo:view animated:YES];
        mHud.labelText = @"Loading..";
    }
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSLog(@"Params : %@" ,params);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSString *body = [[SBJsonWriter new] stringWithObject:params];
    NSData *requestData = [body dataUsingEncoding:NSASCIIStringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%ld", (unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *jsonResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", jsonResult);
    
    [MBProgressHUD hideAllHUDsForView:view animated:YES];

    return [[SBJsonParser new] objectWithString:jsonResult];
    
}


+ (id) httpRequestWithAction:(NSString *)actionName contentParam:(NSString*)postStr  withView:(UIView *)view{
    
    if (view != nil ) {
        MBProgressHUD * mHud =   [MBProgressHUD showHUDAddedTo:view animated:YES];
        
        NSString * progressStr = @"";
        
        if ([actionName isEqualToString:FIXED_API_SAVE_MATCH_PREFERENCE]) {
            progressStr = @"Saving...";
        }else if ([actionName isEqualToString:FIXED_API_SAVE_PROFILE]){
             progressStr = @"Saving...";
        }
        
        mHud.labelText = progressStr;
    }
    
    
    
    NSURL * url;
    
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"MMddHHmmss"];
    NSString *dateStr = [formater stringFromDate:[NSDate new]];
    NSString *urlStr= [NSString stringWithFormat:@"%@%@?_dc=%@",API_URL, actionName, dateStr];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    url= [NSURL URLWithString:urlStr];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];

    
    [request setHTTPMethod:@"POST"];
    //[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
   // [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSData *postData = [postStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString * postLength = [NSString stringWithFormat:@"%d",(int)[postData length]];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
   
    NSError * error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    
     NSLog(@"Action Name: %@", actionName);
    if (error) {
        
        NSLog(@"Error: %@", error);
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show ];
        
        return nil;
    }else{
        NSString *jsonResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", jsonResult);
        
        if(view != nil){
            [MBProgressHUD hideAllHUDsForView:view animated:YES];
        }
        return [[SBJsonParser new] objectWithString:jsonResult];
    }
}


+ (void) httpAsyncRequestWithAction:(NSString *)actionName contentParam:(NSString*)postStr withHandler:(void (^)(NSDictionary *  response)) handler{
   
    NSURL * url;
    
    NSDateFormatter * formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"MMddHHmmss"];
    NSString *dateStr = [formater stringFromDate:[NSDate new]];
    NSString *urlStr= [NSString stringWithFormat:@"%@%@?_dc=%@",API_URL, actionName, dateStr];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    url= [NSURL URLWithString:urlStr];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    
    [request setHTTPMethod:@"POST"];
    //[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSData *postData = [postStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString * postLength = [NSString stringWithFormat:@"%d",(int)[postData length]];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:nil completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        
        NSString *jsonResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", jsonResult);
        
        //[[SBJsonParser new] objectWithString:jsonResult];
        
        
    }];
    
}


@end
