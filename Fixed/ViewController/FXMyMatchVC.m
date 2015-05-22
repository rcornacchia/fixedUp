//
//  FXMyMatchVC.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXMyMatchVC.h"
#import "UIViewController+JDSideMenu.h"
#import "FXProfileVC.h"
#import "FXSuggestedCell.h"
#import "FXMyMatchCell.h"

@interface FXMyMatchVC ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, FXSuggestedCellDelegate, UITextFieldDelegate>
{
    IBOutlet UIView *chatView;
    
    IBOutlet UIButton * myphotoButton;
    IBOutlet UIButton * friendPhotoButton;
    
    // AcppedView
    
    IBOutlet UIView * acceptView;
    IBOutlet UIView  * acceptSubView;
    IBOutlet UIButton * continueButton;
    IBOutlet UIButton * showCheckButton;
    
    // user Preview;
    
    IBOutlet UIView * userPreView;
    IBOutlet UIView * userPreSubView;
    
    IBOutlet UIButton  * selectedUserPhotoButton;
    IBOutlet UIButton * viewProfileButton;
    IBOutlet UILabel * nameLabel;
    IBOutlet UIButton * suggestedFriendPhotoButton;
    IBOutlet UILabel * suggestedFriendNameLabel;
    
    // Purchase Coin
    
    IBOutlet UIView * purchaseCoinView;
    IBOutlet UIView * purchaseCoinSubView;
    
    IBOutlet UIButton * buyButtton1;
    IBOutlet UIButton * buyButtton2;
    IBOutlet UIButton * buyButtton3;
    
    // Main UI
    
    IBOutlet UITextField * searchBar;
    
    IBOutlet UILabel * suggesteFriendCountLabel;
    IBOutlet UICollectionView  * suggestedFriendCollectionView;
    IBOutlet UITableView * friendTableView;
    
    
    
}
@end

@implementation FXMyMatchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initMyMatchView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initMyMatchView
{

    suggesteFriendCountLabel.text = @"8";
    searchBar.delegate  = self;
    suggestedFriendCollectionView.delegate = self;
    suggestedFriendCollectionView.dataSource = self;
    
    friendTableView.delegate = self;
    friendTableView.dataSource = self;
    
    [acceptView setHidden:YES];
    acceptSubView.layer.borderColor = FIXED_DARK_GRAY_COLOR.CGColor;
    acceptSubView.layer.borderWidth = 1.5;
    acceptSubView.layer.cornerRadius = 15;
    
    continueButton.layer.cornerRadius = 8;
    
    [userPreView setHidden:YES];
    userPreSubView.layer.borderColor = FIXED_DARK_GRAY_COLOR.CGColor;
    userPreSubView.layer.borderWidth = 1.5;
    userPreSubView.layer.cornerRadius = 15;
    
    selectedUserPhotoButton.layer.cornerRadius = selectedUserPhotoButton.frame.size.width/2;
    suggestedFriendPhotoButton.layer.cornerRadius = suggestedFriendPhotoButton.frame.size.width/2;
    
    
    viewProfileButton.layer.cornerRadius = 8;
    
    
    [chatView setHidden:YES];

    myphotoButton.layer.cornerRadius = myphotoButton.frame.size.width/2;
    friendPhotoButton.layer.cornerRadius = friendPhotoButton.frame.size.width/2;
    
    purchaseCoinView.hidden = YES;
    purchaseCoinSubView.layer.borderWidth = 1.5;
    purchaseCoinSubView.layer.borderColor = FIXED_GREEN_COLOR.CGColor;
    purchaseCoinSubView.layer.cornerRadius = 10;
    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] init];
    [gesture addTarget:self action:@selector(closePurchaseView:)];
    [purchaseCoinView addGestureRecognizer:gesture];
    
    buyButtton1.layer.cornerRadius = 5;
    buyButtton2.layer.cornerRadius = 5;
    buyButtton3.layer.cornerRadius = 5;
    
}


-(IBAction)onMenu:(id)sender
{
    if([self.sideMenuController isMenuVisible])
    {
        [self.sideMenuController hideMenuAnimated:YES];
    }else{
        [self.sideMenuController showMenuAnimated:YES];
    }
}

// Purchase View

-(void)closePurchaseView:(UITapGestureRecognizer *)gesture
{
    CGPoint  point = [gesture locationInView:purchaseCoinView];
    
    if (!CGRectContainsPoint(purchaseCoinSubView.frame, point)) {
        purchaseCoinView.hidden = YES;
    }
}

-(IBAction)onClosePurchaseView:(id)sender
{
    purchaseCoinView.hidden = YES;

}


// PreView Action

-(IBAction)onClosePreview:(id)sender
{
    [userPreView setHidden:YES];
}

-(IBAction)onViewProfile:(id)sender
{
    FXProfileVC * profileVc = (FXProfileVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"FXProfileVC"];
    profileVc.isMyProfile = NO;
    
    [self.navigationController pushViewController:profileVc animated:YES];
}

//Accept Action

-(IBAction)onCloseAcceptView:(id)sender
{
    [acceptView setHidden:YES];
}


-(IBAction)onChangeShowFlag:(id)sender
{
    if (showCheckButton.isSelected) {
        [showCheckButton setSelected:NO];
    }else{
        [showCheckButton setSelected:YES];
    }
}

-(IBAction)onContinue:(id)sender
{
    [acceptView setHidden:YES];
    [chatView setHidden:NO];
}
/// Chat View Action

-(IBAction)onChat:(id)sender
{
    
}

-(IBAction)onChatBack:(id)sender
{
    [chatView setHidden:YES];
}



/// UI tableview Delegate and UI collection View delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FXMyMatchCell * cell = (FXMyMatchCell *) [tableView dequeueReusableCellWithIdentifier:@"matchFriendCell"];
    
    return  cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
    
}

// Collection View

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FXSuggestedCell * cell = (FXSuggestedCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"matchSuggestedFriendCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.cell_index = indexPath.item;
    
    [cell.centerRejectButton setHidden:YES];

    return  cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


/// Cell Delegate

-(void)rejectFriend:(NSInteger)index
{
    
}

-(void)likeFriend:(NSInteger)index
{
    [acceptView setHidden:NO];
}

-(void)viewSuggestedFriend:(NSInteger)index
{
    [userPreView setHidden:NO];
}


// UItextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
