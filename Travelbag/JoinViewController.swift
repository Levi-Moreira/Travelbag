//
//  JoinViewController.swift
//  Travelbag
//
//  Created by ifce on 10/9/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit
import Firebase

class JoinViewController: UIViewController {

	@IBOutlet weak var inputFirstname: UITextField!
	@IBOutlet weak var inputLastname: UITextField!
	@IBOutlet weak var inputEmail: UITextField!
	@IBOutlet weak var inputPassword: UITextField!
	@IBOutlet weak var inputConfirmPassword: UITextField!
	
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		inputFirstname.layer.borderWidth = 1.0
		inputFirstname.layer.borderColor = UIColor.white.cgColor
		
		inputLastname.layer.borderWidth = 1.0
		inputLastname.layer.borderColor = UIColor.white.cgColor
		
		inputEmail.layer.borderWidth = 1.0
		inputEmail.layer.borderColor = UIColor.white.cgColor
		
		inputPassword.layer.borderWidth = 1.0
		inputPassword.layer.borderColor = UIColor.white.cgColor
		
		inputConfirmPassword.layer.borderWidth = 1.0
		inputConfirmPassword.layer.borderColor = UIColor.white.cgColor
		
		

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	override func viewWillAppear(_ animated: Bool) {
		
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.isTranslucent = true
		self.navigationController?.isNavigationBarHidden = false
		
		
	}
	
	@IBAction func registerAccount(_ sender: Any) {
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
