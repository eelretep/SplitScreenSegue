//
//  MasterViewController.m
//  SplitScreenSegue
//
//  Created by Peter Lee on 2/19/14.
//  Copyright (c) 2014 Peter Lee. All rights reserved.
//

#import "MasterViewController.h"

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"portfolio.png"]];
    [[self tableView] setBackgroundView:backgroundView];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
