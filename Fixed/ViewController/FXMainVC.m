//
//  FXMainVC.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXMainVC.h"
#import "FXFixedVC.h"
#import "FXMatchVC.h"
#import "FXStatisticVC.h"

typedef NS_ENUM(NSInteger, TabItemType) {
    FIXED_ITEM = 0,
    MATCH_ITEM,
    STATISTIC_ITEM
};

@interface FXMainVC ()
{
    // Value
    
    TabItemType activeItem;
    
    // UI
    IBOutlet UIView * bottomView;
    
    UINavigationController * fixedNavVC;
    FXMainVC * matchVC;
    UINavigationController * statisticNavVC;
    
    IBOutlet UIView * fixedView;
    IBOutlet UIView * matchView;
    IBOutlet UIView * statisticView;
}

@end

@implementation FXMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initViews];
    
    activeItem  = FIXED_ITEM;
    [self refreshViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initViews
{
    fixedNavVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FXFixedNavigationController"];
    [self addChildViewController:fixedNavVC];
    [fixedView addSubview:fixedNavVC.view];
    
    matchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FXMatchVC"];
    [self addChildViewController:matchVC];
    [matchView addSubview:matchVC.view];
    
    statisticNavVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FXStatisticNavigationController"];
    [self addChildViewController:statisticNavVC];
    [statisticView addSubview:statisticNavVC.view];

}

-(IBAction)onFixed:(id)sender
{
    activeItem = FIXED_ITEM;
    [self refreshViews];
}


-(IBAction)onMatch:(id)sender
{
    activeItem = MATCH_ITEM;
    [self refreshViews];
}

-(IBAction)onStatistic:(id)sender
{
    activeItem = STATISTIC_ITEM;
    [self refreshViews];
}

-(void)refreshViews
{
    [fixedView setHidden:YES];
    [matchView setHidden:YES];
    [statisticView setHidden:YES];
    
    switch (activeItem) {
        case FIXED_ITEM:
            [fixedView setHidden:NO];
            break;
        case MATCH_ITEM:
            [matchView setHidden:NO];
            break;
       case STATISTIC_ITEM:
            [statisticView setHidden:NO];
            break;
            
        default:
            break;
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
