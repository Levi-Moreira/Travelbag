//
//  ChangeEmailViewController.swift
//  
//
//  Created by IFCE on 27/10/17.
//

import UIKit
import FirebaseAuth
import ARSLineProgress

class ChangeEmailViewController: UIViewController {
    
    var user = Auth.auth().currentUser
    var credential: AuthCredential!
    
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var inputNewEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputPassword.becomeFirstResponder()
    }
    
    @IBAction func didTapSaveChangeEmail(_ sender: Any) {
        
        ARSLineProgress.show()
        
        let credential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: inputPassword.text!)
        
        user?.reauthenticate(with: credential) { error in
            if let error = error {
                
                let alertController = UIAlertController(title: "Register Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                ARSLineProgress.hide()
            } else {
                self.changeEmail()
            }
        }
        

    }


    func changeEmail (){
        
        
        Auth.auth().currentUser?.updateEmail(to: inputNewEmail.text!) { (error) in
            if let error = error {
                ARSLineProgress.hide()

                print("Login error: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "Register Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)

                return
                
            } else {
                ARSLineProgress.hide()
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        
    }


}

