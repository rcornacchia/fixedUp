
//
//  BlurImageGenerator.m
//  Fixed
//
//  Created by Glenn Chirino on 6/5/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "BlurImageGenerator.h"
#import "UIImage+ImageEffects.h"

@implementation BlurImageGenerator

#pragma mark - Snapshot
+ (UIImage *)blurredSnapshot :(UIView *)containerView {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame)), NO, 1.0f);
    [containerView drawViewHierarchyInRect:CGRectMake(0, 0, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame)) afterScreenUpdates:NO];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Now apply the blur effect using Apple's UIImageEffect category
    UIImage *blurredSnapshotImage = [snapshotImage applyLightEffect];
    // Or apply any other effects available in "UIImage+ImageEffects.h"
    // UIImage *blurredSnapshotImage = [snapshotImage applyDarkEffect];
    // UIImage *blurredSnapshotImage = [snapshotImage applyExtraLightEffect];
    
    UIGraphicsEndImageContext();
    
    return blurredSnapshotImage;
}


@end
