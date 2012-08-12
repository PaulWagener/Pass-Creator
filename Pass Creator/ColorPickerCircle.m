//
//  ColorPickerCircle.m
//  Pass Creator
//
//  Created by Paul Wagener on 11-08-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import "ColorPickerCircle.h"
#import <QuartzCore/QuartzCore.h>
#define MAX_
@implementation ColorPickerCircle

- (void) awakeFromNib {
    colorView.layer.cornerRadius = self.frame.size.height / 2;
    self.exclusiveTouch = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Began");
}

/*
enum {
    HUE,
    BRIGHTNESS
} DragMode;

enum DragMode dragMode;
*/
/**
 * Plaats grip & grafiek constant terwijl de gebruik aan het draggen is
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    //if(dragMode == HUE) {
        
    //}
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    CGPoint vector = touchPoint;
    vector.x -= self.frame.size.width / 2;
    vector.y -= self.frame.size.height / 2;
    CGFloat distance = sqrt(vector.x*vector.x + vector.y*vector.y); // Distance from center
    
    CGFloat wantedDistance = (self.frame.size.width / 2) * 0.77;
    //wantedDistance = MIN(distance, (self.frame.size.width / 2) * 0.60);
    
    vector.x *= wantedDistance / distance;
    vector.y *= wantedDistance / distance;
    
    vector.x += self.frame.size.width / 2;
    vector.y += self.frame.size.height / 2;
    
    hueTarget.center = vector;
}

/**
 * Plaats Grip & Grafiek op een juiste eindpositie na de drag van de gebruiker
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Ended");
}

@end
