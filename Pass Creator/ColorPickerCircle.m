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
    // Make the background color view, which gives the brightness / saturation its color, a perfect circle
    colorView.layer.cornerRadius = self.frame.size.height / 2;
    self.exclusiveTouch = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint vector = touchPoint;
    vector.x -= self.frame.size.width / 2;
    vector.y -= self.frame.size.height / 2;
    CGFloat distance = sqrt(vector.x*vector.x + vector.y*vector.y);
    
    if(distance > (self.frame.size.width / 2) * 0.7)
        dragMode = HUE;
    else
        dragMode = BRIGHTNESS;
    
    [self touchAtPoint:touchPoint];
}

/**
 * Plaats grip & grafiek constant terwijl de gebruik aan het draggen is
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    [self touchAtPoint:touchPoint];
}

- (void) touchAtPoint:(CGPoint)touchPoint {
    CGPoint vector = touchPoint;
    vector.x -= self.frame.size.width / 2;
    vector.y -= self.frame.size.height / 2;
    CGFloat distance = sqrt(vector.x*vector.x + vector.y*vector.y); // Distance from center
    
    CGFloat wantedDistance = 0.0;
    if(dragMode == HUE) {
        wantedDistance = (self.frame.size.width / 2) * CENTER_HUE_DISTANCE;
    } else if(dragMode == BRIGHTNESS) {
        wantedDistance = MIN(distance, (self.frame.size.width / 2) * MAX_BRIGHTNESS_DISTANCE);
    }
    
    vector.x *= wantedDistance / distance;
    vector.y *= wantedDistance / distance;
    
    CGPoint centerPoint = vector;
    centerPoint.x += self.frame.size.width / 2;
    centerPoint.y += self.frame.size.height / 2;
    
    
    if(dragMode == HUE) {
        hueTarget.center = centerPoint;
        hue = 1.0 - (atan2(vector.y, vector.x) / TWICE_PI + 0.5);
        colorView.backgroundColor = [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
        
    } else if (dragMode == BRIGHTNESS) {
        brightnessTarget.center = centerPoint;
        
        
        vector.x /= (self.frame.size.width / 2) * MAX_BRIGHTNESS_DISTANCE;
        vector.y /= (self.frame.size.width / 2) * MAX_BRIGHTNESS_DISTANCE;
        
        CGFloat maxComponent = MAX(fabs(vector.x), fabs(vector.y));
        distance = sqrt(vector.x*vector.x + vector.y*vector.y);
        vector.x /= maxComponent;
        vector.y /= maxComponent;
        vector.x *= distance;
        vector.y *= distance;
        brightness = 1.0 - (vector.y / 2 + 0.5);
        saturation = 1.0 - (vector.x / 2 + 0.5);
    }
    
    /**
     * Color change callback
     */
    if(self.onColorChange) {
        self.onColorChange([UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0]);
    }
}

- (void) setColor:(UIColor *)color {
    CGFloat alpha;
    [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    CGPoint vector;
    
    // Set hue target
    vector.x = cos((1.0 - hue) * TWICE_PI - PI) * (self.frame.size.width / 2) * CENTER_HUE_DISTANCE;
    vector.y = sin((1.0 - hue) * TWICE_PI - PI) * (self.frame.size.width / 2) * CENTER_HUE_DISTANCE;
    
    vector.x += (self.frame.size.width / 2);
    vector.y += (self.frame.size.width / 2);
    hueTarget.center = vector;
    
    // Set brightness target
    vector.x = (1.0 - saturation * 2) * (self.frame.size.width / 2) * MAX_BRIGHTNESS_DISTANCE;
    vector.y = (1.0 - brightness * 2) * (self.frame.size.width / 2) * MAX_BRIGHTNESS_DISTANCE;

    CGFloat distance = sqrt(vector.x*vector.x + vector.y*vector.y);
    vector.x *= (self.frame.size.width / 2) * MAX_BRIGHTNESS_DISTANCE / distance;
    vector.y *= (self.frame.size.width / 2) * MAX_BRIGHTNESS_DISTANCE / distance;
    
    vector.x += (self.frame.size.width / 2);
    vector.y += (self.frame.size.width / 2);
    brightnessTarget.center = vector;
    
    // Set background color
    colorView.backgroundColor = [UIColor colorWithHue:hue saturation:1.0 brightness:1.0 alpha:1.0];
    
    if(self.onColorChange)
        self.onColorChange(color);
}

@end
