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
    IBOutlet UIView *hueTarget;
    IBOutlet UIView *brightnessTarget;
    IBOutlet UIView *colorView;
}

@end
