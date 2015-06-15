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

-(void)renderCell:(FXMatch *)match
{
    self.suggestedMatch = match;
    
    if ([match.user1_id isEqual:[FXUser sharedUser].fb_id]) {
        [self.userPhotoButton setBackgroundImageForState:UIControlStateNormal withURL:[FXUser photoPathFromId:match.user2_id]];
        
    }else{
        [self.userPhotoButton setBackgroundImageForState:UIControlStateNormal withURL:[FXUser photoPathFromId:match.user1_id]];
        
    }
    
    [self.leftRejectButton setHidden:NO];
    [self.likeButton setHidden:NO];
    [self.likeButton setSelected:NO];
    [self.centerRejectButton setHidden:NO];
    
    if ( match.liked_user_id == nil || [match.liked_user_id isEqualToString:@""]){
        [self.centerRejectButton setHidden:YES];
    }else if([match.liked_user_id isEqualToString:[FXUser sharedUser].fb_id]) { // if I like this user .
        [self.leftRejectButton setHidden:YES];
        [self.likeButton setHidden:YES];
    }else{
        [self.likeButton setSelected:YES];
    }
 
}

-(IBAction)onReject:(id)sender
{
       if([FXMatch dislikeMatch:self.suggestedMatch.idString]){
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(rejectFriend:)]) {
                [FXUser sharedUser].coins ++;
                [self.delegate rejectFriend:self.cell_index];
            }
       }
}

-(IBAction)onLike:(id)sender
{
    if ( self.suggestedMatch.liked_user_id == nil || [self.suggestedMatch.liked_user_id isEqualToString:@""]){
      
        if ([FXUser sharedUser].coins == 0) {
              if (self.delegate != nil && [self.delegate respondsToSelector:@selector(likeFriend: withAcceptFlag:)]) {
                  [self.delegate likeFriend:self.cell_index withAcceptFlag:NO];
              }
            return;
        }
        if([FXMatch likeFriend:self.suggestedMatch.idString withUserId:[FXUser sharedUser].fb_id]){
            self.suggestedMatch.liked_user_id = [FXUser sharedUser].fb_id;
            [FXUser sharedUser].coins --;
            
            [self.centerRejectButton setHidden:NO];
            [self.leftRejectButton setHidden:YES];
            [self.likeButton setHidden:YES];
            
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(likeFriend: withAcceptFlag:)]) {
                [self.delegate likeFriend:self.cell_index withAcceptFlag:NO];
            }
        }
    }else{
        if([FXMatch acceptMatch:self.suggestedMatch.idString]){
            self.suggestedMatch.is_accept = YES;
            [self.centerRejectButton setHidden:YES];
            [self.leftRejectButton setHidden:YES];
            [self.likeButton setHidden:YES];
            
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(likeFriend: withAcceptFlag:)]) {
                [self.delegate likeFriend:self.cell_index withAcceptFlag:YES];
            }
        }
    }

}

-(IBAction)onDetail:(id)sender
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(viewSuggestedFriend:)]) {
        [self.delegate viewSuggestedFriend:self.cell_index];
    }

}



@end



