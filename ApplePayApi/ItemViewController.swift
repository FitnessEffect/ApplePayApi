//
//  ItemViewController.swift
//  ApplePayApi
//
//  Created by Stefan Auvergne on 9/16/17.
//  Copyright © 2017 com.example. All rights reserved.
//

import UIKit
import PassKit

class ItemViewController: UIViewController {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var applePayButton: UIButton!
    
    var itemPassed:Item!
    let shippingPrice: NSDecimalNumber = NSDecimalNumber(string: "5.0")
    
    struct ShippingMethod {
        let price: NSDecimalNumber
        let title: String
        let description: String
        
        init(price: NSDecimalNumber, title: String, description: String) {
            self.price = price
            self.title = title
            self.description = description
        }
        
        static let ShippingMethodOptions = [
            ShippingMethod(price: NSDecimalNumber(string: "5.00"), title: "Carrier Pigeon", description: "You'll get it someday."),
            ShippingMethod(price: NSDecimalNumber(string: "100.00"), title: "Racecar", description: "Vrrrroom! Get it by tomorrow!"),
            ShippingMethod(price: NSDecimalNumber(string: "9000000.00"), title: "Rocket Ship", description: "Look out your window!"),
            ]
    }
    
    let SupportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
    let ApplePaySwagMerchantID = "merchant.com.gmail.ApplePayApi" // Fill in your merchant ID here!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemName.text = itemPassed.name
        itemPrice.text = "$" + String(itemPassed.price)
        applePayButton.isHidden = !PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: SupportedPaymentNetworks)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setItem(item:Item){
        itemPassed = item
    }
    
    
    @IBAction func purchase(_ sender: UIButton) {
        let request = PKPaymentRequest()
        request.merchantIdentifier = ApplePaySwagMerchantID
        request.supportedNetworks = SupportedPaymentNetworks
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Item", amount: NSDecimalNumber(integerLiteral: itemPassed.price)),
            PKPaymentSummaryItem(label: "Shipping", amount: shippingPrice),
            PKPaymentSummaryItem(label: "Stefan", amount: NSDecimalNumber(integerLiteral: (itemPassed.price + Int(truncating: shippingPrice))))
        ]
        request.requiredShippingAddressFields = PKAddressField.postalAddress
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
        applePayController?.delegate = self
        self.present(applePayController!, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ItemViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping ((PKPaymentAuthorizationStatus) -> Void)) {
        completion(PKPaymentAuthorizationStatus.success)
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
