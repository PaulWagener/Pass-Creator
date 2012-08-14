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
    
    if(self.passType == BOARDING)
        [self addLabelValue:primaryFields :@"primaryfield2" :self.primaryLabel2 :self.primaryValue2];
    
    // Secondary fields dictionary
    NSMutableArray *secondaryFields = [NSMutableArray array];
    [self addLabelValue:secondaryFields :@"secondaryfield1" :self.secondaryLabel1 :self.secondaryValue1];
    [self addLabelValue:secondaryFields :@"secondaryfield2" :self.secondaryLabel2 :self.secondaryValue2];
    [self addLabelValue:secondaryFields :@"secondaryfield3" :self.secondaryLabel3 :self.secondaryValue3];
    [self addLabelValue:secondaryFields :@"secondaryfield4" :self.secondaryLabel4 :self.secondaryValue4];
    
    NSString *passTypeString;
    if(self.passType == BOARDING)
        passTypeString = @"boardingPass";
    else if(self.passType == COUPON)
        passTypeString = @"coupon";
    else if(self.passType == EVENT)
        passTypeString = @"eventTicket";
    else if(self.passType == GENERIC)
        passTypeString = @"generic";
    else if(self.passType == STORE)
        passTypeString = @"storeCard";
    
    NSMutableDictionary *fieldsDictionary = @{
        @"primaryFields" : primaryFields,
        @"secondaryFields": secondaryFields,
    }.mutableCopy;
    
    // Add transit type information
    if(self.passType == BOARDING) {
        NSString *transitTypeString;
        if(self.transitType == TRANSIT_AIR)
            transitTypeString = @"PKTransitTypeAir";
        else if(self.transitType == TRANSIT_TRAIN)
            transitTypeString = @"PKTransitTypeTrain";
        else if(self.transitType == TRANSIT_BUS)
            transitTypeString = @"PKTransitTypeBus";
        else if(self.transitType == TRANSIT_BOAT)
            transitTypeString = @"PKTransitTypeBoat";
        else if(self.transitType == TRANSIT_GENERIC)
            transitTypeString = @"PKTransitTypeGeneric";
        
        [fieldsDictionary setObject:transitTypeString forKey:@"transitType"];
    }
        
    
    NSMutableDictionary *passDictionary =
    @{
    @"formatVersion" : @1,
    @"passTypeIdentifier" : @"pass.nl.paulwagener.passcreator",
    @"serialNumber" : @"1",
    @"organizationName" : @"Pass Creator",
    @"teamIdentifier" : @"37HYQWCA73",
    @"description": @"Pass Creator Pass",
    passTypeString: fieldsDictionary,
    @"backFields": @[@{@"key": @"credits", @"label": @"Created By Pass Creator", @"value": @"Download at ..."}],
    @"backgroundColor" : self.backgroundColor.cssString,
    @"labelColor" : self.labelColor.cssString,
    @"foregroundColor" : self.valueColor.cssString,
    }.mutableCopy;
    
    if(self.title != nil && ![self.title isEqualToString:@""])
        [passDictionary setObject:self.title forKey:@"logoText"];
    
    
    if(self.thumbnail != nil && (self.passType == GENERIC || self.passType == EVENT)) {
        [passBundle addFile:@"thumbnail.png" : UIImagePNGRepresentation(self.thumbnail)];
    }
    
    if(self.background != nil && self.passType == EVENT)
        [passBundle addFile:@"background.png" : UIImagePNGRepresentation(self.background)];

    if(self.logo != nil)
        [passBundle addFile:@"logo.png" :UIImagePNGRepresentation(self.logo)];
    
    if(self.strip != nil && (self.passType == COUPON || self.passType == STORE))
        [passBundle addFile:@"strip.png" :UIImagePNGRepresentation(self.strip)];
    
    /*
    [passBundle addFile:@"strip.png" :[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ColorPicker" ofType:@"png"]]];

    [passBundle addFile:@"background.png" :[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ColorPicker" ofType:@"png"]]];
     */
    
    [passBundle addFile:@"pass.json" :passDictionary.JSONData];
    
    NSError *error;
    NSData *passData = [passBundle data];
    NSLog(@"Pass Size: %d", passData.length);
    PKPass *pass = [[PKPass alloc] initWithData:passData error:&error];
    
    return [[PKAddPassesViewController alloc] initWithPass:pass];
    
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Starbucks" ofType:@"pkpass"]];
    PKPass *pkpass = [[PKPass alloc] initWithData:data error:nil];
    return [[PKAddPassesViewController alloc] initWithPass:pkpass];
    
}

@end
