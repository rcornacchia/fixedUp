//
//  FXProfileVC.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXProfileVC.h"
#import "UIViewController+JDSideMenu.h"

@interface FXProfileVC ()<UIScrollViewDelegate>
{
  IBOutlet UIImageView * circle1;
  IBOutlet UIImageView * circle2;
  IBOutlet UIImageView * circle3;
  IBOutlet UIImageView * circle4;
  IBOutlet UIImageView * circle5;

  NSArray * circles;
    NSArray * circleIndexs;
 
    NSInteger beforePageIndex;
  IBOutlet UIButton * menuButton;
    IBOutlet UIButton * editButton;
    
    
  IBOutlet UIScrollView * userPhotoScrollView;
    
   NSArray * userPhotoUrls;
    
    IBOutlet UILabel * nameLabel;
    IBOutlet UILabel * taglineLabel;
    IBOutlet UILabel * workLabel;
    IBOutlet UILabel * homeLabel;
    IBOutlet UILabel * schoolLbael;
    IBOutlet UILabel * religionLabel;
    IBOutlet UILabel * interestLabel;
}
@end

@implementation FXProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initProfileView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initProfileView
{
    circles = [[NSArray alloc] initWithObjects:circle1,circle2, circle3, circle4, circle5, nil];
    circleIndexs = @[@"2", @"1", @"3", @"0", @"4"];
    userPhotoUrls = @[@"sample_photo1", @"sample_photo2", @"sample_photo3",@"sample_photo4", @"person6" ];
    
    if (_isMyProfile) {
        [menuButton setImage:[UIImage imageNamed:@"menu_white"] forState:UIControlStateNormal];
        [editButton setHidden:NO];
    }else{
        [menuButton setImage:[UIImage imageNamed:@"nav_back_white"] forState:UIControlStateNormal];
        [editButton setHidden:YES];
    }
   
    CGSize tempSize = userPhotoScrollView.frame.size;
    for (int i = 0 ; i< [circles count]; i++) {
        UIImageView * circleImageView = [circles objectAtIndex:i];
        
        if (i < [userPhotoUrls count]) {
            [circleImageView setHidden:NO];
            UIImage * image = [UIImage imageNamed:[userPhotoUrls objectAtIndex:i]];
            UIImageView * tempView = [[UIImageView alloc] initWithFrame:CGRectMake(tempSize.width * i, 0, tempSize.width, tempSize.height)];
            [tempView setImage:image];
            [userPhotoScrollView addSubview:tempView];
        }else{
            [circleImageView setHidden:YES];
        }
    }
    
    beforePageIndex = 0;
    [self refreshCircles:0];
    
    userPhotoScrollView.pagingEnabled = YES;
    userPhotoScrollView.delegate = self;
    userPhotoScrollView.contentSize = CGSizeMake(tempSize.width * [userPhotoUrls count], tempSize.height);
    

}


-(IBAction)onMenu:(id)sender
{
    if (!_isMyProfile) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if([self.sideMenuController isMenuVisible])
    {
        [self.sideMenuController hideMenuAnimated:YES];
    }else{
        [self.sideMenuController showMenuAnimated:YES];
    }
}

-(void)refreshCircles:(NSInteger )currentIndex
{
    NSInteger i = 0;
    for (UIImageView * circleImageView in circles) {
        int  tempIndex = [[circleIndexs objectAtIndex:i] intValue];
        if (tempIndex == currentIndex) {
            [circleImageView setHighlighted:YES];
        }else{
            [circleImageView setHighlighted:NO];
        }
        i++;
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger pageIndex = (int)(scrollView.contentOffset.x/scrollView.frame.size.width);
    
    if (beforePageIndex != pageIndex) {
        beforePageIndex = pageIndex;
        [self refreshCircles:pageIndex];
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
