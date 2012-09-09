//
//  BuyCreditsControllerViewController.h
//  Pass Creator
//
//  Created by Paul Wagener on 08-09-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "MainTableController.h"

@interface BuyCreditsController : UIViewController<UITableViewDataSource, UITableViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    IBOutlet UIActivityIndicatorView *activity;
    IBOutlet UITableView *tableview;
    IBOutlet UILabel *creditsLabel;
    
    
    NSArray *storeProducts;
}

@property MainTableController *parent;



@end
