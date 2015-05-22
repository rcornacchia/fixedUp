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
    userPhotoButton.layer.cornerRadius = userPhotoButton.frame.size.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)onDetail:(id)sender
{
    FXProfileVC * controller = [APP.activeContainer.storyboard instantiateViewControllerWithIdentifier:@"FXProfileVC"];
    [APP.activeContainer pushViewController:controller animated:YES];
}

@end
