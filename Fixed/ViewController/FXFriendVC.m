//
//  FXFriendVC.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXFriendVC.h"
#import "FXFriendCell.h"
#import "UIViewController+JDSideMenu.h"
#import "FXProfileVC.h"


@interface FXFriendVC ()<UITableViewDataSource, UITableViewDelegate, FXFriendCellDelegate, UITextFieldDelegate>
{
    IBOutlet UIButton * myPhotoButton;
    IBOutlet UILabel * nameLabel;
    
    IBOutlet UITableView * friendTableView;
    
    IBOutlet UIView * fixView;
    IBOutlet UIScrollView * fixScrollView;
    IBOutlet UIView * fixSubView;
    
    IBOutlet UIImageView * myPhotoImageView;
    IBOutlet UIImageView * friendImageView;
    IBOutlet UIButton * fixItButton;
    IBOutlet UIButton *checkButton;
    IBOutlet UITextField * commentTextField;
    
    FXFriend * centerPerson;
    
    NSInteger activeIndex;
}

@end

@implementation FXFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initFriendView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initFriendView
{
    
    centerPerson = [self.friendList objectAtIndex:0];
    
    friendTableView.delegate = self;
    friendTableView.dataSource = self;
    
    friendTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    myPhotoButton.layer.cornerRadius = myPhotoButton.frame.size.width/2;
    
    [fixView setHidden:YES];
    fixSubView.layer.borderColor = FIXED_GREEN_COLOR.CGColor;
    fixSubView.layer.borderWidth = 1.5;
    fixSubView.layer.cornerRadius = 5;
    
    myPhotoImageView.layer.cornerRadius = myPhotoImageView.frame.size.width/2;
    friendImageView.layer.cornerRadius = friendImageView.frame.size.width/2;
    
    fixItButton.layer.cornerRadius = 5;
    
    commentTextField.delegate = self;
    
    // Set Facebook Friend
    
    NSURL  * tempPath =  [FXUser photoPathFromId:centerPerson.fb_id]  ;
    
    if ( tempPath != nil ) {
       [myPhotoButton setBackgroundImageForState:UIControlStateNormal withURL:tempPath];

    }
    
    nameLabel.text = centerPerson.name;
    
}

-(IBAction)onMenu:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    return;
    
    
    if([self.sideMenuController isMenuVisible])
    {
        [self.sideMenuController hideMenuAnimated:YES];
    }else{
        [self.sideMenuController showMenuAnimated:YES];
    }
}


// TableView Delegate And Datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FXFriendCell *cell = (FXFriendCell *) [tableView dequeueReusableCellWithIdentifier:@"friendCell"];
    
    cell.delegate = self;
    cell.cell_index = indexPath.row;
    [cell setCellData:[self.friendList objectAtIndex:indexPath.row + 1]];
    
    return  cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.friendList == nil || [self.friendList count] < 2) {
        return 0;
    }
    return [self.friendList count] -1;
}


// FXFriendCell Delegate

-(void)fixFriend:(NSInteger)index
{
    activeIndex = index;
    FXFriend * friendData = [self.friendList objectAtIndex:index + 1];
    [friendImageView setImageWithURL:[FXUser photoPathFromId:friendData.fb_id]];
    [myPhotoImageView setImage:myPhotoButton.currentBackgroundImage];
    
    commentTextField.text = @"";
    [checkButton setSelected:NO];
    [fixView setHidden:NO];
}


/// FixView Action

-(IBAction)onFixIt:(id)sender
{
    FXFriend * friend = [self.friendList objectAtIndex:activeIndex + 1];
    
    NSString * postStr = [NSString stringWithFormat:@"user1=%@&user2=%@&comment=%@&anonymous=%i",centerPerson.fb_id, friend.fb_id, commentTextField.text, checkButton.isSelected];
    if( [[FXUser sharedUser] fixIt:postStr withView:self.view]){
        [FXUser sharedUser].activeFixes --;
    }
    
    [self  onCloseFixView:nil];
    
}

-(IBAction)onCheckAnonymous:(id)sender{
    if (checkButton.isSelected) {
        [checkButton setSelected:NO];
    }else{
        [checkButton setSelected:YES];
    }
}

-(IBAction)onCloseFixView:(id)sender
{
    [fixView setHidden:YES];
    [self hideKeyboard];
}

-(IBAction)onShowUserProfile:(id)sender
{   
    FXProfile * profile = [FXProfile getProfile:centerPerson.fb_id withView:nil];
    if (profile != nil) {
        FXProfileVC * controller = [APP.activeContainer.storyboard instantiateViewControllerWithIdentifier:@"FXProfileVC"];
        controller.isMyProfile = NO;
        controller.profile = profile;
        [APP.activeContainer pushViewController:controller animated:YES];
        
    }
}


// TextField Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == commentTextField) {
        [fixScrollView setContentOffset:CGPointMake(0, fixSubView.frame.origin.y - 50)];
    }
    
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == commentTextField) {
        [self hideKeyboard];
    }
    return YES;
}


-(void)hideKeyboard{
    [commentTextField resignFirstResponder];
    [fixScrollView setContentOffset:CGPointMake(0, 0)];
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
