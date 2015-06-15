//
//  BlurImageGenerator.h
//  Fixed
//
//  Created by Glenn Chirino on 6/5/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlurImageGenerator : NSObject

+ (UIImage *)blurredSnapshot :(UIView *)containerView;

@end
