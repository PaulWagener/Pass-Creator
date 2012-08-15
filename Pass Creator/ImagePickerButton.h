//
//  ImagePickerImage.h
//  Pass Creator
//
//  Created by Paul Wagener on 14-08-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePickerButton : UIButton<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIImage *_image;
}


@property IBOutlet UIViewController *viewController;
@property UIImage *image;
@property CGFloat maxHeight;
@property CGFloat maxWidth;
@property bool aspectFill;
@property (nonatomic, copy) void (^onImageChanged)(UIImage*);
@end
