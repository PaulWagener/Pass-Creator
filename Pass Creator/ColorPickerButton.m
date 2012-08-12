//
//  ColorPicker.m
//  Pass Creator
//
//  Created by Paul Wagener on 11-08-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import "ColorPickerButton.h"
#import <QuartzCore/QuartzCore.h>
@implementation ColorPickerButton


- (void) awakeFromNib {
    
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.backgroundColor = [UIColor redColor];
    self.layer.borderColor = [UIColor brownColor].CGColor;
    self.layer.borderWidth = 0.5f;
    self.layer.cornerRadius = 10.0f;
    
    [self addTarget:self action:@selector(onTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSBundle mainBundle] loadNibNamed:@"ColorPickerCircle" owner:self options:nil];
     //*/
}

- (void) onTouchUp:(id)sender {
    
    [self.superview addSubview:circle];
    circle.center = CGPointMake(self.center.x, self.frame.origin.y - circle.frame.size.height / 2);
}

@end
