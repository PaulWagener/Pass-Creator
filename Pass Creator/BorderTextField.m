//
//  BorderTextField.m
//  Pass Creator
//
//  Created by Paul Wagener on 12-08-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import "BorderTextField.h"
#import <QuartzCore/QuartzCore.h>

@implementation BorderTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) awakeFromNib {
    self.borderStyle = UITextBorderStyleNone;
    self.layer.borderColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.05].CGColor;
    self.layer.borderWidth = 1.0f;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
