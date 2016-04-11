//
//  PaylevenAppApi.h
//  PaylevenAppApi
//
//  Copyright (c) 2012, 2013 Payleven Holding GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define PAYLEVEN_APP_API_VERSION @"1.2"

/** Return value error codes
 */
typedef NS_ENUM(NSUInteger, PaylevenAppApiErrorCode)
{
    /** no error */
    PAAPI_NO_ERROR                          = 0,
    /** unknwon error */
    PAAPI_UNKNOWN_ERROR                     = 100,
    /** a payment with the same orderId has already been made */
    PAAPI_PAYMENT_ALREADY_EXISTS            = 101,
    /** your api key is wrong */
    PAAPI_SIGNATURE_INVALID                 = 102,
    /** there is no api key for your app */
    PAAPI_API_KEY_NOT_FOUND                 = 103,
    /** payleven network error */
    PAAPI_API_SERVICE_FAILED                = 104,
    /** api service error */
    PAAPI_API_SERVICE_ERROR                 = 105,
    /** tried to make a payment in a country that doesn't fit the payleven account */
    PAAPI_COUNTRY_INVALID                   = 106,
    /** failed card authorisation */
    PAAPI_FAILED_PAYMENT_AUTH               = 107,
    /** transaction not found */
    PAAPI_TRANSACTION_NOT_FOUND             = 108,
    /** refund failed */
    PAAPI_FAILED_REFUND                     = 109,
    /** indicates any terminal related error */
    PAAPI_TERMINAL_MISCONFIGURED            = 110,
    /** the network connection timed out while doing a request */
    PAAPI_NETWORK_CONNECTION_TIMED_OUT      = 111,
    /** the payment with this ID is already refunded */
    PAAPI_ALREADY_REFUNDED                  = 112,
    /** the payment with this ID was canceled */
    PAAPI_PAYMENT_WAS_CANCELED              = 113,
    /** the payment with this ID was declined */
    PAAPI_PAYMENT_WAS_DECLINED              = 114,
    /** there is already another transaction in progress in the payleven app */
    PAAPI_ANOTHER_TRANSACTION_IN_PROGRESS   = 115,
};

/** valid currencies
 */
typedef NS_ENUM(NSUInteger, PaylevenCurrency)
{
    /** Euro */
    PC_EUR = 0,
    /** United Kingdom, Pounds */
    PC_GBP,
    /** Poland, Złoty */
    PC_PLN,
};

/** Responses
 */

extern NSString* const PaylevenPaymentSuccessful;
extern NSString* const PaylevenPaymentError;
extern NSString* const PaylevenPaymentCanceled;
extern NSString* const PaylevenPaymentDeclined;
extern NSString* const PaylevenRefundSuccessful;
extern NSString* const PaylevenRefundError;
extern NSString* const PaylevenRefundCanceled;
extern NSString* const PaylevenTransactionDetailsCanceled;
extern NSString* const PaylevenTransactionDetailsError;
extern NSString* const PaylevenTransactionNotFound;
extern NSString* const PaylevenSalesHistoryCanceled;


/** Error Domain for PaylevenAppApi related errors
 */
extern NSString* const PaylevenAppApiErrorDomain;

/** Handle payment results
 */
@protocol PaylevenPaymentDelegate <NSObject>

/** triggered on failed payments
 @param error Contains more information about the error see `PaylevenAppApiErrorCode` for details on the different errorcodes
 @param parameters A dictionary of return values with information about the payment
 */
- (void)paylevenPaymentDidFailWithError:(NSError*)error
                             parameters:(NSDictionary*)parameters;

/** triggered on succesful finished payment
 * @param parameters A dictionary of return values with information about the payment
 */
- (void)paylevenPaymentFinished:(NSDictionary*)parameters;

/** triggered on succesful canceled payment
 * @param parameters A dictionary of return values with information about the payment
 */
- (void)paylevenPaymentCanceled:(NSDictionary*)parameters;

/** triggered on declined/refused payment
 * @param parameters A dictionary of return values with information about the payment
 */
- (void)paylevenPaymentDeclined:(NSDictionary*)parameters;

/** triggered on succesful refund
 * @param parameters A dictionary of return values with information about the payment
 */
- (void)paylevenRefundFinished:(NSDictionary*)parameters;

/** triggered on transaction not found
 * @param orderId The order ID you specified while creating the payment
 */
- (void)paylevenTransactionNotFound:(NSString*)orderId;

/** triggered on succesful canceled refund
 * @param orderId The order ID you specified while creating the payment
 */
- (void)paylevenRefundCanceled:(NSString*)orderId;

/** triggered on succesful canceled refund
 * @param orderId The order ID you specified while creating the payment
 */
- (void)paylevenTransactionDetailsCanceled:(NSString*)orderId;

/** triggered on failed refunds
 @param error Contains more information about the error see `PaylevenAppApiErrorCode` for details on the different errorcodes
 @param parameters A dictionary of return values with information about the payment
 */
- (void)paylevenRefundDidFailWithError:(NSError*)error
                            parameters:(NSDictionary*)parameters;

/** triggered on failed transaction details
 @param error Contains more information about the error see PaylevenAppApiErrorCode for details on the different errorcodes
 @param parameters A dictionary of return values with information about the payment
 */
- (void)paylevenTransactionDetailsFailWithError:(NSError*)error
                                     parameters:(NSDictionary*)parameters;


/** triggered on succesful canceled sales history
 * @param orderId The orderid you specified while creating the payment
 */
- (void)paylevenSalesHistoryCanceled:(NSString*)orderId;

@end

/** The PaylevenAppApi allows app developers to open the payleven app from within their own apps and to do payments with it.
 */
@interface PaylevenAppApi : NSObject

/** Singleton access method.
 */
+ (PaylevenAppApi*)sharedInstance;

/** Initial api setup has to be called before doing any other calls to the API.
 @param apiKey The apikey you received from payleven
 @param callbackUrlScheme The custom url scheme you registered for your app and which the payleven app should use to open your app on payment results
 
 for more information about creating a custom url scheme for your app see
 the __Implementing Custom URL Schemes__ section in the [Apple Documentation](http://developer.apple.com/library/ios/#documentation/iphone/conceptual/iphoneosprogrammingguide/AdvancedAppTricks/AdvancedAppTricks.html) .
 
 __Example:__
 
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
 {
 [[PaylevenAppApi sharedInstance] configure:@"yourapikey" callbackUrlScheme:@"yoururlscheme"];
 return YES;
 }
 */
- (BOOL)configure:(NSString*)apiKey callbackUrlScheme:(NSString*)callbackUrlScheme;

/** Handle the return calls from the payleven app to your app.
 @param url The url the payleven app used to open the client app.
 @param bundleId Caller app bundle id.
 @return YES If the given url and bundle id have been handled.
 @return NO In case of an error.
 
 Has to be called from yor AppDelegate openURL method
 
 __Example:__
 
 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
 {
 [[PaylevenAppApi sharedInstance] handleOpenUrl:url bundleId:sourceApplication];
 return YES;
 }
 */
- (BOOL)handleOpenUrl:(NSURL*)url bundleId:(NSString*)bundleId;

/** Initate a payment with the payleven app.
 * @param delegate Delegate that implements the PaylevenPaymentDelegate protocol.
 * @param amount The amount of the payment in cents so that it should be be multiplied by 100 (1.25 becomes 125). This value has to be larger than 0.
 * @param currency The `PaylevenCurrency` to use has to be the currency of the current country.
 * @param orderId Id of this order has to be unique over all payments for the payleven merchant else the payment will fail.
 * @param description Optional description string for the payment.
 * @param image Optional image for the product that will be shown on the receipt the image will be rescaled to 197x197 so you should give a squared image.
 * @param printerIp Optional ip for an epson printer
 * @return NO on error
 * @return YES on success
 * @see PaylevenCurrency
 */
- (BOOL)payWithPayleven:(NSObject <PaylevenPaymentDelegate>*)delegate
                 amount:(NSUInteger)amount
               currency:(PaylevenCurrency)currency
                orderId:(NSString*)orderId
            description:(NSString*)description
                  image:(UIImage*)image
              printerIp:(NSString*)printerIp;

/** Open transaction history with the payleven app.
 * @param delegate Delegate that implements the `PaylevenPaymentDelegate` protocol.
 * @return NO on error
 * @return YES on success
 */
- (BOOL)openTransactionHistory:(NSObject <PaylevenPaymentDelegate>*)delegate;

/** Open transaction detail with the payleven app but disable doing refunds.
 * @param delegate Delegate that implements the PaylevenPaymentDelegate protocol.
 * @param orderId Id of this order has to be unique over all payments for the payleven merchant else the payment will fail.
 * @return NO on error
 * @return YES on success
 */
- (BOOL)openTransactionDetails:(NSObject <PaylevenPaymentDelegate>*)delegate orderId:(NSString*)orderId;

/** Open transaction detail with the payleven app but only enable refunds.
 * @param delegate Delegate that implements the PaylevenPaymentDelegate protocol.
 * @param orderId Id of this order has to be unique over all payments for the payleven merchant else the payment will fail.
 * @return NO on error
 * @return YES on success
 */
- (BOOL)openTransactionDetailsForRefund:(NSObject <PaylevenPaymentDelegate>*)delegate orderId:(NSString*)orderId;

/** Reset a payment that wasn't finished properly. This might happen if the payleven app is closed while the payment wasn't finished.
 @warning if there is an ongoing payment in the payleven app this will not be canceled but you will not receive a callback through the PaylevenPaymentDelegate
 */
- (void)reset;

/** check if there is an pending payment intiated from your app
 * @return YES if there is an pending payment
 * @return NO if there is an pending payment
 */
- (BOOL)isPaymentPending;

/** check if the payleven scheme is registered
 * @return YES if payleven scheme is registered
 * @return NO if payleven scheme is not registered
 */
- (BOOL)isPaylevenAvailable;

/** Flag to check if the API is successfully configured.
 */
@property (readonly) BOOL isConfigured;

@end