//
//  ImagePickerImage.m
//  Pass Creator
//
//  Created by Paul Wagener on 14-08-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import "ImagePickerButton.h"
#import <UIKit/UIKit.h>
@implementation ImagePickerButton

/**
 * Resize image
 */
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*) image {
    return _image;
}

- (void) setImage:(UIImage *)image {
    _image = image;
    [self setImage:image forState:UIControlStateNormal];
    
    if(self.onImageChanged != nil)
        self.onImageChanged(image);
}

- (void) awakeFromNib {
    [self addTarget:self action:@selector(onTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    if(self.aspectFill)
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    else
        [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
}

- (void) onTouchUp:(id)sender {
    UIImagePickerController *p = [[UIImagePickerController alloc] init];
    p.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    p.delegate = self;

    [self.viewController presentModalViewController:p animated:YES];
}

/**
 * Add option to clear image
 */
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(self.image != nil) {
        UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleBordered target:self action:@selector(clear:)];
        clearButton.tintColor = [UIColor redColor];
        
        viewController.navigationItem.leftBarButtonItem = clearButton;
    }
}

- (void) clear:(id)sender {
    self.image = nil;
    

    
    [self.viewController dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if(image == nil)
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CGSize newSize = image.size;
    if(self.maxHeight > 0 && newSize.height > self.maxHeight) {
        newSize.width *= self.maxHeight / newSize.height;
        newSize.height = self.maxHeight;
    }
    
    if(self.maxWidth > 0 && newSize.width > self.maxWidth) {
        newSize.height *= self.maxWidth / newSize.width;
        newSize.width = self.maxWidth;
    }
    
    self.image = [ImagePickerButton imageWithImage:image scaledToSize:newSize];
    
    [self.viewController dismissModalViewControllerAnimated:YES];
}
@end
