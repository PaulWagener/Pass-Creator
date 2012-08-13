//
//  Pass.m
//  Pass Creator
//
//  Created by Paul Wagener on 13-08-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import "Pass.h"
#import "PassBundle.h"
#import <PassKit/PassKit.h>
@implementation Pass

PassBundle *passBundle = nil;
- (void) addToArchive :(NSString*)filename{
    NSString *url = [NSString stringWithFormat:@"http://192.168.0.107/pass/Starbucks/%@",filename];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    [passBundle addFile:filename :data];
}

- (UIViewController*) previewViewController {
    passBundle = [[PassBundle alloc] init];
    
    [self addToArchive :@"icon.png"];
    //[self addToArchive :@"icon@2x.png"];
    //[self addToArchive :@"logo.png"];
    //[self addToArchive :@"logo@2x.png"];
    [self addToArchive :@"pass.json"];
    
    NSError *error;
    PKPass *pass = [[PKPass alloc] initWithData:[passBundle data] error:&error];
    
    return [[PKAddPassesViewController alloc] initWithPass:pass];
    
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Starbucks" ofType:@"pkpass"]];
    PKPass *pkpass = [[PKPass alloc] initWithData:data error:nil];
    return [[PKAddPassesViewController alloc] initWithPass:pkpass];
    
}

@end
