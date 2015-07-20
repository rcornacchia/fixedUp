//
//  FXFriendCell.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXFriendCell.h"
#import "FXProfileVC.h"

@implementation FXFriendCell

- (void)awakeFromNib {
    // Initialization code
    
    fixButton.layer.cornerRadius = 5;
    userImageButton.layer.cornerRadius = userImageButton.frame.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(IBAction)onFix:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(fixFriend:)]) {
        [self.delegate fixFriend:self.cell_index];
    }
}

-(void)setCellData:(FXFriend *)user
{
    userProfile = user;
    
    nameLabel.text = userProfile.name;
    
    NSURL  * tempPath =  [FXUser photoPathFromId:userProfile.fb_id];
    
    [userImageButton setImage:[UIImage imageNamed:@"anonymous"] forState:UIControlStateNormal];
    
    if ( tempPath != nil ) {
        [userImageButton setImageForState:UIControlStateNormal withURL:tempPath];
        
    }
 
    scoreLabel.text =  [NSString stringWithFormat:@"%i",(int)(userProfile.match_score * 100)];
    categoryLabel.text = [userProfile.interest componentsJoinedByString:@","];
    friendCountLabel.text = [NSString stringWithFormat:@"%i", userProfile.match_tags];

}

-(IBAction)onShowProfile:(id)sender
{
  
    FXProfile * profile = [FXProfile getProfile:userProfile.fb_id withView:nil];
    if (profile != nil) {
        FXProfileVC * controller = [APP.activeContainer.storyboard instantiateViewControllerWithIdentifier:@"FXProfileVC"];
        controller.isMyProfile = NO;
        controller.profile = profile;
        [APP.activeContainer pushViewController:controller animated:YES];
        
    }

    
}

@end
