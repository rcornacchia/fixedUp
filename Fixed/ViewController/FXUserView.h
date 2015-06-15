//
//  FXUserView.h
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXUserView : UIView
   
@property (nonatomic, strong) IBOutlet UIImageView * userImageView;
@property (nonatomic, strong) FXFriend * userObject;

-(IBAction)onDetailClick:(id)sender;
-(void)renderUserView:(FXFriend *)userObj;

@end
