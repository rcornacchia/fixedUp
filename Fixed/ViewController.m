//
//  ViewController.m
//  Fixed
//
//  Created by wang on 5/11/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    IBOutlet UIImageView * imageView1;
    IBOutlet UIImageView * imageView2;
    IBOutlet UIImageView * imageView3;
    IBOutlet UIImageView * imageView4;
    
    NSArray * imageViewArray;
    int imageIndex;
    
    BOOL isDisappear;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    imageIndex = 0;
    isDisappear = YES;
    imageViewArray = [[NSArray alloc] initWithObjects:imageView1, imageView2, imageView3, imageView4, nil];
    [self startAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)startAnimation{
    
    if (!isDisappear && imageIndex == 4 ) {
        [self performSegueWithIdentifier:@"gotoLogin" sender:nil];
        return;
    }else if(isDisappear && imageIndex == 4 ){
        isDisappear = NO;
        imageIndex = 0;
    }
    
     UIImageView * tempImageView = [imageViewArray objectAtIndex:imageIndex];
   
    float alphaValue = isDisappear?0.0f:1.0f;
    
    
       [ UIView animateWithDuration:0.4 animations:^{
            [tempImageView setAlpha:alphaValue];
        } completion:^(BOOL complete){
            imageIndex ++;
            [self startAnimation];
        }];
    
}

@end
