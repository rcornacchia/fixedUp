//
//  FXSuggestedCell.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXSuggestedCell.h"

@implementation FXSuggestedCell

- (void)awakeFromNib {
    // Initialization code
    _userPhotoButton.layer.cornerRadius = _userPhotoButton.frame.size.width/2;
}


-(IBAction)onReject:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(rejectFriend:)]) {
        [self.delegate rejectFriend:self.cell_index];
    }
}

-(IBAction)onLike:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(likeFriend:)]) {
        [self.delegate likeFriend:self.cell_index];
    }

}

-(IBAction)onDetail:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(viewSuggestedFriend:)]) {
        [self.delegate viewSuggestedFriend:self.cell_index];
    }

}


@end



