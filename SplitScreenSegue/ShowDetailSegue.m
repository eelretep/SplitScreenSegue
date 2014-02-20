//
//  ShowDetailSegue.m
//  SplitScreenSegue
//
//  Created by Peter Lee on 2/19/14.
//  Copyright (c) 2014 Peter Lee. All rights reserved.
//

#import "ShowDetailSegue.h"
#import "DetailViewController.h"

@implementation ShowDetailSegue

- (BOOL)isReverse
{
    BOOL isReverse = [[self sourceViewController] isKindOfClass:[DetailViewController class]];
    return isReverse;
}

- (void)perform
{
    UIViewController *sourceController = [self sourceViewController];
    UIView *sourceView = [sourceController view];
    UIViewController *destinationController = [self destinationViewController];
    UIView *destinationView = [destinationController view];
    UINavigationController *navigationController = [sourceController navigationController];
    
    BOOL reverseAnimation = [self isReverse];
    
    // snapshot
    UIImage *snapshotImage = nil;
    UIGraphicsBeginImageContextWithOptions([sourceView bounds].size, YES, 0);
    if (reverseAnimation == NO) {
        [destinationView drawViewHierarchyInRect:[sourceView bounds] afterScreenUpdates:YES];
    } else {
        [sourceView drawViewHierarchyInRect:[sourceView bounds] afterScreenUpdates:NO];
    }
    snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // split image
    CGSize imageSizeInPixels = [snapshotImage size];
    imageSizeInPixels.width *= [snapshotImage scale];
    imageSizeInPixels.height *= [snapshotImage scale];
    
    CGImageRef tempImageRef = [snapshotImage CGImage];

    CGImageRef topImageRef = CGImageCreateWithImageInRect(tempImageRef, CGRectMake(0, 0, imageSizeInPixels.width, imageSizeInPixels.height / 2.0));
    UIImage *topImage = [UIImage imageWithCGImage:topImageRef scale:[snapshotImage scale] orientation:UIImageOrientationUp];
    
    CGImageRef bottomImageRef = CGImageCreateWithImageInRect(tempImageRef, CGRectMake(0, imageSizeInPixels.height / 2.0,  imageSizeInPixels.width, imageSizeInPixels.height / 2.0));
    UIImage *bottomImage = [UIImage imageWithCGImage:bottomImageRef scale:[snapshotImage scale] orientation:UIImageOrientationUp];
    
    // setup animation
    UIImageView *imageViewTop = [[UIImageView alloc] initWithImage:topImage];
    UIImageView *imageViewBottom = [[UIImageView alloc] initWithImage:bottomImage];
    
    CGRect startFrameTop = [imageViewTop frame];
    CGRect endFrameTop = startFrameTop;
    CGRect startFrameBottom = [imageViewBottom frame];
    CGRect endFrameBottom = startFrameBottom;

    if (reverseAnimation == NO) {
        startFrameTop.origin.y = -startFrameTop.size.height;
        endFrameTop.origin.y = 0;
        endFrameBottom.origin.y = CGRectGetMaxY(endFrameTop);
        startFrameBottom.origin.y += CGRectGetMaxY(endFrameBottom);
    } else {
        startFrameTop.origin.y = 0;
        endFrameTop.origin.y = -startFrameTop.size.height;
        startFrameBottom.origin.y = CGRectGetMaxY(startFrameTop);
        endFrameBottom.origin.y = CGRectGetMaxY(startFrameBottom);
    }

    [imageViewTop setFrame:startFrameTop];
    [imageViewBottom setFrame:startFrameBottom];
    
    // add the animation views
    if (reverseAnimation == NO) {
        [sourceView addSubview:imageViewTop];
        [sourceView addSubview:imageViewBottom];
    } else {
        [destinationView addSubview:imageViewTop];
        [destinationView addSubview:imageViewBottom];
    }
    
    // animate
    if (reverseAnimation == NO) {
        [UIView animateWithDuration:0.7 animations:^{
            [imageViewTop setFrame:endFrameTop];
            [imageViewBottom setFrame:endFrameBottom];
            
        } completion:^(BOOL finished) {
            [imageViewTop removeFromSuperview];
            [imageViewBottom removeFromSuperview];

            [navigationController pushViewController:destinationController animated:NO];
        }];
        
    } else {
        [[navigationController view] addSubview:destinationView]; // add temporarily to animate
        [UIView animateWithDuration:0.7 animations:^{

            [imageViewTop setFrame:endFrameTop];
            [imageViewBottom setFrame:endFrameBottom];
            
        } completion:^(BOOL finished) {
            [imageViewTop removeFromSuperview];
            [imageViewBottom removeFromSuperview];
        
            [destinationView removeFromSuperview];
            [navigationController popViewControllerAnimated:NO];
        }];
    }
}

@end
