//
//  ColorPickerCircle.h
//  Pass Creator
//
//  Created by Paul Wagener on 11-08-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollViewContainingDraggable.h"

@interface ColorPickerCircle : UIView<Draggable> {
    @public
    IBOutlet UIView *hueTarget;
    IBOutlet UIView *brightnessTarget;
    IBOutlet UIView *colorView;
    
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
}

@property (nonatomic, copy) void (^onColorChange)(UIColor*);

- (void) setColor:(UIColor *)color;

@end
