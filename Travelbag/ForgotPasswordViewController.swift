//
//  ForgotPasswordViewController.swift
//  Travelbag
//
//  Created by ifce on 10/9/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit
import FirebaseAuth
import ARSLineProgress


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
        
        if(email.isValidEmail()){
            ARSLineProgress.show()
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                
                if error != nil {
                    print("Deuerror")
                }
                
                ARSLineProgress.hide()
                ARSLineProgress.showSuccess()
            }
        }else{
            let alertController = UIAlertController(title: "Email error", message: "Please, type in a valid e-mail address", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

}

extension String{
    func isValidEmail() -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}
