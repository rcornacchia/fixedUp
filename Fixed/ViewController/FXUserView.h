//
//  FXUserView.h
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXUserView : UIView
{
    CGPoint startPoint;
    
    CGPoint beforePoint;
    CGPoint currentPoint;

}
@property (nonatomic, strong) IBOutlet UIImageView * userImageView;
@property (nonatomic, assign) NSInteger userIndex;

-(void)updateUserImage:(UIImage *)image;
-(void)updateUserImageWithURL:(NSString *)imageUrl;

-(IBAction)onDetailClick:(id)sender;


@end
