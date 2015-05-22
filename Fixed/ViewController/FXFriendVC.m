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

@interface FXFriendVC ()<UITableViewDataSource, UITableViewDelegate, FXFriendCellDelegate, UITextFieldDelegate>
{
    IBOutlet UIButton * myPhotoButton;
    IBOutlet UILabel * nameLabel;
    
    IBOutlet UITableView * friendTableView;
    
    IBOutlet UIView * fixView;
    IBOutlet UIView * fixSubView;
    
    IBOutlet UIImageView * myPhotoImageView;
    IBOutlet UIImageView * friendImageView;
    IBOutlet UIButton * fixItButton;
    IBOutlet UIButton *checkButton;
    IBOutlet UITextField * commentTextField;
    
    NSMutableArray * friendList;
   
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


// TableView Delegate And Datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FXFriendCell *cell = (FXFriendCell *) [tableView dequeueReusableCellWithIdentifier:@"friendCell"];
    
    cell.delegate = self;
    cell.cell_index = indexPath.row;
    return  cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}


// FXFriendCell Delegate

-(void)fixFriend:(NSInteger)index
{
    [fixView setHidden:NO];
}

/// FixView Action

-(IBAction)onFixIt:(id)sender
{
    
}

-(IBAction)onCloseFixView:(id)sender
{
    [fixView setHidden:YES];
}

-(IBAction)onShowUserProfile:(id)sender
{
    
}


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
