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
#import "FXChatVC.h"


@interface FXMyMatchVC ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, FXSuggestedCellDelegate, UITextFieldDelegate, MKStoreObserverDelegate>
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
    
    NSString * selectedUserId;
    
    // Purchase Coin
    
    IBOutlet UIView * purchaseCoinView;
    IBOutlet UIView * purchaseCoinSubView;
    
    IBOutlet UIButton * buyButtton1;
    IBOutlet UIButton * buyButtton2;
    IBOutlet UIButton * buyButtton3;
    
    // Main UI
    
    IBOutlet UITextField * searchBar;
    
    IBOutlet UILabel * coinCountLabel;
    
    IBOutlet UICollectionView  * suggestedFriendCollectionView;
    IBOutlet UITableView * friendTableView;
    
    NSMutableArray * suggestedMatches;
    NSMutableArray * myMatches;
 
    FXMatch * selectedMatch;
    
    QBChatDialog *chatDialog;
}
@end

@implementation FXMyMatchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [MKStoreManager sharedManager].storeObserver.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
     [self initMyMatchView];
}

-(void)initMyMatchView
{
    searchBar.delegate  = self;
    suggestedFriendCollectionView.delegate = self;
    suggestedFriendCollectionView.dataSource = self;
    
    friendTableView.delegate = self;
    friendTableView.dataSource = self;
    friendTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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
    purchaseCoinSubView.layer.borderColor = FIXED_RED_COLOR.CGColor;
    purchaseCoinSubView.layer.cornerRadius = 10;
    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] init];
    [gesture addTarget:self action:@selector(closePurchaseView:)];
    [purchaseCoinView addGestureRecognizer:gesture];
    
    buyButtton1.layer.cornerRadius = 5;
    buyButtton2.layer.cornerRadius = 5;
    buyButtton3.layer.cornerRadius = 5;
    
    [self refreshCoins];
 
    
    [self loadData];
}


-(void)loadData{
    NSDictionary * tempDic = [[FXUser sharedUser]  getMyMatches:self.view];
    if (tempDic != nil) {
        
        suggestedMatches = [FXMatch  matchesFromArray:[tempDic objectForKey:@"suggested_matches"]];
        myMatches = [FXMatch  matchesFromArray:[tempDic objectForKey:@"accepted_matches"]];
     
        [suggestedFriendCollectionView reloadData];
        [friendTableView reloadData];
    }
}

-(void)refreshCoins{
     coinCountLabel.text = [NSString stringWithFormat:@"%i",[FXUser sharedUser].coins];
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
    FXProfile * profile = [FXProfile getProfile:selectedUserId withView:nil];
    if (profile != nil) {
        FXProfileVC * controller = [APP.activeContainer.storyboard instantiateViewControllerWithIdentifier:@"FXProfileVC"];
        controller.isMyProfile = NO;
        controller.profile = profile;
        [APP.activeContainer pushViewController:controller animated:YES];
        
    }
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
    NSString * user_id;
    if ([selectedMatch.user1_id isEqualToString:[FXUser sharedUser].fb_id]) {
        user_id = selectedMatch.user2_id;
    }else{
        user_id = selectedMatch.user1_id;
    }
    
    FXProfile * profile = [FXProfile  getProfile:user_id withView:nil];
    
    if (profile != nil ) {
        [self fetchQBChatDialogWithFriendId:profile.fb_id withQBUserId:profile.QBUserId];
    }
}

-(IBAction)onChatBack:(id)sender
{
    [chatView setHidden:YES];
}



/// UI tableview Delegate and UI collection View delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FXMyMatchCell * cell = (FXMyMatchCell *) [tableView dequeueReusableCellWithIdentifier:@"matchFriendCell"];
    [cell renderCell:[myMatches objectAtIndex:indexPath.row]];
    
    return  cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (myMatches == nil ) {
        return 0;
    }
    return [myMatches count];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    selectedMatch = [myMatches objectAtIndex:indexPath.row];
    
    NSString * user_id;
    if ([selectedMatch.user1_id isEqualToString:[FXUser sharedUser].fb_id]) {
        user_id = selectedMatch.user2_id;
    }else{
        user_id = selectedMatch.user1_id;
    }

    
    FXProfile * profile = [FXProfile getProfile:user_id withView:nil];
    if (profile == nil) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    }else{
            [self fetchQBChatDialogWithFriendId:profile.fb_id withQBUserId:profile.QBUserId];
    }
    
    
}

// Collection View

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FXSuggestedCell * cell = (FXSuggestedCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"matchSuggestedFriendCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.cell_index = indexPath.item;
    [cell renderCell:[suggestedMatches objectAtIndex:indexPath.item]];
    
    return  cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (suggestedMatches == nil ) {
        return 0;
    }
    return [suggestedMatches count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


/// Cell Delegate

-(void)rejectFriend:(NSInteger)index
{
    [suggestedMatches removeObjectAtIndex:index];
    NSIndexPath * tempIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [suggestedFriendCollectionView deleteItemsAtIndexPaths:@[tempIndexPath]];
  
    [self refreshCoins];
}

-(void)likeFriend:(NSInteger)index withAcceptFlag:(BOOL)flag
{
    if (flag) {
        [acceptView setHidden:NO];
        
        FXMatch * tempMatch =  [suggestedMatches objectAtIndex:index];
        selectedMatch = tempMatch;
        
        tempMatch.is_accept = YES;
        [suggestedMatches removeObjectAtIndex:index];
        [myMatches addObject:tempMatch];

        NSIndexPath * tempIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [suggestedFriendCollectionView deleteItemsAtIndexPaths:@[tempIndexPath]];
        
        tempIndexPath = [NSIndexPath indexPathForItem:[myMatches count] -1  inSection:0];
        [friendTableView insertRowsAtIndexPaths:@[tempIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }else{
        if ([FXUser sharedUser].coins == 0) {
            [purchaseCoinView setHidden:NO];
        }
        
        [self refreshCoins];
    }
}


-(void)viewSuggestedFriend:(NSInteger)index
{
    FXMatch * match = [suggestedMatches objectAtIndex:index];
    
    if ([match.user1_id isEqualToString:[FXUser sharedUser].fb_id]) {
        [selectedUserPhotoButton setImageForState:UIControlStateNormal withURL:[FXUser photoPathFromId:match.user2_id] placeholderImage:[UIImage imageNamed:@"anonymous.png"]];
        [nameLabel setText:match.user2_name];
        
        selectedUserId = match.user2_id;
        
    }else{
        [selectedUserPhotoButton setImageForState:UIControlStateNormal withURL:[FXUser photoPathFromId:match.user1_id]placeholderImage:[UIImage imageNamed:@"anonymous.png"]];
        [nameLabel setText:match.user1_name];
        selectedUserId = match.user1_id;

    }
    
    if (match.anonymous) {
        [suggestedFriendPhotoButton setImage:[UIImage imageNamed:@"anonymous.png"] forState:UIControlStateNormal];
    }else{
        [suggestedFriendPhotoButton setImageForState:UIControlStateNormal withURL:[FXUser photoPathFromId:match.provider_id] placeholderImage:[UIImage imageNamed:@"anonymous.png"]];
        
    }
    
    suggestedFriendNameLabel.text = [NSString stringWithFormat:@"\"%@\"\n-%@",match.comment, match.provider_name];
    
    [userPreView setHidden:NO];
}


// UItextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// Coin Purchase Processing

-(IBAction)onBuy1:(id)sender{

    [[MKStoreManager sharedManager] onBuy1];

}

-(IBAction)onBuy5:(id)sender{

    [[MKStoreManager sharedManager] onBuy5];
  
}

-(IBAction)onBuy10:(id)sender{
    
    [[MKStoreManager sharedManager] onBuy10];
  
}

// In-App Purchase Delegate

-(void)addPuchasedCoin:(NSInteger)coinCount{
    
    NSString * keyStr = [NSString stringWithFormat:@"%@_addedcoin", [FXUser sharedUser].fb_id];
    [[NSUserDefaults standardUserDefaults] setInteger:coinCount  forKey:keyStr];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    BOOL result =   [[FXUser sharedUser] addCoin:self.view];
    
    if (result) {
        [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"You purchased %i coins", coinCount] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        
        coinCountLabel.text = [NSString stringWithFormat:@"%i", (int)[FXUser sharedUser].coins];
    }
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"gotoChatView"]) {
        FXChatVC  * controller = segue.destinationViewController;
        
        controller.match =  [myMatches objectAtIndex:[friendTableView indexPathForSelectedRow].row];
        controller.dialog = chatDialog;
    }
}

-(void)fetchQBChatDialogWithFriendId:(NSString *)friendId withQBUserId:(NSUInteger)QBUserId{
    
    QBChatDialog *tempChatDialog = [QBChatDialog new];
    
    NSMutableArray *selectedUsersIDs = [NSMutableArray array];
    [selectedUsersIDs addObject:@(QBUserId)];
    
    tempChatDialog.occupantIDs = selectedUsersIDs;
    tempChatDialog.type = QBChatDialogTypePrivate;
  
    __strong __typeof(self)weakSelf = self;
    [QBRequest createDialog:tempChatDialog successBlock:^(QBResponse *response, QBChatDialog *createdDialog) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        chatDialog = createdDialog;
        [ChatService shared].messages = [[NSMutableDictionary alloc] init];
        
        [weakSelf performSegueWithIdentifier:@"gotoChatView" sender:nil];
    } errorBlock:^(QBResponse *response) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors"
                                                        message:response.error.error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        [alert show];
        
    }];

}

@end
