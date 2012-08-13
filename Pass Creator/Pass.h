//
//  Pass.h
//  Pass Creator
//
//  Created by Paul Wagener on 13-08-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import <Foundation/Foundation.h>

enum PassType {
    BOARDING,
    COUPON,
    EVENT,
    GENERIC,
    STORE
};

enum TransitType {
    TRANSIT_AIR,
    TRANSIT_TRAIN,
    TRANSIT_BUS,
    TRANSIT_BOAT,
    TRANSIT_GENERIC
};

enum BarcodeType {
    BARCODE_AZTEC,
    BARCODE_QR,
    BARCODE_PDF417
};

@interface UIColor(UIColorWithCSS)

- (NSString*) cssString;

@end


@interface Pass : NSObject

@property NSString *title;

@property UIImage *image;

// Colors
@property UIColor *backgroundColor;
@property UIColor *labelColor;
@property UIColor *valueColor;

// Labels & Values
@property NSString *primaryLabel1;
@property NSString *primaryValue1;

@property NSString *primaryLabel2;
@property NSString *primaryValue2;

@property NSString *secondaryLabel1;
@property NSString *secondaryValue1;

@property NSString *secondaryLabel2;
@property NSString *secondaryValue2;

@property NSString *secondaryLabel3;
@property NSString *secondaryValue3;

@property NSString *secondaryLabel4;
@property NSString *secondaryValue4;

@property (copy) NSString *auxiliaryLabel5;
@property (copy) NSString *auxiliaryValue5;

@property (strong) NSString *auxiliaryLabel6;
@property (strong) NSString *auxiliaryValue6;

// Barcode
@property enum BarcodeType barcodeType;
@property NSString *barcodeMessage;
@property NSString *barcodeText;

// Location

// Relevant Date & Time

@property enum PassType passType;

@property enum TransitType transitType;

- (UIViewController*) previewViewController;

@end
