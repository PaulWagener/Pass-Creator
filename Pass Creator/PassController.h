//
//  PassController.h
//  Pass Creator
//
//  Created by Paul Wagener on 11-08-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerButton.h"
#import "Pass.h"

@interface PassController : UIViewController<UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate> {
    IBOutlet UIScrollView *scrollview;
    IBOutlet UIView *contentview;
    
    IBOutlet UIImageView *border;
    IBOutlet UIView *passView;
    
    IBOutlet UIView *infoContainer;
    
    IBOutlet UIView *infoEvent;
    IBOutlet UIView *infoTransit;
    IBOutlet UIView *infoGeneric;
    IBOutlet UIView *infoCoupon;
    
    IBOutlet ColorPickerButton *backgroundColor;
    IBOutlet ColorPickerButton *labelColor;
    IBOutlet ColorPickerButton *valueColor;
    
    IBOutlet UITextField *titleLabel;
    IBOutlet UITextField *primaryLabel1;
    IBOutlet UITextField *primaryValue1;
    IBOutlet UITextField *primaryLabel2;
    IBOutlet UITextField *primaryValue2;
    IBOutlet UITextField *secondaryLabel1;
    IBOutlet UITextField *secondaryValue1;
    IBOutlet UITextField *secondaryLabel2;
    IBOutlet UITextField *secondaryValue2;
    IBOutlet UITextField *secondaryLabel3;
    IBOutlet UITextField *secondaryValue3;
    IBOutlet UITextField *secondaryLabel4;
    IBOutlet UITextField *secondaryValue4;
    
    // Specific controls
    IBOutlet UITextField *genericLabel;
    IBOutlet UITextField *genericValue;
    
    IBOutlet UITextField *boardingOriginLabel;
    IBOutlet UITextField *boardingOriginValue;
    IBOutlet UITextField *boardingDestinationLabel;
    IBOutlet UITextField *boardingDestinationValue;
    
    IBOutlet UITextField *couponLabel;
    IBOutlet UITextField *couponValue;
    
    
    IBOutlet UIButton *transitButton;
    
    IBOutlet UISegmentedControl *segmentedPassType;
    
    IBOutletCollection(UITextField) NSArray *labels;
    IBOutletCollection(UITextField) NSArray *values;
}

@property Pass *pass;
    
@end
