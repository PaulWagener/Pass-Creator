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
#import "JSONKit.h"

@implementation UIColor(UIColorWithCSS)

- (NSString*) cssString {
    CGFloat r, g, b, alpha;
    [self getRed:&r green:&g blue:&b alpha:&alpha];
    return [NSString stringWithFormat:@"rgb(%d, %d, %d)", (int)(r*255), (int)(g*255), (int)(b*255)];
}

@end

@implementation Pass

PassBundle *passBundle = nil;
- (void) addToArchive :(NSString*)filename{
    NSString *url = [NSString stringWithFormat:@"http://192.168.0.107/pass/Starbucks/%@",filename];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    [passBundle addFile:filename :data];
}

- (void) addLabelValue:(NSMutableArray*)fields :(NSString*)key :(NSString*) label :(NSString*) value {
    const bool notBothEmpty = (!([label isEqualToString:@""]) || !([value isEqualToString:@""]));
    if(label != nil
       && value != nil
       && notBothEmpty) {
        [fields addObject:@{@"key": key, @"label": label, @"value": value}];
    }
    
}

- (UIViewController*) previewViewController {
    passBundle = [[PassBundle alloc] init];
    
    [self addToArchive :@"icon.png"];
    
    // Primary fields dictionary
    NSMutableArray *primaryFields = [NSMutableArray array];
    [self addLabelValue:primaryFields :@"primaryfield1" :self.primaryLabel1 :self.primaryValue1];
    [self addLabelValue:primaryFields :@"primaryfield2" :self.primaryLabel2 :self.primaryValue2];
    
    // Secondary fields dictionary
    NSMutableArray *secondaryFields = [NSMutableArray array];
    [self addLabelValue:secondaryFields :@"secondaryfield1" :self.secondaryLabel1 :self.secondaryValue1];
    [self addLabelValue:secondaryFields :@"secondaryfield2" :self.secondaryLabel2 :self.secondaryValue2];
    [self addLabelValue:secondaryFields :@"secondaryfield3" :self.secondaryLabel3 :self.secondaryValue3];
    [self addLabelValue:secondaryFields :@"secondaryfield4" :self.secondaryLabel4 :self.secondaryValue4];
    
    // Auxiliary fields dictionary
    NSMutableArray *auxiliaryFields = [NSMutableArray array];
    [self addLabelValue:auxiliaryFields :@"auxiliaryfield5" :self.auxiliaryLabel5 :self.auxiliaryValue5];
    [self addLabelValue:auxiliaryFields :@"auxiliaryfield6" :self.auxiliaryLabel6 :self.auxiliaryValue6];
    
    self.backgroundColor = [UIColor purpleColor];
    NSMutableDictionary *passDictionary =
    @{
    @"formatVersion" : @1,
    @"passTypeIdentifier" : @"pass.nl.paulwagener.passcreator",
    @"serialNumber" : @"1",
    @"organizationName" : @"Pass Creator",
    @"teamIdentifier" : @"37HYQWCA73",
    @"description": @"Pass Creator Pass",
    @"boardingPass": @{
        @"transitType": @"PKTransitTypeAir",
        @"primaryFields" : primaryFields,
        @"secondaryFields": secondaryFields,
        @"auxiliaryFields": auxiliaryFields,
    },
    @"backFields": @[@{@"key": @"credits", @"label": @"Created By Pass Creator", @"value": @"Download at ..."}],
    
    @"barcode" : @{
        @"message" : self.barcodeMessage == nil ? @"k" : self.barcodeMessage,
        @"altText" : self.barcodeText == nil ? @"" : self.barcodeText,
        @"format" : @"PKBarcodeFormatPDF417",
        @"messageEncoding" : @"utf-8"
    },
    
    @"backgroundColor" : self.backgroundColor.cssString,
    @"logoText": self.title == nil ? @"" : self.title
    }.mutableCopy;
    
    [passBundle addFile:@"pass.json" :passDictionary.JSONData];
    
    NSError *error;
    PKPass *pass = [[PKPass alloc] initWithData:[passBundle data] error:&error];
    
    return [[PKAddPassesViewController alloc] initWithPass:pass];
    
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Starbucks" ofType:@"pkpass"]];
    PKPass *pkpass = [[PKPass alloc] initWithData:data error:nil];
    return [[PKAddPassesViewController alloc] initWithPass:pkpass];
    
}

@end
