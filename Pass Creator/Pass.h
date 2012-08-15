//
//  Pass.h
//  Pass Creator
//
//  Created by Paul Wagener on 13-08-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import <Foundation/Foundation.h>

enum PassType {
    GENERIC,
    EVENT,
    BOARDING,
    COUPON,
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

@property NSString *serialNumber;

@property (copy) NSString *title;

@property UIImage *logo;
@property UIImage *thumbnail;
@property UIImage *strip;

// Colors
@property UIColor *backgroundColor;
@property UIColor *labelColor;
@property UIColor *valueColor;

// Labels & Values
@property (copy) NSString *primaryLabel1;
@property (copy) NSString *primaryValue1;

@property (copy) NSString *primaryLabel2;
@property (copy) NSString *primaryValue2;

@property (copy) NSString *secondaryLabel1;
@property (copy) NSString *secondaryValue1;

@property (copy) NSString *secondaryLabel2;
@property (copy) NSString *secondaryValue2;

@property (copy) NSString *secondaryLabel3;
@property (copy) NSString *secondaryValue3;

@property (copy) NSString *secondaryLabel4;
@property (copy) NSString *secondaryValue4;

// Barcode
@property enum BarcodeType barcodeType;
@property (copy) NSString *barcodeMessage;
@property (copy) NSString *barcodeText;

// Location

// Relevant Date & Time

@property enum PassType passType;

@property enum TransitType transitType;

- (UIViewController*) previewViewController;

@end
