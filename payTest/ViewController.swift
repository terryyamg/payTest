//
//  ViewController.swift
//  payTest
//
//  Created by Terry Yang on 2018/6/13.
//  Copyright © 2018年 com.terryyamg. All rights reserved.
//

import UIKit
import BraintreeDropIn
import Braintree

class ViewController: UIViewController {

    @IBOutlet weak var btnShow: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchClientToken() {
        self.btnShow.isEnabled = false
        self.indicator.isHidden = false
        // TODO: Switch this URL to your own authenticated API
        let clientTokenURL = NSURL(string: "https://braintree-sample-merchant.herokuapp.com/client_token")!
        let clientTokenRequest = NSMutableURLRequest(url: clientTokenURL as URL)
        clientTokenRequest.setValue("text/plain", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: clientTokenRequest as URLRequest) { (data, response, error) -> Void in
            // TODO: Handle errors
            let clientToken = String(data: data!, encoding: String.Encoding.utf8)
            print("clientToken:\(clientToken!)")
            self.showDropIn(clientTokenOrTokenizationKey: clientToken!)
            self.btnShow.isEnabled = true
            self.indicator.isHidden = true
            // As an example, you may wish to present Drop-in at this point.
            // Continue to the next section to learn more...
            }.resume()
    }

    @IBAction func jumpDropIn(_ sender: UIButton) {
        fetchClientToken()
    }
    
    
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request) { (controller, result, error) in
            if (error != nil) {
                print("ERROR:\(error.debugDescription)")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                // Use the BTDropInResult properties to update your UI
                print("result paymentOptionType:\(result.paymentOptionType)")
                print("result paymentMethod:\(result.paymentMethod.debugDescription)")
                print("result paymentIcon:\(result.paymentIcon)")
                print("result paymentDescription:\(result.paymentDescription)")
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
}

