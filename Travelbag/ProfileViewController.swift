//
//  ProfileViewController.swift
//  Travelbag
//
//  Created by ifce on 10/6/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet var inputUsername: UITextField!
    
    @IBOutlet var inputPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        inputUsername.layer.borderWidth = 1.0
        inputUsername.layer.borderColor = UIColor.white.cgColor
        
        inputPassword.layer.borderWidth = 1.0
        inputPassword.layer.borderColor = UIColor.white.cgColor
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
