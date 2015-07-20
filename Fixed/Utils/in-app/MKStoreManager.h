

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "MKStoreObserver.h"
#import "FeatureID.h"

@interface MKStoreManager : NSObject<SKProductsRequestDelegate> {

	NSMutableArray *purchasableObjects;
	MKStoreObserver *storeObserver;	
	
}


@property (nonatomic, strong) NSMutableArray *purchasableObjects;
@property (nonatomic, strong) MKStoreObserver *storeObserver;

- (void) requestProductData;

-(void) onBuy1;

-(void) onBuy5;

-(void) onBuy10;

// do not call this directly. This is like a private method
//- (void) buyFeature:(NSString*) featureId;
- (void) buyFeature:(int) featureId;

- (void) failedTransaction: (SKPaymentTransaction *)transaction;
-(void) provideContent: (NSString*) productIdentifier;

+ (MKStoreManager*)sharedManager;

+ (BOOL) feature0Purchased;
+(void) restorePurchases;
+(void) loadPurchases;
+(void) updatePurchases;

@end
