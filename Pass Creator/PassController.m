//
//  PassController.m
//  Pass Creator
//
//  Created by Paul Wagener on 11-08-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import "Pass.h"
#import "PassController.h"
#import <QuartzCore/QuartzCore.h>
#import <PassKit/PassKit.h>
@interface PassController ()

@end

@implementation PassController

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollview.frame = CGRectMake(0, 0, 320, 460);
    scrollview.contentSize = CGSizeMake(contentview.frame.size.width, contentview.frame.size.height);
    [scrollview setContentOffset:CGPointMake(0, 0) animated:YES];

    // Initialize the color picker buttons
    PassController *_self = self;
    backgroundColor.onColorChange = ^(UIColor *color) {
        pass.backgroundColor = color;
    };
    labelColor.onColorChange = ^(UIColor *color){
        for(UITextField *label in _self->labels)
            label.textColor = color;
    };
    valueColor.onColorChange = ^(UIColor *color) {
        for(UITextField *value in _self->values)
            value.textColor = color;
    };
    
    // Just testing
    backgroundColor.color = [UIColor redColor];
    labelColor.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    valueColor.color = [UIColor blueColor];
}

- (IBAction) passTypeChanged:(id)sender {
    [self setPassType:segmentedPassType.selectedSegmentIndex];
}



- (void) setPassType:(enum PassType)passType {
    UIImage *borderImage;
    UIView *info;
    switch (passType) {
        case BOARDING:
        {
            //UIEdgeInsets notchedinsets = UIEdgeInsetsMake(72, 32, 32, 32);
            borderImage = [[UIImage imageNamed:@"border_notched.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(72, 32, 32, 32)];
            info = infoTransit;
            break;
        }
            
        case COUPON:
            borderImage = [[UIImage imageNamed:@"border_perforated.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(72, 21, 32, 15)];
            info = infoCoupon;
            break;
            
        case EVENT:
            borderImage = [UIImage imageNamed:@"border_scalloped"];
            info = infoEvent;
            break;
            
        case GENERIC:
        default:
            borderImage = [[UIImage imageNamed:@"border_plain"] resizableImageWithCapInsets:UIEdgeInsetsMake(32, 32, 32, 32)];
            info = infoGeneric;
            break;
    }
    
    [border setImage:borderImage];

    if(infoContainer.subviews.count > 0)
        [[infoContainer.subviews objectAtIndex:0] removeFromSuperview];
    [infoContainer addSubview:info];
    info.frame = CGRectMake(0, 0, info.frame.size.width, info.frame.size.height);
    info.backgroundColor = [UIColor clearColor];
}

- (IBAction) preview:(id)sender {
    Pass *pass2 = [[Pass alloc] init];
    UIViewController *f =  [pass2 previewViewController];
    [self presentModalViewController:f animated:YES];
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
