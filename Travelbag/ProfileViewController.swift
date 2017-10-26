//
//  ProfileViewController.swift
//  Travelbag
//
//  Created by ifce on 10/6/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import ARSLineProgress

class ProfileViewController: UIViewController {

    @IBOutlet var inputUsername: UITextField!
    
    @IBOutlet var inputPassword: UITextField!
    
    @IBOutlet var loginFacebookButton: FBSDKLoginButton!
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            presentHome()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        FirebaseApp.configure()



    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.0, green: 0.3, blue: 0.5, alpha: 0.0)
        inputUsername.layer.borderWidth = 1.0
        inputUsername.layer.borderColor = UIColor.white.cgColor
        
        inputPassword.layer.borderWidth = 1.0
        inputPassword.layer.borderColor = UIColor.white.cgColor
        
    
        inputUsername.text = "levi.m.albuquerque@gmail.com"
        inputPassword.text = "levi1110"
       
    }
	

    func presentHome(){
        let storyboard = UIStoryboard(name: "Menu", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Menu") as UIViewController
        
        self.present(controller, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func didTabFacebookLoginButton(_ sender: UIButton) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self){ (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            ARSLineProgress.show()
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                ARSLineProgress.hide()
                self.presentHome()
                
            })


        }
    }
    
    
    @IBAction func didTapLoginButton(_ sender: UIButton) {
        
        let username = inputUsername.text!
        let password = inputPassword.text!
        
        ARSLineProgress.show()
        Auth.auth().signIn(withEmail: username, password: password) { (user, error) in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
            
            ARSLineProgress.hide()
            self.presentHome()
        }
    }
    



}
