
#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "FeatureID.h"

@protocol MKStoreObserverDelegate <NSObject>

-(void)addPurchasedCoin:(NSInteger)coins;

@end

@interface MKStoreObserver : NSObject<SKPaymentTransactionObserver> {
	
}

@property (nonatomic, strong) id<MKStoreObserverDelegate> delegate;

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;
- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;

@end
