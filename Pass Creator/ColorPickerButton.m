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
    self.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:1.0].CGColor;
    self.layer.borderWidth = 0.5f;
    self.layer.cornerRadius = 10.0f;
    
    [self addTarget:self action:@selector(onTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSBundle mainBundle] loadNibNamed:@"ColorPickerCircle" owner:self options:nil];
    
    ColorPickerButton *_self = self;
    self.circle.onColorChange = ^(UIColor* color) {
        
        // Show the color to the user as the background of the button
        self.backgroundColor = color;
        _self->_color = color;
        
        // Set the color of the button to white or black depending on the brightness
        CGFloat brightness, dummy;
        [color getHue:&dummy saturation:&dummy brightness:&brightness alpha:&dummy];
        
        if(brightness > 0.3)
            [_self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        else
            [_self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        // Notify listener of the color change
        if(self.onColorChange)
            self.onColorChange(color);
    };
    
    // Semi transparant background view that will dismiss when touched
    self.background = [[ColorPickerBackgroundView alloc] initWithFrame:self.superview.frame];
    self.background.button = self;
    self.background.exclusiveTouch = YES;
}

- (UIColor*) color {
    return _color;
}

- (void) setColor:(UIColor *)color {
    _color = color;
    self.backgroundColor = color;
    [self.circle setColor:color];
}

const CGFloat SIZE = 200;
- (void) onTouchUp:(id)sender {
    if(colorPickin) {
        [self dismiss];
        colorPickin = NO;
    } else {
        self.background.backgroundColor = [UIColor clearColor];
        
        [self.superview addSubview:self.background];
        [self.superview addSubview:self.circle];
        [self.superview addSubview:self];
        
        // Start out small just above the button with hidden targets
        self.circle.frame = CGRectMake(self.center.x, self.frame.origin.y, 1, 1);
        self.circle->hueTarget.alpha = 0;
        self.circle->brightnessTarget.alpha = 0;
        
        [UIView animateWithDuration:0.4 animations:^ {
            
            // ... And expand to full size
            CGFloat x = self.center.x - SIZE / 2;
            x -= MIN(x, 0);
            x -= MAX(x + SIZE - self.superview.frame.size.width, 0);
            
            self.circle.frame = CGRectMake(x, self.frame.origin.y - SIZE, SIZE, SIZE);
            self.background.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.circle->hueTarget.alpha = 1.0;
                self.circle->brightnessTarget.alpha = 1.0;
            }];
            
        }];
        colorPickin = YES;
    }
}

/**
 * Animate away the circle and background
 */
- (void) dismiss {
    [UIView animateWithDuration:0.4 animations:^{
        self.circle.frame = CGRectMake(self.center.x, self.frame.origin.y, 1, 1);
        self.circle->hueTarget.alpha = 0.0;
        self.circle->brightnessTarget.alpha = 0.0;
        self.background.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
    } completion:^(BOOL finished){
        [self.background removeFromSuperview];
        [self.circle removeFromSuperview];
    }];
    colorPickin = NO;
}

@end

@implementation ColorPickerBackgroundView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Dismiss the color picker
    [self.button dismiss];
}

@end
