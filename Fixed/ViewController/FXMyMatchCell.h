//
//  FXMyMatchCell.h
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FXMyMatchCell : UITableViewCell
{
    IBOutlet UIButton *userPhotoButton;
    IBOutlet UILabel * nameLabel;
    IBOutlet UILabel * commentLabel;
    
}

@property (nonatomic, assign) NSInteger cell_index;

@end
