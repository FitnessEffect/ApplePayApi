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
    
    var cellNumber = 0

    @IBOutlet weak var item: UILabel!
    @IBOutlet weak var applePayButton: UIButton!
    
    let SupportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex]
    let ApplePaySwagMerchantID = "merchant.com.gmail.ApplePayApi" // Fill in your merchant ID here!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        item.text = "$" + String(cellNumber)
        applePayButton.isHidden = !PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: SupportedPaymentNetworks)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCellNumber(x:Int){
        cellNumber = x + 1
    }
    
    
    @IBAction func purchase(_ sender: UIButton) {
        let request = PKPaymentRequest()
        request.merchantIdentifier = ApplePaySwagMerchantID
        request.supportedNetworks = SupportedPaymentNetworks
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "user", amount: NSDecimalNumber(integerLiteral: cellNumber)),
            PKPaymentSummaryItem(label: "Stefan", amount: NSDecimalNumber(integerLiteral: cellNumber))
        ]
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
        self.present(applePayController, animated: true, completion: nil)
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
