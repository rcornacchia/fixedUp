//
//  FXUserView.m
//  Fixed
//
//  Created by guangxian on 5/20/15.
//  Copyright (c) 2015 Lee. All rights reserved.
//

#import "FXUserView.h"
#import "FXProfileVC.h"

@implementation FXUserView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    UIPanGestureRecognizer  *panGesturer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self addGestureRecognizer:panGesturer];
}

-(void)updateUserImage:(UIImage *)image
{
        [self.userImageView setImage:image];
}

-(void)updateUserImageWithURL:(NSString *)imageUrl
{
    NSURL * url = [NSURL URLWithString:imageUrl];
    if (url) {
        [self.userImageView setImageURL:url];
    }else{
        [self.userImageView setImage:nil];
    }
}


-(IBAction)onDetailClick:(id)sender
{
    FXProfileVC * controller = [APP.activeContainer.storyboard instantiateViewControllerWithIdentifier:@"FXProfileVC"];
    [APP.activeContainer pushViewController:controller animated:YES];
}


-(void)panView:(UIPanGestureRecognizer *)gesturer
{
    CGPoint point = [gesturer locationInView:self];
    float  rotationRadian;
    if(gesturer.state == UIGestureRecognizerStateBegan)
    {
        startPoint = point;
        beforePoint = point;
        return;
    }else if(gesturer.state == UIGestureRecognizerStateEnded)
    {
       //  rotationRadian = [self pointPairToBearingRadian:point secondPoint:startPoint];
    }else{
       rotationRadian = [self pointPairToBearingRadian:beforePoint secondPoint:point];
        
    }
    
    self.transform = CGAffineTransformMakeRotation(rotationRadian);
}

- (CGFloat) pointPairToBearingRadian:(CGPoint)startingPoint secondPoint:(CGPoint) endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
//    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
//    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingRadians;
}

@end
