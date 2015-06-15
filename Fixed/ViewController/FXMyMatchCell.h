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
   
    
    
}

@property (nonatomic, strong) IBOutlet UIButton *userPhotoButton;
@property (nonatomic, strong)IBOutlet UILabel * nameLabel;
@property (nonatomic, strong) IBOutlet UILabel * commentLabel;

@property (nonatomic, strong) NSString * user_id;

@property (nonatomic, assign) NSInteger cell_index;

-(void)renderCell:(FXMatch *)match;
@end
