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
        passView.backgroundColor = color;
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
    backgroundColor.color = [UIColor purpleColor];
    labelColor.color = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    valueColor.color = [UIColor blackColor];
    self.pass = [[Pass alloc] init];
    
    segmentedPassType.selectedSegmentIndex = GENERIC;
    [self setPassType:GENERIC];
}

- (IBAction) chooseTransitType:(id)sender {
    [[[UIActionSheet alloc] initWithTitle:@"Transit Type" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Air", @"Train", @"Bus", @"Boat", @"Generic", nil] showInView:passView];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.pass.transitType = buttonIndex;
    [self setTransitType:buttonIndex];
}

/**
 * Set the transit icon on the button between the origin and the destination label
 */
- (void) setTransitType:(enum TransitType)transitType {
    if(transitType == TRANSIT_AIR)
        [transitButton setImage:[UIImage imageNamed:@"transit_plane.png"] forState:UIControlStateNormal];
    else if(transitType == TRANSIT_TRAIN)
        [transitButton setImage:[UIImage imageNamed:@"transit_train.png"] forState:UIControlStateNormal];
    else if(transitType == TRANSIT_BUS)
        [transitButton setImage:[UIImage imageNamed:@"transit_bus.png"] forState:UIControlStateNormal];
    else if(transitType == TRANSIT_BOAT)
        [transitButton setImage:[UIImage imageNamed:@"transit_boat.png"] forState:UIControlStateNormal];
    else if(transitType == TRANSIT_GENERIC)
        [transitButton setImage:[UIImage imageNamed:@"transit_generic.png"] forState:UIControlStateNormal];
}

- (IBAction) passTypeChanged:(id)sender {
    self.pass.passType = segmentedPassType.selectedSegmentIndex;
    [self setPassType:segmentedPassType.selectedSegmentIndex];
}



- (void) setPassType:(enum PassType)passType {
    UIImage *borderImage;
    UIView *info;
    switch (passType) {
        case BOARDING:
            borderImage = [[UIImage imageNamed:@"border_notched.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(72, 32, 32, 32)];
            info = infoTransit;
            break;
            
        case COUPON:
            borderImage = [[UIImage imageNamed:@"border_perforated.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(72, 21, 32, 15)];
            info = infoCoupon;
            break;
            
        case EVENT:
            borderImage = [UIImage imageNamed:@"border_scalloped"];
            info = infoEvent;
            break;
            
        case GENERIC:
        case STORE:
        default:
            borderImage = [[UIImage imageNamed:@"border_plain"] resizableImageWithCapInsets:UIEdgeInsetsMake(72, 32, 32, 32)];
            info = infoGeneric;
            break;
    }
    
    if(passType == STORE)
        info = infoCoupon;
    
    [border setImage:borderImage];

    if(infoContainer.subviews.count > 0)
        [[infoContainer.subviews objectAtIndex:0] removeFromSuperview];
    [infoContainer addSubview:info];
    info.frame = CGRectMake(0, 0, info.frame.size.width, info.frame.size.height);
    info.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:0.5 animations:^{
        eventOptions.alpha = passType == EVENT ? 1.0 : 0.0;
    }];
}

/**
 * These functions return what is in the current primary label & value textfields
 */
- (NSString*) getPrimaryLabel1 {
    if(self.pass.passType == GENERIC || self.pass.passType == EVENT)
        return genericLabel.text;
    if(self.pass.passType == BOARDING)
        return boardingOriginLabel.text;
    if(self.pass.passType == COUPON || self.pass.passType == STORE)
        return couponLabel.text;
    return @"";
}

- (NSString*) getPrimaryValue1 {
    if(self.pass.passType == GENERIC || self.pass.passType == EVENT)
        return genericValue.text;
    if(self.pass.passType == BOARDING)
        return boardingOriginValue.text;
    if(self.pass.passType == COUPON || self.pass.passType == STORE)
        return couponValue.text;
    return @"";
}

- (NSString*) getPrimaryLabel2 {
    return boardingDestinationLabel.text;
}

- (NSString*) getPrimaryValue2 {
    return boardingDestinationValue.text;
}

- (void) updatePass {
    self.pass.title = titleLabel.text;
    self.pass.primaryLabel1 = [self getPrimaryLabel1];
    self.pass.primaryValue1 = [self getPrimaryValue1];
    self.pass.primaryLabel2 = [self getPrimaryLabel2];
    self.pass.primaryValue2 = [self getPrimaryValue2];
    
    self.pass.secondaryLabel1 = secondaryLabel1.text;
    self.pass.secondaryValue1 = secondaryValue1.text;
    self.pass.secondaryLabel2 = secondaryLabel2.text;
    self.pass.secondaryValue2 = secondaryValue2.text;
    self.pass.secondaryLabel3 = secondaryLabel3.text;
    self.pass.secondaryValue3 = secondaryValue3.text;
    self.pass.secondaryLabel4 = secondaryLabel4.text;
    self.pass.secondaryValue4 = secondaryValue4.text;
    
    self.pass.backgroundColor = backgroundColor.color;
    self.pass.labelColor = labelColor.color;
    self.pass.valueColor = valueColor.color;
    
    self.pass.logo = logoImage.image;
    self.pass.thumbnail = genericImage.image;
    self.pass.strip = couponImage.image;
    self.pass.background = backgroundImage.image;
    
    self.pass.passType = segmentedPassType.selectedSegmentIndex;
}

- (IBAction) preview:(id)sender {
    [self updatePass];
    UIViewController *f =  [self.pass previewViewController];
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


@end
