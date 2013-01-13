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
#import "Config.h"

@implementation UIColor(UIColorWithCSS)

- (NSString*) cssString {
    CGFloat r, g, b, alpha;
    [self getRed:&r green:&g blue:&b alpha:&alpha];
    return [NSString stringWithFormat:@"rgb(%d, %d, %d)", (int)(r*255), (int)(g*255), (int)(b*255)];
}

@end

@implementation Pass


- (id) init {
    self = [super init];
    self.passType = GENERIC;
    self.transitType = TRANSIT_AIR;
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.labelColor = [UIColor blackColor];
    self.valueColor = [UIColor blackColor];
    self.title = @"";
    return self;
}
/**
 * Enable serialization / deserialization to data
 */
- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInt:self.passType forKey:@"passType"];
    [coder encodeInt:self.transitType forKey:@"transitType"];
    [coder encodeObject:self.logo forKey:@"logo"];
    [coder encodeObject:self.thumbnail forKey:@"thumbnail"];
    [coder encodeObject:self.strip forKey:@"strip"];
    [coder encodeObject:self.backgroundColor forKey:@"backgroundColor"];
    [coder encodeObject:self.labelColor forKey:@"labelColor"];
    [coder encodeObject:self.valueColor forKey:@"valueColor"];
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.primaryLabel1 forKey:@"primaryLabel1"];
    [coder encodeObject:self.primaryValue1 forKey:@"primaryValue1"];
    [coder encodeObject:self.primaryLabel2 forKey:@"primaryLabel2"];
    [coder encodeObject:self.primaryValue2 forKey:@"primaryValue2"];
    [coder encodeObject:self.secondaryLabel1 forKey:@"secondaryLabel1"];
    [coder encodeObject:self.secondaryValue1 forKey:@"secondaryValue1"];
    [coder encodeObject:self.secondaryLabel2 forKey:@"secondaryLabel2"];
    [coder encodeObject:self.secondaryValue2 forKey:@"secondaryValue2"];
    [coder encodeObject:self.secondaryLabel3 forKey:@"secondaryLabel3"];
    [coder encodeObject:self.secondaryValue3 forKey:@"secondaryValue3"];
    [coder encodeObject:self.secondaryLabel4 forKey:@"secondaryLabel4"];
    [coder encodeObject:self.secondaryValue4 forKey:@"secondaryValue4"];
    [coder encodeObject:self.barcode forKey:@"barcode"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [self init];
    self.passType = [decoder decodeIntForKey:@"passType"];
    self.transitType = [decoder decodeIntForKey:@"transitType"];
    self.logo = [decoder decodeObjectForKey:@"logo"];
    self.thumbnail = [decoder decodeObjectForKey:@"thumbnail"];
    self.strip = [decoder decodeObjectForKey:@"strip"];
    self.backgroundColor = [decoder decodeObjectForKey:@"backgroundColor"];
    self.labelColor = [decoder decodeObjectForKey:@"labelColor"];
    self.valueColor = [decoder decodeObjectForKey:@"valueColor"];
    self.title = [decoder decodeObjectForKey:@"title"];
    self.primaryLabel1 = [decoder decodeObjectForKey:@"primaryLabel1"];
    self.primaryValue1 = [decoder decodeObjectForKey:@"primaryValue1"];
    self.primaryLabel2 = [decoder decodeObjectForKey:@"primaryLabel2"];
    self.primaryValue2 = [decoder decodeObjectForKey:@"primaryValue2"];
    self.secondaryLabel1 = [decoder decodeObjectForKey:@"secondaryLabel1"];
    self.secondaryValue1 = [decoder decodeObjectForKey:@"secondaryValue1"];
    self.secondaryLabel2 = [decoder decodeObjectForKey:@"secondaryLabel2"];
    self.secondaryValue2 = [decoder decodeObjectForKey:@"secondaryValue2"];
    self.secondaryLabel3 = [decoder decodeObjectForKey:@"secondaryLabel3"];
    self.secondaryValue3 = [decoder decodeObjectForKey:@"secondaryValue3"];
    self.secondaryLabel4 = [decoder decodeObjectForKey:@"secondaryLabel4"];
    self.secondaryValue4 = [decoder decodeObjectForKey:@"secondaryValue4"];
    self.barcode = [decoder decodeObjectForKey:@"barcode"];
    return self;
}


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
    

    // Generate a random serial number as to avoid collision with existing passes
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *serialNumber = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [serialNumber appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    
    NSMutableDictionary *passDictionary =
    @{
    @"formatVersion" : @1,
    @"passTypeIdentifier" : PASS_TYPE_IDENTIFIER,
    @"serialNumber" : serialNumber,
    @"organizationName" : @"Pass Creator",
    @"teamIdentifier" : @"37HYQWCA73",
    @"description": @"Pass Creator Pass",
    passTypeString: fieldsDictionary,
    @"backFields": @[@{@"key": @"credits", @"label": @"Created By Pass Creator", @"value": @"Download at http://itunes.apple.com/us/app/pass-creator/id536894864?l=nl&ls=1&mt=8"}],
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
    
    if(![self.barcode isEqualToString:@""] && self.barcode != nil) {
        [passDictionary setObject:@{
            @"format": @"PKBarcodeFormatQR",
            @"message": self.barcode,
            @"messageEncoding": @"iso-8859-1"
         } forKey:@"barcode"];
    }

    [passBundle addFile:@"pass.json" :passDictionary.JSONData];
    
    /**
     * Add other files
     */
    
    // Add mandatory logo (only visible in e-mail)
    [passBundle addFile:@"icon@2x.png" :[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Icon@2x" ofType:@"png"]]];

    if(self.thumbnail != nil && (self.passType == GENERIC || self.passType == EVENT))
        [passBundle addFile:@"thumbnail@2x.png" : UIImagePNGRepresentation(self.thumbnail)];
    
    if(self.thumbnail != nil && self.passType == EVENT)
        [passBundle addFile:@"background@2x.png": UIImagePNGRepresentation(self.thumbnail)];

    if(self.logo != nil)
        [passBundle addFile:@"logo@2x.png" :UIImagePNGRepresentation(self.logo)];
    
    if(self.strip != nil && (self.passType == COUPON || self.passType == STORE))
        [passBundle addFile:@"strip@2x.png" :UIImagePNGRepresentation(self.strip)];
    
    return [passBundle data];
}

@end
