//
//  PassController.m
//  Pass Creator
//
//  Created by Paul Wagener on 11-08-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import "PassController.h"
#import <QuartzCore/QuartzCore.h>
@interface PassController ()

@end

@implementation PassController

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollview.frame = CGRectMake(0, 0, 320, 460);
    scrollview.contentSize = CGSizeMake(contentview.frame.size.width, contentview.frame.size.height);
    [scrollview setContentOffset:CGPointMake(0, 0) animated:YES];

    UIEdgeInsets insets = UIEdgeInsetsMake(72, 32, 32, 32);
    UIImage *image = [[UIImage imageNamed:@"border_notched.png"] resizableImageWithCapInsets:insets];
    
    //UIEdgeInsets insets = UIEdgeInsetsMake(32, 21, 32, 15);
    //UIImage *image = [[UIImage imageNamed:@"border_perforated.png"] resizableImageWithCapInsets:insets];
    
    //UIImage *image = [UIImage imageNamed:@"border_scalloped.png"];
    
    //UIImage *image = [UIImage imageNamed:@"border_square.png"];
    
    
    [border setImage:image];
    
    UIView *info = infoGeneric;
    [infoContainer addSubview:info];
    info.frame = CGRectMake(0, 0, info.frame.size.width, info.frame.size.height);
    info.backgroundColor = [UIColor clearColor];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect rc = [textField convertRect:textField.bounds toView:scrollview];
    [scrollview setContentOffset:CGPointMake(0, rc.origin.y - 160) animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [scrollview setContentOffset:CGPointMake(0, -self.navigationController.navigationBar.frame.size.height) animated:YES];
    return YES;
}

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text rangeOfString:@"\n"].location != NSNotFound) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


@end
