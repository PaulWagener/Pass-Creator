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

@interface Pass : NSObject

@property NSString *title;

@property UIImage *image;

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

@property NSString *auxiliaryLabel5;
@property NSString *auxiliaryValue5;

@property NSString *auxiliaryLabel6;
@property NSString *auxiliaryValue6;

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
