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
#import "PassBundle.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self click:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void) addToArchive :(NSString*)filename{
    NSString *url = [NSString stringWithFormat:@"http://192.168.0.107/pass/Starbucks/%@",filename];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    [passBundle addFile:filename :data];
}
PassBundle *passBundle = nil;


- (IBAction) click:(id)sender {
    passBundle = [[PassBundle alloc] init];
    
    [self addToArchive :@"icon.png"];
    [self addToArchive :@"icon@2x.png"];
    [self addToArchive :@"logo.png"];
    [self addToArchive :@"logo@2x.png"];
    [self addToArchive :@"pass.json"];
    
    NSError *error;
    PKPass *pass = [[PKPass alloc] initWithData:[passBundle data] error:&error];
    
    PKAddPassesViewController *vc = [[PKAddPassesViewController alloc] initWithPass:pass];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
