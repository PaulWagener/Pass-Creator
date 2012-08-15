//
//  ColorPickerCircle.h
//  Pass Creator
//
//  Created by Paul Wagener on 11-08-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollViewContainingDraggable.h"

#define MAX_BRIGHTNESS_DISTANCE 0.60
#define CENTER_HUE_DISTANCE 0.77
#define PI 3.14159
#define TWICE_PI (PI * 2)

@interface ColorPickerCircle : UIView<Draggable> {
    @public
    IBOutlet UIView *hueTarget;
    IBOutlet UIView *brightnessTarget;
    IBOutlet UIView *colorView;
    
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    
    enum DragMode {
        HUE,
        BRIGHTNESS,
    };
    enum DragMode dragMode;
}

@property (nonatomic, copy) void (^onColorChange)(UIColor*);

- (void) setColor:(UIColor *)color;

@end
