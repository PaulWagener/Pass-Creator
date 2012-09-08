//
//  BuyCreditsControllerViewController.m
//  Pass Creator
//
//  Created by Paul Wagener on 08-09-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import "BuyCreditsController.h"
#import "Credits.h"
@implementation SKProduct (LocalizedPrice)

-(NSNumberFormatter*) numberFormatter {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:self.priceLocale];
    return numberFormatter;
}

- (NSString *)localizedPrice
{
    NSNumberFormatter *numberFormatter = [self numberFormatter];
    return [numberFormatter stringFromNumber:self.price];
}

@end

@interface BuyCreditsController ()

@end


@implementation BuyCreditsController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    storeProducts = @[
        @{@"id": @"nl.paulwagener.passcreator.credits.1", @"count": @1}.mutableCopy,
        @{@"id": @"nl.paulwagener.passcreator.credits.5", @"count": @5}.mutableCopy,
        @{@"id": @"nl.paulwagener.passcreator.credits.10", @"count": @10}.mutableCopy,
        @{@"id": @"nl.paulwagener.passcreator.credits.100", @"count": @100}.mutableCopy,
        @{@"id": @"nl.paulwagener.passcreator.credits.1000", @"count": @1000}.mutableCopy,
    ];

    NSMutableSet *creditProducts = [[NSMutableSet alloc] init];
    for(NSDictionary *storeProduct in storeProducts)
        [creditProducts addObject:[storeProduct valueForKey:@"id"]];

    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:creditProducts];
    request.delegate = self;
    [request start];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // Listen for payment callbacks
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

/**
 * Fail!
 */
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:@"Error contacting server" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
    [self dismissModalViewControllerAnimated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)requestDidFinish:(SKRequest *)request {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    for(SKProduct *product in response.products) {
        for(NSMutableDictionary *storeProduct in storeProducts) {
            if([product.productIdentifier isEqualToString:[storeProduct valueForKey:@"id"]]) {
                [storeProduct setValue:product forKey:@"product"];
            }
        }
    }
    
    [tableview reloadData];
    
    activity.alpha = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        tableview.alpha = 1.0;
    }];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStateFailed:
                //If the failure is not from the user canceling show an error
                if(transaction.error.code != SKErrorPaymentCancelled)
                    [[[UIAlertView alloc] initWithTitle:@"Purchase error" message:transaction.error.localizedDescription delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
                
                //Finish transaction
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
            case SKPaymentTransactionStatePurchased:
            {
                SKPaymentTransaction *purchasedTransaction = transaction;
                if(transaction.transactionState == SKPaymentTransactionStateRestored)
                    purchasedTransaction = transaction.originalTransaction;
                
                //User purchased credits, awesome!
                for(NSDictionary *storeProduct in storeProducts) {
                    if([[storeProduct valueForKey:@"id"] isEqualToString:purchasedTransaction.payment.productIdentifier]) {
                        NSNumber *credits = [storeProduct valueForKey:@"count"];
                        [Credits addCredits:[credits intValue]];
                    }
                }
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }
                
            default:
                break;
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SKProduct *product = [[storeProducts objectAtIndex:indexPath.row] valueForKey:@"product"];
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return storeProducts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CreditsCell"];
    
    NSDictionary *storeProduct = [storeProducts objectAtIndex:indexPath.row];
    SKProduct *product = [storeProduct valueForKey:@"product"];
    
    NSNumberFormatter *formatter = [product numberFormatter];
    NSNumber *count = [storeProduct valueForKey:@"count"];
    NSDecimalNumber *price_per_card = [product.price decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithDecimal:count.decimalValue]];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ credit%@ (%@)", count, [count intValue] == 1 ? @"" : @"s", [product localizedPrice]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ per pass", [formatter stringFromNumber:price_per_card]];
    
    return cell;
}

@end
