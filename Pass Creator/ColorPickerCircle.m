//
//  ColorPickerCircle.m
//  Pass Creator
//
//  Created by Paul Wagener on 11-08-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import "ColorPickerCircle.h"
#import <QuartzCore/QuartzCore.h>

@implementation ColorPickerCircle

- (void) awakeFromNib {
    colorView.layer.cornerRadius = self.frame.size.height / 2;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Began");
}

/**
 * Plaats grip & grafiek constant terwijl de gebruik aan het draggen is
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Moved");
    UITouch *touch = [touches anyObject];
    hueTarget.center = [touch locationInView:self];
}

/**
 * Plaats Grip & Grafiek op een juiste eindpositie na de drag van de gebruiker
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Ended");
}

@end
