//
//  ViewController.m
//  Pass Creator
//
//  Created by Paul Wagener on 16-06-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import "ViewController.h"
#import <PassKit/PassKit.h>
#import "ZKDataArchive.h"
#import <CommonCrypto/CommonCrypto.h>
#import <Security/Security.h>
#include "openssl_test.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self click:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void) addToArchive:(ZKDataArchive*)archive :(NSString*)filename{
    NSString *url = [NSString stringWithFormat:@"http://192.168.0.107/pass/Starbucks/%@",filename];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    [archive deflateData:data withFilename:filename andAttributes:nil];
}

- (IBAction) click:(id)sender {
    ZKDataArchive *archive = [[ZKDataArchive alloc] init];
    
    [self addToArchive:archive :@"icon.png"];
    [self addToArchive:archive :@"icon@2x.png"];
    [self addToArchive:archive :@"logo.png"];
    [self addToArchive:archive :@"logo@2x.png"];
    [self addToArchive:archive :@"manifest.json"];
    [self addToArchive:archive :@"pass.json"];
    //[self addToArchive:archive :@"signature"];
    
#if 1
    const char *key_pem = [[NSBundle mainBundle] pathForResource:@"key" ofType:@"pem"].UTF8String;
    const char *certificate_pem = [[NSBundle mainBundle] pathForResource:@"certificate" ofType:@"pem"].UTF8String;
    //const char *thing_to_sign = [[NSBundle mainBundle] pathForResource:@"manifest" ofType:@"json"].UTF8String;
    

    NSData *manifestdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://192.168.0.107/pass/Starbucks/manifest.json"]];
    unsigned char *thing_to_sign_data = manifestdata.bytes;
    unsigned int thing_to_sign_length = manifestdata.length;
    
    openssl_spul(key_pem, certificate_pem, thing_to_sign_data, thing_to_sign_length);
    NSData *data = [NSData dataWithBytes:&output_buf[0] length:output_buf_len];
    
    [archive deflateData:data withFilename:@"signature" andAttributes:nil];
#endif
    //archive
    //[archive deflateData:data withFilename:@"hello.blaarp" andAttributes:nil];
    //NSString *ppath = [[NSBundle mainBundle] pathForResource:@"Starbucks" ofType:@"pkpass"];
    //NSData *pdata = [NSData dataWithContentsOfFile:ppath];
    //archive = [ZKDataArchive archiveWithArchiveData:[pdata mutableCopy]];
    //[self addToArchive:archive :@"icon" :@"png"];
    
    
    NSError *error;
    PKPass *pass = [[PKPass alloc] initWithData:archive.data error:&error];
    
    
    PKAddPassesViewController *vc = [[PKAddPassesViewController alloc] initWithPass:pass];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
