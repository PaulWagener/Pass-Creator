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

- (void) addLabelValue:(NSMutableArray*)fields :(NSString*)key :(NSString*) label :(NSString*) value {
    const bool notBothEmpty = (!([label isEqualToString:@""]) || !([value isEqualToString:@""]));
    if(label != nil
       && value != nil
       && notBothEmpty) {
        [fields addObject:@{@"key": key, @"label": label, @"value": value}];
    }
    
}

- (NSData*) pkpassData {
    PassBundle* passBundle = [[PassBundle alloc] init];
    
    if (self.serialNumber == nil)
        self.serialNumber = @"foo";
    
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
    
    NSArray *auxiliaryFields = [NSArray array];
    if(self.passType == EVENT) {
        auxiliaryFields = secondaryFields;
        secondaryFields = [NSArray array];
    }
    
    NSMutableDictionary *fieldsDictionary = @{
        @"primaryFields" : primaryFields,
        @"secondaryFields": secondaryFields,
        @"auxiliaryFields": auxiliaryFields
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
    @"serialNumber" : self.serialNumber,
    @"organizationName" : @"Pass Creator",
    @"teamIdentifier" : @"37HYQWCA73",
    @"description": @"Pass Creator Pass",
    passTypeString: fieldsDictionary,
    @"backFields": @[@{@"key": @"credits", @"label": @"Created By Pass Creator", @"value": @"Download at ..."}],
    }.mutableCopy;
    
    if(self.passType != EVENT) {
        [passDictionary setObject:self.backgroundColor.cssString forKey:@"backgroundColor"];
        [passDictionary setObject:self.labelColor.cssString forKey:@"labelColor"];
        [passDictionary setObject:self.valueColor.cssString forKey:@"foregroundColor"];
    } else if(self.thumbnail == nil) {
        [passDictionary setObject:@"#626262" forKey:@"backgroundColor"];
        [passDictionary setObject:@"#FFFFFF" forKey:@"labelColor"];
        [passDictionary setObject:@"#DADADA" forKey:@"foregroundColor"];
    }
    
    if(self.title != nil && ![self.title isEqualToString:@""])
        [passDictionary setObject:self.title forKey:@"logoText"];
    
    [passBundle addFile:@"pass.json" :passDictionary.JSONData];
    
    /**
     * Add other files
     */
    
    // Add mandatory logo (should never be visible for user as long as we don't do push notifications)
    [passBundle addFile:@"icon.png" :[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"]]];

    if(self.thumbnail != nil && (self.passType == GENERIC || self.passType == EVENT))
        [passBundle addFile:@"thumbnail.png" : UIImagePNGRepresentation(self.thumbnail)];
    
    if(self.thumbnail != nil && self.passType == EVENT)
        [passBundle addFile:@"background.png" : UIImagePNGRepresentation(self.thumbnail)];

    if(self.logo != nil)
        [passBundle addFile:@"logo.png" :UIImagePNGRepresentation(self.logo)];
    
    if(self.strip != nil && (self.passType == COUPON || self.passType == STORE))
        [passBundle addFile:@"strip.png" :UIImagePNGRepresentation(self.strip)];
    
    return [passBundle data];
}

@end
