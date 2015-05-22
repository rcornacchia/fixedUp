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

-(void)setCellData:(FXUser *)user
{
    userProfile = user;
}

-(IBAction)onShowProfile:(id)sender
{
    FXProfileVC * controller = [APP.activeContainer.storyboard instantiateViewControllerWithIdentifier:@"FXProfileVC"];
    [APP.activeContainer pushViewController:controller animated:YES];
}

@end
