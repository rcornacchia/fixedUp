//
//  FXProfileVC.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXProfileVC.h"
#import "UIViewController+JDSideMenu.h"
#import "FXEditProfileVC.h"

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
    NSInteger baseIndex;
    
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
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
      [self initProfileView];
}

-(void)initProfileView
{
    circles = [[NSArray alloc] initWithObjects:circle1,circle2, circle3, circle4, circle5, nil];
    circleIndexs = @[@"2", @"1", @"0", @"2", @"4"];
    
    if (_isMyProfile) {
        [menuButton setImage:[UIImage imageNamed:@"menu_white"] forState:UIControlStateNormal];
        [editButton setHidden:NO];
        
        self.profile = [[FXUser sharedUser] convertUser2Profile];
    }else{
        [menuButton setImage:[UIImage imageNamed:@"nav_back_white"] forState:UIControlStateNormal];
        [editButton setHidden:YES];
        
    }
   
    userPhotoUrls = self.profile.photo_paths;
    
    CGSize tempSize = userPhotoScrollView.frame.size;
    NSString * imagePath;
    for (int i = 0 ; i< [circles count]; i++) {
        UIImageView * circleImageView = [circles objectAtIndex:i];
        
        if (i < [userPhotoUrls count]) {
            [circleImageView setHidden:NO];
            
            imagePath = [userPhotoUrls objectAtIndex:i];
     
            UIImageView * tempView = [[UIImageView alloc] initWithFrame:CGRectMake(tempSize.width * i, 0, tempSize.width, tempSize.height)];
            [tempView setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", APP_RESOURCE_PATH, imagePath]]];
            [userPhotoScrollView addSubview:tempView];
        }else{
            [circleImageView setHidden:YES];
        }
    }
   

    if (userPhotoUrls != nil) {
        
        if ([userPhotoUrls count] == 1 ) {
            baseIndex = 2;
        }else if([userPhotoUrls count] <= 3){
            baseIndex = 1;
        }else{
            baseIndex = 0;
        }
    }
    
    beforePageIndex = 0;
    [self refreshCircles:0];
    
    userPhotoScrollView.pagingEnabled = YES;
    userPhotoScrollView.delegate = self;
    userPhotoScrollView.contentSize = CGSizeMake(tempSize.width * [userPhotoUrls count], tempSize.height);
    
    
    nameLabel.text = [NSString stringWithFormat:@"%@,%ld - %@,%@",self.profile.name, self.profile.age, self.profile.city, self.profile.state];
    taglineLabel.text = self.profile.tageline;
    workLabel.text =  self.profile.workplace;
    homeLabel.text = self.profile.street;
    schoolLbael.text = self.profile.schools;
    religionLabel.text = [FXUser religionFromIndex: self.profile.religion];
    
    interestLabel.text = self.profile.interest;

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
    currentIndex =  currentIndex + baseIndex;
    
    int  tempIndex = [[circleIndexs objectAtIndex:currentIndex] intValue];
    NSInteger i = 0;
    
    for (UIImageView * circleImageView in circles) {
         if (i == tempIndex) {
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
    [self refreshCircles:pageIndex];
   
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"gotoProfileEdit"]) {
        FXEditProfileVC * controller = (FXEditProfileVC *)segue.destinationViewController;
        controller.user = [FXUser sharedUser];
    }
}


@end
