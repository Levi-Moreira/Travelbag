//
//  JoinViewController.swift
//  Travelbag
//
//  Created by ifce on 10/9/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit
import Firebase
import ARSLineProgress

class JoinViewController: UIViewController {

	@IBOutlet weak var inputEmail: UITextField!
	@IBOutlet weak var inputPassword: UITextField!
	@IBOutlet weak var inputConfirmPassword: UITextField!
	
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		
		inputEmail.layer.borderWidth = 1.0
		inputEmail.layer.borderColor = UIColor.white.cgColor
		
		inputPassword.layer.borderWidth = 1.0
		inputPassword.layer.borderColor = UIColor.white.cgColor
		
		inputConfirmPassword.layer.borderWidth = 1.0
		inputConfirmPassword.layer.borderColor = UIColor.white.cgColor
		
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.0, green: 0.3, blue: 0.5, alpha: 0.0)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	

	
	@IBAction func registerAccount(_ sender: Any) {
		
		if(inputPassword.text != inputConfirmPassword.text){
			//alertview\
			
			print("As Senhas não estao iguais")
			let alertController = UIAlertController(title: "Register Error", message:
				"Passwords are not the same", preferredStyle: .alert)
			let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
			alertController.addAction(okayAction)
			self.present(alertController, animated: true, completion: nil)
			
			return
			
		}else{
            ARSLineProgress.show()
			Auth.auth().createUser(withEmail: inputEmail.text!, password: inputPassword.text!, completion: { (user, error) in
				if let error = error {
					print("Login error: \(error.localizedDescription)")
				let alertController = UIAlertController(title: "Register Error", message: error.localizedDescription, preferredStyle: .alert)
                    
                    ARSLineProgress.hide()
					let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
					alertController.addAction(okayAction)
					self.present(alertController, animated: true, completion: nil)
					
                    
					return
				}
                ARSLineProgress.hide()
				self.performSegue(withIdentifier: "completeJoin", sender: "")
				print("Login Created")
			})
		}
		
		
		
	}
	

}
