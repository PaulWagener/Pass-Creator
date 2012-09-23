//
//  BarScannerController.m
//  Pass Creator
//
//  Created by Paul Wagener on 22-09-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import "BarScannerController.h"
#import "ZBarSDK.h"

@implementation BarScannerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // This does nothing, but it does force the linker to link in the ZBarReaderView.
    // Can be removed if we call
    [ZBarReaderView class];

    readerView.readerDelegate = self;
    
    textfield.text = bardata;
}

- (void) setData:(NSString*)data {
    bardata = data;
}

- (void) viewDidAppear:(BOOL)animated {
    [readerView start];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void) readerView:(ZBarReaderView*)readerView didReadSymbols:(ZBarSymbolSet*)symbols fromImage:(UIImage*)image {
    
    for(ZBarSymbol *symbol in symbols) {
        textfield.text = symbol.data;
        break;
    }
    
    
    [self performSelector:@selector(done:) withObject:self afterDelay:0.5];
}

- (IBAction) done: (id)sender {
    [readerView stop];
    
    if(self.onComplete != nil)
        self.onComplete(textfield.text);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
