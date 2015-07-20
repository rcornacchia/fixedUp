//
//  MKStoreObserver.m
//
//

#import "MKStoreObserver.h"
#import "MKStoreManager.h"
#import "AppDelegate.h"

static NSUInteger m_nCoin;


@implementation MKStoreObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                
                break;
                
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                
                break;
                
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
                
            default:
                
                break;
        }
    }
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    if (transaction.error.code != SKErrorPaymentCancelled){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The upgrade procedure failed" message:@"Please check your Internet connection and your App Store account information." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    [[MKStoreManager sharedManager] provideContent: transaction.payment.productIdentifier];
    //	[[MKStoreManager sharedManager] setLockKey: transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    m_nCoin = 0;
    if([transaction.payment.productIdentifier isEqualToString:IAP_1coin]){
        m_nCoin = 1;
    }else if([transaction.payment.productIdentifier isEqualToString:IAP_5coins]){
        m_nCoin = 5;
    }else if([transaction.payment.productIdentifier isEqualToString:IAP_10coins]){
        m_nCoin = 10;
    }
   
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(addPurchasedCoin:)]) {
        [self.delegate addPurchasedCoin:m_nCoin];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Purchased Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    [[MKStoreManager sharedManager] provideContent: transaction.originalTransaction.payment.productIdentifier];
    //	[[MKStoreManager sharedManager] setLockKey: transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

@end
