//
//  FXMyMatchCell.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXMyMatchCell.h"
#import "FXProfileVC.h"

@implementation FXMyMatchCell

- (void)awakeFromNib {
    // Initialization code
    self.userPhotoButton.layer.cornerRadius = self.userPhotoButton.frame.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)renderCell:(FXMatch *)match
{
    if ([match.user1_id isEqualToString:[FXUser sharedUser].fb_id]) {
        [self.userPhotoButton setImageForState:UIControlStateNormal withURL:[FXUser photoPathFromId:match.user2_id] placeholderImage:[UIImage imageNamed:@"anonymous.png"]];
        self.nameLabel.text = match.user2_name;
        self.user_id = match.user2_id;
    }else{
        [self.userPhotoButton setImageForState:UIControlStateNormal withURL:[FXUser photoPathFromId:match.user1_id] placeholderImage:[UIImage imageNamed:@"anonymous.png"]];
        self.nameLabel.text = match.user1_name;
        self.user_id =  match.user1_id;
    }
    
    self.commentLabel.text = match.comment;
}

-(IBAction)onDetail:(id)sender
{    
    FXProfile * profile = [FXProfile getProfile:self.user_id withView:nil];
    if (profile != nil) {
        FXProfileVC * controller = [APP.activeContainer.storyboard instantiateViewControllerWithIdentifier:@"FXProfileVC"];
        controller.isMyProfile = NO;
        controller.profile = profile;
        [APP.activeContainer pushViewController:controller animated:YES];
        
    }

}


@end
