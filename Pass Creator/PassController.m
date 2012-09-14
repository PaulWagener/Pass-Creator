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
#import "Credits.h"
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
    
    genericImage.onImageChanged = ^(UIImage* image) {
        passBackground.image = image == nil ? nil : [image stackBlur:20];
    };
    self.navigationItem.rightBarButtonItems = @[sendButton, previewButton];
    
    [self updateFromPass:self.loadPass];
}

- (void) viewDidAppear:(BOOL)animated {
    self.navigationController.delegate = self;
}

- (IBAction) chooseTransitType:(id)sender {
    [[[UIActionSheet alloc] initWithTitle:@"Transit Type" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Air", @"Train", @"Bus", @"Boat", @"Generic", nil] showInView:passView];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self setTransitType:buttonIndex];
}

/**
 * Set the transit icon on the button between the origin and the destination label
 */
- (void) setTransitType:(enum TransitType)theTransitType {
    self->transitType = theTransitType;
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
    [self setPassType:segmentedPassType.selectedSegmentIndex];
}

/**
 * Update the user interface to the specified passtype
 */
- (void) setPassType:(enum PassType)thePassType {
    self->passType = thePassType;
    
    // Set border image
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

    passBackground.hidden = passType != EVENT;
    sheen.image = passType == EVENT ? [UIImage imageNamed:@"sheen_event.png"] : [UIImage imageNamed:@"sheen.png"];
    
    
    // 
    if(infoContainer.subviews.count > 0)
        [[infoContainer.subviews objectAtIndex:0] removeFromSuperview];
    [infoContainer addSubview:info];
    info.frame = CGRectMake(0, 0, info.frame.size.width, info.frame.size.height);
    info.backgroundColor = [UIColor clearColor];
    
    // Change the title in the navbar
    if(passType == GENERIC)
        self.navigationItem.title = @"Card";
    else if(passType == EVENT)
        self.navigationItem.title = @"Event";
    else if(passType == BOARDING)
        self.navigationItem.title = @"Boarding";
    else if(passType == COUPON)
        self.navigationItem.title = @"Coupon";
    else if(passType == STORE)
        self.navigationItem.title = @"Store Card";

    // Hide the color buttons for event cards, as these always have an image as a background
    [UIView animateWithDuration:0.5 animations:^{
        const bool alpha = passType == EVENT ? 0.0 : 1.0;
        backgroundColor.alpha = alpha;
        labelColor.alpha = alpha;
        valueColor.alpha = alpha;
    }];
    
    
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
    if(passType == GENERIC || passType == EVENT)
        return genericLabel;
    if(passType == BOARDING)
        return boardingOriginLabel;
    if(passType == COUPON || passType == STORE)
        return couponLabel;
    return nil;
}

- (UITextField*) getPrimaryValue1 {
    if(passType == GENERIC || passType == EVENT)
        return genericValue;
    if(passType == BOARDING)
        return boardingOriginValue;
    if(passType == COUPON || passType == STORE)
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
 * Update the user interface with values from a pass
 */
- (void) updateFromPass:(Pass*)pass {
    titleLabel.text = pass.title;
    
    backgroundColor.color = pass.backgroundColor;
    labelColor.color = pass.labelColor;
    valueColor.color = pass.valueColor;
    
    [self setPassType:pass.passType];
    segmentedPassType.selectedSegmentIndex = pass.passType;
    [self setTransitType:pass.transitType];
    [self getPrimaryLabel1].text = pass.primaryLabel1;
    [self getPrimaryValue1].text = pass.primaryValue1;
    [self getPrimaryLabel2].text = pass.primaryLabel2;
    [self getPrimaryValue2].text = pass.primaryValue2;
    secondaryLabel1.text = pass.secondaryLabel1;
    secondaryValue1.text = pass.secondaryValue1;
    secondaryLabel2.text = pass.secondaryLabel2;
    secondaryValue2.text = pass.secondaryValue2;
    secondaryLabel3.text = pass.secondaryLabel3;
    secondaryValue3.text = pass.secondaryValue3;
    secondaryLabel4.text = pass.secondaryLabel4;
    secondaryValue4.text = pass.secondaryValue4;
    
    logoImage.image = pass.logo;
    genericImage.image = pass.thumbnail;
    couponImage.image = pass.strip;
}

/**
 * Create a pass with the values from the user interface
 */
- (Pass*) updateToPass {
    Pass *pass = [[Pass alloc] init];
    pass.title = titleLabel.text;
    pass.primaryLabel1 = [self getPrimaryLabel1].text;
    pass.primaryValue1 = [self getPrimaryValue1].text;
    pass.primaryLabel2 = [self getPrimaryLabel2].text;
    pass.primaryValue2 = [self getPrimaryValue2].text;
    
    pass.secondaryLabel1 = secondaryLabel1.text;
    pass.secondaryValue1 = secondaryValue1.text;
    pass.secondaryLabel2 = secondaryLabel2.text;
    pass.secondaryValue2 = secondaryValue2.text;
    pass.secondaryLabel3 = secondaryLabel3.text;
    pass.secondaryValue3 = secondaryValue3.text;
    pass.secondaryLabel4 = secondaryLabel4.text;
    pass.secondaryValue4 = secondaryValue4.text;
    
    pass.backgroundColor = backgroundColor.color;
    pass.labelColor = labelColor.color;
    pass.valueColor = valueColor.color;
    
    pass.logo = logoImage.image;
    pass.thumbnail = genericImage.image;
    pass.strip = couponImage.image;
    
    pass.passType = passType;
    pass.transitType = transitType;
    return pass;
}

- (void) save {
    Pass *pass = [self updateToPass];
    
    if(self.savePass != nil)
        self.savePass(pass);
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if(viewController != self) {
        [self save];
        self.navigationController.delegate = nil;
    }
}

- (IBAction) preview:(id)sender {
    Pass *pass = [self updateToPass];
    
    NSError *error;
    NSData *passData =  [pass pkpassData];
    PKPass *pkpass = [[PKPass alloc] initWithData:passData error:&error];
    
    UIViewController *passController = [[PKAddPassesViewController alloc] initWithPass:pkpass];
    [self presentViewController:passController animated:YES completion:nil];
}
- (IBAction) send:(id)sender {
    Pass *pass = [self updateToPass];
    NSData *passData =  [pass pkpassData];
    
    if([Credits getCredits] <= 0) {
        [[[UIAlertView alloc] initWithTitle:@"Not enough credits" message:@"You need atleast 1 credit to be able to send this pass by mail. Tap OK to buy credits" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] show];
    } else {
        
        MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
        mailCompose.mailComposeDelegate = self;
        [mailCompose setMessageBody:@"\n\n\n\n" isHTML:NO];
        [mailCompose setSubject:pass.title];
        [mailCompose addAttachmentData:passData mimeType:@"application/vnd.apple.pkpass" fileName:[NSString stringWithFormat:@"%@.pkpass", pass.title]];
        [self presentViewController:mailCompose animated:YES completion:nil];
        
        [[[UIAlertView alloc] initWithTitle:@"Credits" message:[NSString stringWithFormat:@"Sending or saving this mail will cost 1 credit. You currently have %d credit%@",[Credits getCredits],[Credits getCredits] == 1 ? @"" : @"s"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        [self performSegueWithIdentifier:@"credits" sender:self];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if(result != MFMailComposeResultCancelled && result != MFMailComposeResultFailed) {
        [Credits useCredit];
    }
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
