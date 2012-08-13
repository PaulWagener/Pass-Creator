//
//  ColorPicker.h
//  Pass Creator
//
//  Created by Paul Wagener on 11-08-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPickerCircle.h"

@class ColorPickerBackgroundView;

@interface ColorPickerButton : UIButton {
    bool colorPickin;
    UIColor *_color;
}

@property (nonatomic, copy) void (^onColorChange)(UIColor*);

@property IBOutlet ColorPickerCircle *circle;
@property ColorPickerBackgroundView *background;
@property UIColor *color;

@end

/**
 * A large semi-transparant view obscuring the background from reaching any touches events
 * As soon as it's touched the color picker circle should be dismissed
 */
@interface ColorPickerBackgroundView : UIView<Draggable>;

@property ColorPickerButton *button;

@end
