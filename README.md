# payleven Mobile API for iOS 1.2

[![CocoaPods](https://img.shields.io/badge/Platform-iOS-yellow.svg?style=flat-square)]()
[![CocoaPods](https://img.shields.io/badge/Requires-iOS%207+-blue.svg?style=flat-square)]()
[![CocoaPods](https://img.shields.io/badge/Made%20in-Berlin-red.svg?style=flat-square)]()

XXX DESCRIPTION XXX [websites](https://payleven.com/).

### Prerequisites
XXXX TO BE EDITED
1. Register with [payleven](http://payleven.com) in order to get personal merchant credentials and a card reader.
2. In order to receive an API key, please contact us by sending an email to developer@payleven.com.
XXXX EDITING ENDS
### Installation


##### Manual Set-Up

1. Drag *PaylevenAppApi.framework* into your Xcode project.

2. Open the *Info.plist* and add the following entries:

  * LSApplicationQueriesSchemes Array with String Entry "payleven"

3. Import PaylevenAppApi into your files:

        #import <PaylevenAppApi/PaylevenAppApi.h>


#### Getting started    
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
Below you see an example payment call to open the payleven app with an amount of 1€, your custom order ID “unique_id_101”, a dummy description and no product picture.

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

   
#### Documentation
[API Reference](http://payleven.github.io/Mobile-API-iOS-Internal/AppleDoc/)
