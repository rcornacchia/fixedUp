//
//  ServiceApiHelper.h
//  Recipe
//
//  Created by Thomas Taussi on 12/19/14.
//  Copyright (c) 2014 ss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceApiHelper : NSObject

+ (NSDictionary*) fbLogin:(NSDictionary*) params;

+ (id) commonHttpRequest:(NSString*) urlStr;
+ (id) jsonHttpRequest:(NSString*) urlStr jsonParam:(NSDictionary*)params  withView:(UIView *)view;
+ (id) httpRequestWithAction:(NSString *)actionName contentParam:(NSString*)postStr  withView:(UIView *)view;

+ (void) httpAsyncRequestWithAction:(NSString *)actionName contentParam:(NSString*)postStr withHandler:(void (^)(NSDictionary *  response)) handler;
@end
