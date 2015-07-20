//
//  FXUserView.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXUserView.h"
#import "FXProfileVC.h"

@implementation FXUserView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    // Initialization code
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2;
}


-(void)renderUserView:(FXFriend *)userObj
{
    self.userObject = userObj;
    
    NSURL  * tempPath =  [FXUser photoPathFromId:self.userObject.fb_id]  ;
    
    [self.userImageView setImage:[UIImage imageNamed:@"anonymous"]];
    
    if ( tempPath != nil ) {
        [self.userImageView setImageWithURL:tempPath];
    }
    
}

-(IBAction)onDetailClick:(id)sender
{
    FXProfile * profile = [FXProfile getProfile:self.userObject.fb_id withView:nil];
    if (profile != nil) {
        FXProfileVC * controller = [APP.activeContainer.storyboard instantiateViewControllerWithIdentifier:@"FXProfileVC"];
        controller.isMyProfile = NO;
        controller.profile = profile;
        [APP.activeContainer pushViewController:controller animated:YES];

    }
}

@end
