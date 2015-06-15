//
//  FXFixedVC.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXFixedVC.h"
#import "UIViewController+JDSideMenu.h"
#import "FXUserView.h"
#import "UIGestureRecognizer+DraggingAdditions.h"

#import "FXFriendVC.h"

@interface FXFixedVC ()<UIGestureRecognizerDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    // UI
    
    IBOutlet UIView * mainFriendsView;
    IBOutlet UIImageView * centerBackgroundView;
    IBOutlet UIButton *centerFriendButton;
    IBOutlet UIButton * addFriendButton;
    
    IBOutlet UIView* searchView;
    IBOutlet UIView * searchSubView;
    IBOutlet UISearchBar * friendSearchBar;
    IBOutlet UITableView * searchResultTableView;
    
    IBOutlet UIView * outofView;
    IBOutlet UILabel * timeLabel;
    
    IBOutlet UIView * fixView;
    IBOutlet UIScrollView * fixScrollView;
    IBOutlet UIView * fixSubView;
    
    IBOutlet UIImageView * myPhotoImageView;
    IBOutlet UIImageView * friendImageView;
    IBOutlet UIButton * fixItButton;
    IBOutlet UIButton *checkButton;
    IBOutlet UITextField * commentTextField;
    
    IBOutletCollection(FXUserView) NSArray *suggestFriends;
    
    FXUserView * activeDragView;
    CGRect beginRect;
    
    IBOutletCollection(UIImageView)NSArray * dotImageViews;
    
    FXFriend * centerPerson;
    
    NSInteger  centerPersonIndex;
    
    NSMutableArray * searchResultArray;
    
}

@end

@implementation FXFixedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshDots];
    
    
     [self initFixedView];
}

-(void)initFixedView
{
    centerPersonIndex = 0;
    if ([FXUser sharedUser].suggestedFriendList != nil) {
        self.facebookFriendList = [[FXUser sharedUser].suggestedFriendList objectAtIndex:centerPersonIndex];
    }else{
        self.facebookFriendList = nil;
    }

    searchResultArray = [FXUser sharedUser].myFriendList;
    
    UIPanGestureRecognizer *panRecognizer;
    for (FXUserView * tempView in suggestFriends) {
        panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanRecognizer:)];
        [tempView addGestureRecognizer:panRecognizer];
        
    }
    
    [self refreshDots];

    UISwipeGestureRecognizer * leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(handleSwipe:)];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer * rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(handleSwipe:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
     [centerFriendButton addGestureRecognizer:leftSwipeGesture];
    [centerFriendButton addGestureRecognizer:rightSwipeGesture];
    
    centerFriendButton.layer.cornerRadius = centerFriendButton.frame.size.width/2;
    
    [searchView setHidden:YES];
    [searchSubView.layer setBorderColor:FIXED_GREEN_COLOR.CGColor];
    [searchSubView.layer setBorderWidth:1.5];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture addTarget:self action:@selector(closeSearchView:)];
    [searchView addGestureRecognizer:tapGesture];
    
    [friendSearchBar setDelegate:self];
    
    [searchResultTableView setDelegate:self];
    [searchResultTableView setDataSource:self];
    [searchResultTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    
    
    [fixView setHidden:YES];
    fixSubView.layer.borderColor = FIXED_GREEN_COLOR.CGColor;
    fixSubView.layer.borderWidth = 1.5;
    fixSubView.layer.cornerRadius = 5;
    
    myPhotoImageView.layer.cornerRadius = myPhotoImageView.frame.size.width/2;
    friendImageView.layer.cornerRadius = friendImageView.frame.size.width/2;
    
    fixItButton.layer.cornerRadius = 5;
    
    commentTextField.delegate = self;
    
    [self refreshSuggestFriends];
    
}

-(NSString *)getLocalTimeFromUTC
{
    NSTimeZone * localTimeZone = [NSTimeZone localTimeZone];
    
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];

    NSString * tempStr = @"12:00:00";
    NSString * formatStr2 = @"HH:mm:ss";
    NSDateFormatter * formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:formatStr2];
    [formatter2 setTimeZone:utcTimeZone];
    NSDate * tempDate = [formatter2 dateFromString:tempStr];
   
    [formatter2 setTimeZone:localTimeZone];
    
    return [formatter2 stringFromDate:tempDate];
    
}

-(void)refreshDots
{
    int counter = 0;
    for (UIImageView * tempImageVIew  in dotImageViews) {
        
        if (counter < [FXUser sharedUser].activeFixes) {
            [tempImageVIew setHighlighted:YES];
        }else{
            [tempImageVIew setHighlighted:NO];
        }
        
        counter ++ ;
    }
    
    
    if ([FXUser sharedUser].activeFixes <= 0 ) {
        [outofView setHidden:NO];
        
        timeLabel.text = [NSString stringWithFormat:@"GET MORE IN \n %@",[self getLocalTimeFromUTC]];
    }else{
        [outofView setHidden:YES];
        
    }
}

-(void)refreshSuggestFriends
{
    // Set Data
    
    if (self.facebookFriendList == nil) {
        [mainFriendsView setHidden:YES];
        [outofView setHidden:NO];
        [timeLabel setText:@"You don't have Friends"];
        return;
    }
    
    centerPerson = [self.facebookFriendList objectAtIndex:0];
    
    NSURL  * tempPath =  [FXUser photoPathFromId:centerPerson.fb_id]  ;
    
    if ( tempPath != nil ) {
        [centerFriendButton setBackgroundImageForState:UIControlStateNormal withURL:tempPath];
       
    }
    
    FXFriend * tempUser;
    
    FXUserView * friendView;
    for (int i = 0 ; i < [suggestFriends count]; i++) {
        friendView = [suggestFriends objectAtIndex:i];
        if (i <[self.facebookFriendList count]-1) {
            [friendView setHidden:NO];
            tempUser = [self.facebookFriendList objectAtIndex:i+1];
            [friendView renderUserView:tempUser];
        }else{
            [friendView setHidden:YES];
        }
        
    }

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
        [friendSearchBar resignFirstResponder];
    }
}

//TableView Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [searchResultTableView dequeueReusableCellWithIdentifier:@"searchCell"];
    
    UIImageView * tempImageView = (UIImageView *)[cell viewWithTag:123];
    
    UILabel * tempNameLabel = (UILabel *)[cell viewWithTag:124];
    
    tempImageView.layer.cornerRadius = tempImageView.frame.size.width/2;
    NSDictionary * tempDic = [searchResultArray objectAtIndex:indexPath.row];
    
    [tempImageView setImageWithURL:[FXUser photoPathFromId:[tempDic objectForKey:@"id"]]];
    tempNameLabel.text = [tempDic objectForKey:@"name"] == nil ? @"" :[tempDic objectForKey:@"name"];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searchResultArray != nil ) {
        return [searchResultArray count];
    }
    
    return 0;
}


/// FixView Action

-(IBAction)onFixIt:(id)sender
{
    NSString * postStr = [NSString stringWithFormat:@"user1=%@&user2=%@&comment=%@&anonymous=%i",centerPerson.fb_id, activeDragView.userObject.fb_id, commentTextField.text, checkButton.isSelected];
    if( [[FXUser sharedUser] fixIt:postStr withView:self.view]){
      [FXUser sharedUser].activeFixes --;
      [self refreshDots];
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


///  UIPangesture Delegate

- (void)handlePanRecognizer:(UIPanGestureRecognizer *)sender
{
    UIPanGestureRecognizer *recongizer = (UIPanGestureRecognizer *)sender;
    

    if ([recongizer state] == UIGestureRecognizerStateBegan)
    {
        activeDragView = (FXUserView *)recongizer.view;
        beginRect = activeDragView.frame;
    }
    
    NSArray *views = @[centerBackgroundView];
    
    // Block to execute when our dragged view is contained by one of our evaluation views.
    static void (^overlappingBlock)(UIView *overlappingView);
    overlappingBlock = ^(UIView *overlappingView) {
        
        if(overlappingView == centerBackgroundView)
        {
            [centerFriendButton setHighlighted:YES];
        }else{
               [centerFriendButton setHighlighted:NO];
        }
        
    };
    
    // Block to execute when gesture ends.
    static void (^completionBlock)(UIView *overlappingView);
    completionBlock = ^(UIView *overlappingView) {
             //
        if (overlappingView == centerBackgroundView) {
            [friendImageView setImage:activeDragView.userImageView.image];
             [myPhotoImageView setImage:centerFriendButton.currentBackgroundImage];
            
            [commentTextField setText:@""];
            [checkButton setSelected:NO];
            [fixView setHidden:NO];
            
        }
        
        [centerFriendButton setHighlighted:NO];
        [activeDragView setFrame:beginRect];
        
    };
    
    [recongizer dragViewWithinView:mainFriendsView
           evaluateViewsForOverlap:views
   containedByOverlappingViewBlock:overlappingBlock
                        completion:completionBlock];
}


-(void)handleSwipe:(UISwipeGestureRecognizer *)gesture{
    
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        
    
        if ([[FXUser sharedUser].suggestedFriendList count] -1 > centerPersonIndex) {
            centerPersonIndex ++;
            self.facebookFriendList = [[FXUser sharedUser].suggestedFriendList objectAtIndex:centerPersonIndex];
            [self refreshSuggestFriends];
        }
    }else{
        if (centerPersonIndex != 0) {
            centerPersonIndex --;
            self.facebookFriendList = [[FXUser sharedUser].suggestedFriendList objectAtIndex:centerPersonIndex];
            [self refreshSuggestFriends];
        }
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


// SearchBar Delegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self refreshSearchFriends:searchText];
}


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self refreshSearchFriends:@""];
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self refreshSearchFriends:searchBar.text];
}

-(void)refreshSearchFriends:(NSString *)searchKey{

    NSMutableArray * tempArray = (NSMutableArray *) [FXUser sharedUser].myFriendList;
    
    if ([searchKey isEqualToString:@""]) {
        searchResultArray = tempArray;
    }else{
    
        searchResultArray = [[NSMutableArray alloc] init];
        
        if (tempArray != nil ) {
            for (NSDictionary *tempDic in tempArray) {
                NSString * nameStr = [tempDic objectForKey:@"name"];
                nameStr = [nameStr lowercaseString];
                searchKey = [searchKey lowercaseString];
                
                if (nameStr != nil && [nameStr containsString:searchKey]) {
                    [searchResultArray addObject:tempDic];
                }
            }
        }
    }
    
    [searchResultTableView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"gotoFriendList"]) {
        FXFriendVC * controller = (FXFriendVC *)segue.destinationViewController;
        controller.friendList = [[FXUser sharedUser].suggestedFriendList objectAtIndex:centerPersonIndex];
        
    }
}

@end
