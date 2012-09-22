//
//  LaunchImageController.m
//  Pass Creator
//
//  Created by Paul Wagener on 22-09-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import "LaunchImageController.h"

@interface LaunchImageController ()

@end

@implementation LaunchImageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([UIScreen mainScreen].bounds.size.height == 480)
        launchImage.image = [UIImage imageNamed:@"Default.png"];
}

- (void) viewDidAppear:(BOOL)animated {
    [UIView animateWithDuration:0.3 animations:^{
        launchImage.alpha = 0.0;
    } completion:^(BOOL g){
        [self performSegueWithIdentifier:@"next" sender:self];
    }];
}

@end
