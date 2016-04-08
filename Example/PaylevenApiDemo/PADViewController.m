//
//  PADViewController.m
//  PaylevenApiDemo
//
//  Created by Steffen Römer on 10/8/12.
//  Copyright (c) 2012, 2013 Payleven Holding GmbH. All rights reserved.
//

#import "PADViewController.h"
#import "PaylevenAppApi/PaylevenAppApi.h"

@interface PADViewController () <PaylevenPaymentDelegate>

- (IBAction)payWithPaylevenPressed:(id)sender;
- (IBAction)openTransactionHistoryPressed:(id)sender;
- (IBAction)openSalesTransactionDetailsPressed:(id)sender;
- (IBAction)newOrderIdPressed:(id)sender;
- (IBAction)startRefundPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView* scrollView;
@property (weak, nonatomic) IBOutlet UITextField* paymentPrice;
@property (weak, nonatomic) IBOutlet UITextField* paymentDescription;
@property (weak, nonatomic) IBOutlet UITextField* paymentOrderId;
@property (weak, nonatomic) IBOutlet UIImageView *paymentImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView* paymentIndicator;
@property (weak, nonatomic) IBOutlet UITextField* refundOrderId;
@property (strong, nonatomic) IBOutlet UITextField* transactionDetailsOrderId;
@property (nonatomic,strong) UIImage * productImage;

@property CGPoint scrollViewOffset;
@end

@implementation PADViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self generateRandomOrderId];
    [self.paymentIndicator setHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setPaymentPrice:nil];
    [self setPaymentDescription:nil];
    [self setPaymentOrderId:nil];
    [self setRefundOrderId:nil];
    [self setScrollView:nil];
    [self setPaymentIndicator:nil];
    [self setTransactionDetailsOrderId:nil];
    [super viewDidUnload];
}

- (void)generateRandomOrderId
{
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    NSString* uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    NSString* trimmedUuidString = [uuidString substringWithRange:NSMakeRange(0, 10)];
    CFRelease(newUniqueId);
    
    [self.paymentOrderId setText:trimmedUuidString];
    [self.refundOrderId setText:trimmedUuidString];
    [self.transactionDetailsOrderId setText:trimmedUuidString];
    
    if ( self.paymentDescription.text == nil || [self.paymentDescription.text isEqualToString:@""] )
    {
        NSString* description = @"DummyDescription";
        [self.paymentDescription setText:description];
    }
}

- (IBAction)payWithPaylevenPressed:(id)sender
{
    NSString* orderIdText = self.paymentOrderId.text;
    NSString* description = self.paymentDescription.text;
    if ( orderIdText == nil )
    {
        [self generateRandomOrderId];
        description = self.paymentDescription.text;
        orderIdText = self.paymentOrderId.text;
    }
    
    NSString* amount = self.paymentPrice.text;
    NSUInteger iAmount = 0;
    if ((amount == nil) || [amount isEqualToString:@""] )
    {
        amount = @"0";
        [self.paymentPrice setText:@"0"];
        amount = self.paymentPrice.text;
    }
    iAmount = [amount integerValue];
    [self.paymentPrice setText:[NSString stringWithFormat:@"%d", iAmount]];
    
    BOOL paymentStarted = [[PaylevenAppApi sharedInstance] payWithPayleven:self
                                                                    amount:iAmount
                                                                  currency:PC_EUR // change currency here, if your payleven account is not a EUR account
                                                                   orderId:orderIdText
                                                               description:description
                                                                     image:self.productImage
                                                                 printerIp:@""]; // change it to something like @"192.168.1.3", if you have a Epson TM-T88V connected at that address
    
    if ( !paymentStarted )
    {
        NSString* errorMessage = @"Payment could not be started check your input values.";
        if ( [[PaylevenAppApi sharedInstance] isPaymentPending] )
        {
            errorMessage = @"Payment in progress please cancel or finish it first";
        }
        [self showErrorAlert:errorMessage];
    }
    else
    {
        [self.paymentIndicator setHidden:NO];
        [self.paymentIndicator startAnimating];
        [self.paymentIndicator setHidesWhenStopped:YES];
    }
}

- (IBAction)openTransactionHistoryPressed:(id)sender
{
    [[PaylevenAppApi sharedInstance] openTransactionHistory:self];
}

- (IBAction)openSalesTransactionDetailsPressed:(id)sender
{
    NSString* orderId = self.transactionDetailsOrderId.text;
    [[PaylevenAppApi sharedInstance] openTransactionDetails:self orderId:orderId];
}

- (IBAction)newOrderIdPressed:(id)sender
{
    [self generateRandomOrderId];
}

- (IBAction)addImagePressed:(UIButton*)sender {
    if([sender.titleLabel.text isEqualToString:@"Add Img"]){
        [sender setTitle:@"Rmv Img" forState:UIControlStateNormal];
        
        self.productImage = [UIImage imageNamed:@"rafael-otero.jpg"];
        self.paymentImageView.image = self.productImage;
    }else{
        self.productImage = nil;
        [sender setTitle:@"Add Img" forState:UIControlStateNormal];
        self.paymentImageView.image = nil;
    }
}

- (IBAction)startRefundPressed:(id)sender
{
    NSString* orderId = self.refundOrderId.text;
    [[PaylevenAppApi sharedInstance] openTransactionDetailsForRefund:self orderId:orderId];
}

#pragma mark scroll view
- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    self.scrollViewOffset = self.scrollView.contentOffset;
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:self.scrollView];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 60;
    [self.scrollView setContentOffset:pt animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [self.scrollView setContentOffset:self.scrollViewOffset animated:YES];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - PaylevenPaymentDelegate
- (void)paylevenPaymentDidFailWithError:(NSError*)error
                             parameters:(NSDictionary*)parameters
{
    [self showErrorAlert:[NSString stringWithFormat:@"paylevenPaymentDidFailWithError: %@\n\n with parameters: %@", [error localizedDescription], [parameters description]]];
    [self.paymentIndicator stopAnimating];
}

- (void)paylevenPaymentFinished:(NSDictionary*)parameters
{
    [self showErrorAlert:[NSString stringWithFormat:@"paylevenPaymentFinished with parameters: %@", [parameters description]]];
    [self.paymentIndicator stopAnimating];
}

- (void)paylevenPaymentCanceled:(NSDictionary*)parameters
{
    [self showErrorAlert:[NSString stringWithFormat:@"paylevenPaymentCanceled with parameters: %@", [parameters description]]];
    [self.paymentIndicator stopAnimating];
}

- (void)paylevenPaymentDeclined:(NSDictionary*)parameters
{
    [self showErrorAlert:[NSString stringWithFormat:@"paylevenPaymentDeclined with parameters: %@", [parameters description]]];
    [self.paymentIndicator stopAnimating];
}

- (void)paylevenRefundFinished:(NSDictionary*)parameters
{
    [self showErrorAlert:[NSString stringWithFormat:@"paylevenRefundFinished with parameters: %@", [parameters description]]];
}

- (void)paylevenTransactionNotFound:(NSString*)orderId
{
    [self showErrorAlert:@"paylevenTransactionNotFound"];
}

- (void)paylevenRefundCanceled:(NSString*)orderId
{
    [self showErrorAlert:@"paylevenRefundCanceled"];
}

- (void)paylevenRefundDidFailWithError:(NSError*)error
                            parameters:(NSDictionary*)parameters
{
    [self showErrorAlert:[NSString stringWithFormat:@"paylevenRefundDidFailWithError with parameters: %@", [parameters description]]];
}

- (void)paylevenTransactionDetailsCanceled:(NSString*)orderId
{
    [self showErrorAlert:@"paylevenTransactionDetailsCanceled"];
}

- (void)paylevenTransactionDetailsFailWithError:(NSError*)error
                                     parameters:(NSDictionary*)parameters
{
    [self showErrorAlert:[NSString stringWithFormat:@"paylevenTransactionDetailsFailWithError: %@\n\n and parameters: %@", [error localizedDescription], [parameters description]]];
}

- (void)paylevenSalesHistoryCanceled:(NSString*)orderId
{
    [self showErrorAlert:@"paylevenSalesHistoryCanceled"];
}

#pragma mark Error Alert
- (void)showErrorAlert:(NSString*)errorMessage
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"payleven"
                                                    message:errorMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end