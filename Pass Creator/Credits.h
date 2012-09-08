//
//  Credits.h
//  Pass Creator
//
//  Created by Paul Wagener on 08-09-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Credits : NSObject

+ (int) getCredits;
+ (void) addCredits:(int) credits;
+ (void) useCredit;

@end
