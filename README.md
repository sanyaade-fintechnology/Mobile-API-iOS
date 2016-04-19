# payleven Mobile API for iOS 

[![CocoaPods](https://img.shields.io/badge/Platform-iOS-yellow.svg?style=flat-square)]()
[![CocoaPods](https://img.shields.io/badge/Requires-iOS%207+-blue.svg?style=flat-square)]()
[![CocoaPods](https://img.shields.io/badge/Made%20in-Berlin-red.svg?style=flat-square)]()

The PaylevenAppApi makes possible for app developers to open the payleven application from within their own apps and process payments. Although the payment is initiated on your app, it is the payleven application that takes care of handling the payment process. After a payment is processed, it will open your app and notify if the payment was successful, canceled or failed. 

#### Main Features
- Connects to payleven EMV/PCI certified card reader via bluetooth
- Accept all major card schemes such as Visa, Mastercard or American Express
- Provide immediate information about the payment status 
- Refund card payments
- Supports cash payment method
- Supports all main languages

#### Limitations
- Available only on the markets where [payleven](https://payleven.com/) operates
- Limited control on the UI 

#### Prerequisites
######Step 1 - Create a merchant account
To process a transaction you need to login in the payleven app with our payleven account. You can create an account by registering on our [website](https://payleven.co.uk/registration/?login=). Make sure to register for the country you wish.

######Step 2 - Create a developer account
To grant your application access to payleven’s API you need to [register](https://developer.payleven.com/) and receive an API key. Please keep in mind that you should use your final app specifications (e.g bundle-ID for iOS or package name for Android) during the registration since these will be used in combination with your API key to identify of your app.

######Step 3 - Install the payleven app
Althought the payment is initiated in your app; the actual transaction takes place within the payleven app. For this reason, the payleven app must be installed on the mobile device you wish to use for accepting card payments.

######Step 4 - Purchase card reader
To accept card payments, you need to purchase a card reader. This is possible on our [website](https://payleven.co.uk/registration/?login=) during the registration or in your [payleven account](https://service.payleven.com/uk/ordermain) after registration. 
For testing purposes a card reader is not necessarily needed as the transaction flow can be tested using another payment methods: e.g. cash.

### Installation


##### Manual Set-Up

1. Drag *PaylevenAppApi.framework* into your Xcode project.

2. Open the *Info.plist* and add the following entries:

  * LSApplicationQueriesSchemes Array with String Entry "payleven"

3. Import PaylevenAppApi into your files:

        #import <PaylevenAppApi/PaylevenAppApi.h>


#### Getting started 

##### Bluetooth pairing
Before proceeding with the integration and testing, make sure you have paired the card reader in the bluetooth settings on your iOS device.
 1. Make sure the device is charged and turned on.
 2. Press '0' key on the card reader for 5 sec and make sure the card reader has entered the pairing mode (there will be a corresponding sign on the screen).
 3. Go to the bluetooth settings of your iOS device and turn on bluetooth.
 4. Inside the payleven app select the "discovered" payleven card reader and follow the instructions on both devices to finish the pairing process.
   
##### Setup your app
Use API key received from payleven together with your callback URL scheme to setup your app. 
Before doing payments you need to configure the API. In the following example replace yourapikey and yoururlscheme.
 ```c
[[PaylevenAppApi sharedInstance] configure:@"yourapikey" callbackUrlScheme:@"yoururlscheme"];

 ```

In your app's App Delegate make sure you implement its openURL method to make sure your receive payleven's responses properly
 ```c
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url 
sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [[PaylevenAppApi sharedInstance] handleOpenUrl:url bundleId:sourceApplication];
    return YES;
} 
 ```

##### Start payment
Below you see an example payment call to open the payleven app with an amount of 1€, your custom order ID “unique_id_101”, a dummy description and no product picture. The payleven app is going to launch with the payment input screen setup with the values you provided. To ensure a stable flow these values cannot be changed in the payleven app anymore, however you cancel the payment and you will jump back to your app.

 ```c
[[PaylevenAppApi sharedInstance] payWithPayleven:self 
                                                amount:100 
                                                currency:PC_EUR 
                                                orderId:@"unique_id_101"
                                                description:@"dummy description" 
                                                image:nil];
 ```
  
##### Open Transaction History 
To view transaction history you have to call the openTransactionHistory: method. Below you see an example transaction history call to open the payleven App at the transaction history view.

 ```c
[[PaylevenAppApi sharedInstance] openTransactionHistory:self];

 ```

##### Open Transaction Details (Refund)
To initiate a refund you have to call the openTransactionDetailsForRefund:orderId: method. Below you see an example call to open the payleven App at the transaction details view to initiate a refund.
 ```c
[[PaylevenAppApi sharedInstance] openTransactionDetailsForRefund:self orderId:@"unique_id_101"];

 ```


   
#### Documentation
[API Reference](http://payleven.github.io/Mobile-API-iOS-Internal/AppleDoc/)
