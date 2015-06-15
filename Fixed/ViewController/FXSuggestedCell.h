//
//  FXSuggestedCell.h
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FXSuggestedCellDelegate <NSObject>

-(void)rejectFriend:(NSInteger)index;
-(void)likeFriend:(NSInteger)index withAcceptFlag:(BOOL)flag;
-(void)viewSuggestedFriend:(NSInteger)index;

@end


@interface FXSuggestedCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIButton * userPhotoButton;
 @property (nonatomic, strong) IBOutlet UIButton * leftRejectButton;
 @property (nonatomic, strong)IBOutlet UIButton * centerRejectButton;
 @property (nonatomic, strong) IBOutlet UIButton * likeButton;

@property(nonatomic, strong) FXMatch * suggestedMatch;
@property (nonatomic, assign) NSInteger cell_index;

@property (nonatomic, strong) id<FXSuggestedCellDelegate> delegate;

-(void)renderCell:(FXMatch *)match;

@end
