//
//  FXMatchVC.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXMatchVC.h"
#import "UIViewController+JDSideMenu.h"

@interface FXMatchVC ()<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIButton * suggestedButton;
    IBOutlet UIButton  * fixedButton;
    
    IBOutlet UITableView * matchTableView;
    
    NSArray * suggestionList;
    NSArray * fixedList;
    
    BOOL isFixed;

}
@end

@implementation FXMatchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initMatchView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
   
}

-(void)initMatchView
{
    matchTableView.delegate = self;
    matchTableView.dataSource = self;
    
    matchTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    isFixed = NO;
    suggestedButton.layer.cornerRadius = 10;
    suggestedButton.backgroundColor = FIXED_LIGHT_GREEN_COLOR;
    
    fixedButton.layer.cornerRadius = 10;
    fixedButton.backgroundColor = [UIColor clearColor];
    
    [self onSuggested:nil];
    
   // [self loadingData];
}


-(void)loadingData{
    suggestionList = [[FXUser sharedUser] getSuggestedMatchedByMe:self.view];
    fixedList = [[FXUser sharedUser] getFixedMatchedByMe:self.view];

   [matchTableView reloadData];
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


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    FXMatch * match ;
    if (isFixed) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"fixedCell"];
        match = [fixedList objectAtIndex:indexPath.row];
    }else{
       cell = [tableView dequeueReusableCellWithIdentifier:@"suggestedCell"];
        match = [suggestionList objectAtIndex:indexPath.row];
    }
    

    
    UIImageView * userImageView1 = (UIImageView * )[cell viewWithTag:123];
    UIImageView * userImageView2 = (UIImageView * )[cell viewWithTag:124];
    userImageView1.layer.cornerRadius = userImageView1.frame.size.width/2;
    userImageView2.layer.cornerRadius = userImageView2.frame.size.width/2;
    
    UILabel * nameLabel1 = (UILabel * )[cell viewWithTag:125];
    UILabel * nameLabel2 = (UILabel * )[cell viewWithTag:126];
    
    [userImageView1 setImageWithURL:[FXUser photoPathFromId:match.user1_id]];
    [userImageView2 setImageWithURL:[FXUser photoPathFromId:match.user2_id]];
    
    nameLabel1.text = match.user1_name;
    nameLabel2.text = match.user2_name;
    
    if (!isFixed) {
             UILabel * expireLabel = ( UILabel *)[cell viewWithTag:127];
        NSString * expireStr = @"";
        if (match.expire_day == 1) {
            expireStr = [NSString stringWithFormat:@"EXPIRES IN\n %i DAY", match.expire_day];
        }else{
            expireStr = [NSString stringWithFormat:@"EXPIRES IN\n %i DAYS", match.expire_day];
        }
        expireLabel.text = expireStr;
    }
    
   
    return cell;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isFixed) {
        if (fixedList == nil) {
            return 0;
        }
        
        return [fixedList count];
    }
    
    if(suggestionList == nil){
        return 0;
    }

    return [suggestionList count];
}


// Actions

-(IBAction)onSuggested:(id)sender
{
    if (isFixed) {
        isFixed = NO;
        suggestedButton.backgroundColor = FIXED_LIGHT_GREEN_COLOR;
        fixedButton.backgroundColor = [UIColor clearColor];
        [matchTableView reloadData];
    }
}


-(IBAction)onFixed:(id)sender
{
    if (!isFixed) {
        isFixed = YES;
        suggestedButton.backgroundColor = [UIColor clearColor];
        fixedButton.backgroundColor = FIXED_LIGHT_GREEN_COLOR;
        [matchTableView reloadData];
    }
}


@end
