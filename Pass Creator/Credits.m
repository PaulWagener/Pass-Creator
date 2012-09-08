//
//  Credits.m
//  Pass Creator
//
//  Created by Paul Wagener on 08-09-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import "Credits.h"

@implementation Credits

+ (int) getCredits {
    NSUbiquitousKeyValueStore *icloud = [NSUbiquitousKeyValueStore defaultStore];
    return [icloud longLongForKey:@"credits"];
}

+ (void) addCredits:(int) credits {
    int currentCredits = [Credits getCredits];
    NSUbiquitousKeyValueStore *icloud = [NSUbiquitousKeyValueStore defaultStore];
    [icloud setLongLong:currentCredits+credits forKey:@"credits"];
    [icloud synchronize];
}

+ (void) useCredit {
    [Credits addCredits:-1];
}

@end
