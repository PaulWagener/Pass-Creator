//
//  ScrollViewContainingDraggable.m
//  Pass Creator
//
//  Created by Paul Wagener on 11-08-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import "ScrollViewContainingDraggable.h"
#import "ColorPickerCircle.h"


@implementation ScrollViewContainingDraggable

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    
    UIView* result = [super hitTest:point withEvent:event];

    if ([result conformsToProtocol:@protocol(Draggable)])
        self.scrollEnabled = NO;
    else
        self.scrollEnabled = YES;

    return result;
}

@end
