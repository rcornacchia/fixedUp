

#import "MKStoreManager.h"
#import "AppDelegate.h"

@implementation MKStoreManager

@synthesize purchasableObjects;
@synthesize storeObserver;
// all your features should be managed one and only by StoreManager

BOOL feature0Purchased;

static MKStoreManager* _sharedStoreManager; // self

- (void)dealloc {
    
    [_sharedStoreManager release];
    [storeObserver release];
}

+ (BOOL) feature0Purchased {
    return feature0Purchased;
}

+ (MKStoreManager*)sharedManager
{
    NSLog(@"pass sharedManager");
    //	@synchronized(_sharedStoreManager)
    {
        
        if (_sharedStoreManager == nil) {
            
            _sharedStoreManager = [[MKStoreManager alloc] init]; // assignment not done here
            _sharedStoreManager.purchasableObjects = [[NSMutableArray alloc] init];
            [_sharedStoreManager requestProductData];
            
            [MKStoreManager loadPurchases];
            _sharedStoreManager.storeObserver = [[MKStoreObserver alloc] init];
            [[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedStoreManager.storeObserver];
        }
    }
    return _sharedStoreManager;
}


#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone

{
    //    @synchronized(_sharedStoreManager)
    {
        
        if (_sharedStoreManager == nil) {
            
            _sharedStoreManager = [super allocWithZone:zone];
            return _sharedStoreManager;  // assignment and return on first allocation
        }
    }
    
    return nil; //on subsequent allocation attempts return nil
}


- (void) requestProductData
{
    SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:
                                 [NSSet setWithObjects:
                                  IAP_1coin, IAP_5coins, IAP_10coins, nil]]; // add any other product here
    request.delegate = self;
    [request start];
}


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    [purchasableObjects addObjectsFromArray:response.products];
    // populate your UI Controls here
    for(int i=0;i<[purchasableObjects count];i++)
    {
        SKProduct *product = [purchasableObjects objectAtIndex:i];
        NSLog(@"Feature: %@, Cost: %f, ID: %@",[product localizedTitle],
              [[product price] doubleValue], [product productIdentifier]);
    }
    
    [request autorelease];
}

-(void) onBuy1 {
    [self buyFeature:0];
}

-(void) onBuy5 {
    [self buyFeature:1];
}

-(void) onBuy10 {
    [self buyFeature:2];
}


- (void) buyFeature:(int ) featureId
{
    //	[self setLockKey: featureId];
    if ([SKPaymentQueue canMakePayments] && [self.purchasableObjects count] > featureId )
    {
        // SKPayment *payment = [SKPayment paymentWithProductIdentifier:featureId];
        SKPayment * payment = [SKPayment paymentWithProduct:[self.purchasableObjects objectAtIndex:featureId]];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"You are not authorized to purchase from AppStore" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    NSString *messageToBeShown = [NSString stringWithFormat:@"Reason: %@, You can try: %@", [transaction.error localizedFailureReason], [transaction.error localizedRecoverySuggestion]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to complete your purchase" message:messageToBeShown delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

-(void) provideContent: (NSString*) productIdentifier
{
    
}

+(void) loadPurchases 
{
    
}

+(void) updatePurchases
{
    
}

+(void) restorePurchases
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedStoreManager.storeObserver];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

@end
