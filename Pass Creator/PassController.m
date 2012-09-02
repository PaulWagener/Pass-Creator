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

#import "UIImage+StackBlur.h"
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
    
    if(self.pass == nil)
        self.pass = [[Pass alloc] init];
    
    genericImage.onImageChanged = ^(UIImage* image) {
        passBackground.image = image == nil ? nil : [image stackBlur:20];
    };
    
    // Just testing
    NSData *passData = [[NSUserDefaults standardUserDefaults] objectForKey:@"pass"];
    self.pass = [NSKeyedUnarchiver unarchiveObjectWithData:passData];
    
    [self updateFromPass];
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
    
    // Change the title!
    if(passType == GENERIC)
        self.navigationItem.title = @"Card";
    else if(passType == EVENT)
        self.navigationItem.title = @"Event Ticket";
    else if(passType == BOARDING)
        self.navigationItem.title = @"Boarding Pass";
    else if(passType == COUPON)
        self.navigationItem.title = @"Coupon";
    else if(passType == STORE)
        self.navigationItem.title = @"Store Card";
        
    
    // Do event stuff

    // Hide the buttons!
    [UIView animateWithDuration:0.5 animations:^{
        const bool alpha = passType == EVENT ? 0.0 : 1.0;
        backgroundColor.alpha = alpha;
        labelColor.alpha = alpha;
        valueColor.alpha = alpha;
    }];
    
    // Change the backgrounds!
    passBackground.hidden = passType != EVENT;
    sheen.image = passType == EVENT ? [UIImage imageNamed:@"sheen_event.png"] : [UIImage imageNamed:@"sheen.png"];
    
    // Change the colors!
    if(passType == EVENT) {
        backgroundColor.onColorChange([UIColor colorWithWhite:0.3 alpha:1.0]);
        labelColor.onColorChange([UIColor colorWithWhite:1.0 alpha:1.0]);
        valueColor.onColorChange([UIColor colorWithWhite:0.85 alpha:1.0]);
    } else {
        backgroundColor.onColorChange(backgroundColor.color);
        labelColor.onColorChange(labelColor.color);
        valueColor.onColorChange(valueColor.color);
    }
}

/**
 * These functions return what is in the current primary label & value textfields
 */
- (UITextField*) getPrimaryLabel1 {
    if(self.pass.passType == GENERIC || self.pass.passType == EVENT)
        return genericLabel;
    if(self.pass.passType == BOARDING)
        return boardingOriginLabel;
    if(self.pass.passType == COUPON || self.pass.passType == STORE)
        return couponLabel;
    return nil;
}

- (UITextField*) getPrimaryValue1 {
    if(self.pass.passType == GENERIC || self.pass.passType == EVENT)
        return genericValue;
    if(self.pass.passType == BOARDING)
        return boardingOriginValue;
    if(self.pass.passType == COUPON || self.pass.passType == STORE)
        return couponValue;
    return nil;
}

- (UITextField*) getPrimaryLabel2 {
    return boardingDestinationLabel;
}

- (UITextField*) getPrimaryValue2 {
    return boardingDestinationValue;
}

/**
 * Update the user interface with values from the current pass
 */
- (void) updateFromPass {
    titleLabel.text = self.pass.title;
    
    backgroundColor.color = self.pass.backgroundColor;
    labelColor.color = self.pass.labelColor;
    valueColor.color = self.pass.valueColor;
    
    [self setPassType:self.pass.passType];
    segmentedPassType.selectedSegmentIndex = self.pass.passType;
    [self setTransitType:self.pass.transitType];
    [self getPrimaryLabel1].text = self.pass.primaryLabel1;
    [self getPrimaryValue1].text = self.pass.primaryValue1;
    [self getPrimaryLabel2].text = self.pass.primaryLabel2;
    [self getPrimaryValue2].text = self.pass.primaryValue2;
    secondaryLabel1.text = self.pass.secondaryLabel1;
    secondaryValue1.text = self.pass.secondaryValue1;
    secondaryLabel2.text = self.pass.secondaryLabel2;
    secondaryValue2.text = self.pass.secondaryValue2;
    secondaryLabel3.text = self.pass.secondaryLabel3;
    secondaryValue3.text = self.pass.secondaryValue3;
    secondaryLabel4.text = self.pass.secondaryLabel4;
    secondaryValue4.text = self.pass.secondaryValue4;
    

    
    logoImage.image = self.pass.logo;
    genericImage.image = self.pass.thumbnail;
    couponImage.image = self.pass.strip;
}

- (void) updateToPass {
    self.pass.title = titleLabel.text;
    self.pass.primaryLabel1 = [self getPrimaryLabel1].text;
    self.pass.primaryValue1 = [self getPrimaryValue1].text;
    self.pass.primaryLabel2 = [self getPrimaryLabel2].text;
    self.pass.primaryValue2 = [self getPrimaryValue2].text;
    
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
    
    self.pass.passType = segmentedPassType.selectedSegmentIndex;
}

- (IBAction) save:(id)sender {
    [self updateToPass];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.pass];
    NSLog(@"Pass data saved to %d bytes", data.length);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"pass"];
    [defaults synchronize];
}


- (IBAction) preview:(id)sender {
    [self updateToPass];
    //NSError *error;
    NSData *passData =  [self.pass pkpassData];
    //PKPass *pkpass = [[PKPass alloc] initWithData:passData error:&error];
    
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    mailCompose.mailComposeDelegate = self;
    [mailCompose setMessageBody:@"Ik weet nog wel een leuke nieuwe tag.\n\nNamelijk:" isHTML:NO];
    [mailCompose addAttachmentData:passData mimeType:@"application/vnd.apple.pkpass" fileName:@"pass.pkpass"];
    [self presentModalViewController:mailCompose animated:YES];

    
    //UIViewController *passController = [[PKAddPassesViewController alloc] initWithPass:pkpass];
    //[self presentModalViewController:passController  animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
}

/**
 * Delegate functions for all the textfields
 */
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
