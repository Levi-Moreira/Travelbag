//
//  ChangePasswordViewController.swift
//  
//
//  Created by IFCE on 27/10/17.
//

import UIKit
import FirebaseAuth
import ARSLineProgress

class ChangePasswordViewController: UIViewController {

    var user = Auth.auth().currentUser
    var credential: AuthCredential!
    
    @IBOutlet weak var inputOldPassword: UITextField!
    @IBOutlet weak var inputNewPassword: UITextField!
    @IBOutlet weak var inputConfirmNewPassword: UITextField!

    override func viewDidLoad() {
         super.viewDidLoad()
        
      inputOldPassword.becomeFirstResponder()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func didTapSaveChangePassword(_ sender: Any) {
        
        ARSLineProgress.show()
        
        let credential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: inputOldPassword.text!)
        
        user?.reauthenticate(with: credential) { error in
            if let error = error {
                
                let alertController = UIAlertController(title: "Register Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                ARSLineProgress.hide()
                
            } else {
                self.changePassword()
            }
        }
        
    }
        
        
    
    func changePassword() {
        
        if(inputNewPassword.text! != inputConfirmNewPassword.text!){
            
            ARSLineProgress.hide()
            
            print("Senhas n correspondem")
        
            let alertController = UIAlertController(title: "Register Error", message:
                "Passwords are not the same", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
            
            return
        } else{
            
            Auth.auth().currentUser?.updatePassword(to: inputNewPassword.text!) { (error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Register Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    ARSLineProgress.hide()
                    return
                    
                    
                } else {
                    ARSLineProgress.showSuccess()
                    self.navigationController?.popViewController(animated: true)
                    
                }
                
                
            }
            
        }
    }
    
}
