//
//  FXFriendCell.h
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXUser.h"
@protocol FXFriendCellDelegate <NSObject>
-(void)fixFriend:(NSInteger)index;
@end

@interface FXFriendCell : UITableViewCell
{
    IBOutlet UIButton * userImageButton;
    IBOutlet UILabel * nameLabel;
    IBOutlet UILabel * scoreLabel;
    IBOutlet UILabel * categoryLabel;
    IBOutlet UILabel * friendCountLabel;
    
    IBOutlet UIButton * fixButton;
    FXUser * userProfile;
}

@property (nonatomic, assign) NSInteger cell_index;
@property (nonatomic, strong) id<FXFriendCellDelegate> delegate;

-(IBAction)onFix:(id)sender;
-(void)setCellData:(FXUser *)user;
@end
