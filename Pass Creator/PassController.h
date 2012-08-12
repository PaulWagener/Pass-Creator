//
//  PassController.h
//  Pass Creator
//
//  Created by Paul Wagener on 11-08-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PassController : UIViewController<UITextFieldDelegate, UITextViewDelegate> {
    IBOutlet UIScrollView *scrollview;
    IBOutlet UIView *contentview;
    
    IBOutlet UIImageView *border;
    IBOutlet UIView *pass;
    
    IBOutlet UIView *infoContainer;
    
    IBOutlet UIView *infoEvent;
    IBOutlet UIView *infoTransit;
    IBOutlet UIView *infoGeneric;
    IBOutlet UIView *infoCoupon;
    
}
    
@end
