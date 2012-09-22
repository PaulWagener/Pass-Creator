//
//  BorderTextField.m
//  Pass Creator
//
//  Created by Paul Wagener on 12-08-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import "BorderTextField.h"
#import <QuartzCore/QuartzCore.h>

@implementation BorderTextField

- (void) awakeFromNib {
    self.borderStyle = UITextBorderStyleNone;
    self.layer.borderColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.25].CGColor;
    self.layer.borderWidth = 1.0f;
}

@end
