//
//  BarScannerController.h
//  Pass Creator
//
//  Created by Paul Wagener on 22-09-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface BarScannerController : UIViewController<ZBarReaderViewDelegate, UITextFieldDelegate> {
    IBOutlet ZBarReaderView *readerView;
    IBOutlet UITextField *textfield;
    NSString *bardata;
}
@property (nonatomic, copy) void (^onComplete)(NSString*);

- (void) setData:(NSString*)data;
@end
