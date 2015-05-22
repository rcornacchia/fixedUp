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
    if (isFixed) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"fixedCell"];
    }else{
       cell = [tableView dequeueReusableCellWithIdentifier:@"suggestedCell"];
    }
    
    UIImageView * userImageView1 = (UIImageView * )[cell viewWithTag:123];
    UIImageView * userImageView2 = (UIImageView * )[cell viewWithTag:124];
    userImageView1.layer.cornerRadius = userImageView1.frame.size.width/2;
    userImageView2.layer.cornerRadius = userImageView2.frame.size.width/2;
    
    UILabel * nameLabel1 = (UILabel * )[cell viewWithTag:125];
    UILabel * nameLabel2 = (UILabel * )[cell viewWithTag:126];
    
    
    
    
    if (!isFixed) {
             UILabel * expireLabel = ( UILabel *)[cell viewWithTag:127];
    }
    
   
    return cell;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isFixed) {
        return 2;
    }
    
    return 8;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
