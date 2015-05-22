//
//  FXFixedVC.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXFixedVC.h"
#import "UIViewController+JDSideMenu.h"

@interface FXFixedVC ()
{
    // UI
    
    IBOutlet UIButton *userImageButton;
    IBOutlet UIButton * addFriendButton;
    
    IBOutlet UIView* searchView;
    IBOutlet UIView * searchSubView;
    IBOutlet UISearchBar * friendSearchBar;
    IBOutlet UITableView * searchResultTableView;
    
    IBOutlet UIView * outofView;
    IBOutlet UILabel * timeLabel;
    
    IBOutlet UIView * fixView;
    IBOutlet UIView * fixSubView;
    
    IBOutlet UIImageView * myPhotoImageView;
    IBOutlet UIImageView * friendImageView;
    IBOutlet UIButton * fixItButton;
    IBOutlet UIButton *checkButton;
    IBOutlet UITextField * commentTextField;
    
}

@end

@implementation FXFixedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initFixedView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initFixedView
{

    userImageButton.layer.cornerRadius = userImageButton.frame.size.width/2;
    
    
    [searchView setHidden:YES];
    [searchSubView.layer setBorderColor:FIXED_GREEN_COLOR.CGColor];
    [searchSubView.layer setBorderWidth:1.5];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture addTarget:self action:@selector(closeSearchView:)];
    [searchView addGestureRecognizer:tapGesture];
  
    [outofView setHidden:YES];
    
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

-(IBAction)onAddFriend:(id)sender
{
    [searchView setHidden:NO];
    
}

-(IBAction)onShowFriend:(id)sender
{
    [self performSegueWithIdentifier:@"gotoFriendList" sender:nil];

}


// Close Search View
-(void)closeSearchView:(UITapGestureRecognizer * )tapRecognizer
{
    CGPoint point = [tapRecognizer locationInView:searchView];
    
    if (!CGRectContainsPoint(searchSubView.frame, point)) {
        [searchView setHidden:YES];
    }
}


/// FixView Action

-(IBAction)onFixIt:(id)sender
{
    
}

-(IBAction)onCloseFixView:(id)sender
{
    [fixView setHidden:YES];
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
