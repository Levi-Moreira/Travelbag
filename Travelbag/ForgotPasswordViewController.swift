//
//  ForgotPasswordViewController.swift
//  Travelbag
//
//  Created by ifce on 10/9/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    @IBOutlet var emailInput: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        emailInput.layer.borderWidth = 1.0
        emailInput.layer.borderColor = UIColor.white.cgColor
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    

    @IBAction func didTapSendEmailReset(_ sender: UIButton) {
        
        
        let email = emailInput.text!
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            if error != nil {
                print("Deuerror")
            }
            
            self.navigationController?.popToRootViewController(animated: true)
            
        }
    }


}
