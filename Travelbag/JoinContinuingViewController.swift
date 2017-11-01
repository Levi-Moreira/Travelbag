//
//  JoinContinuingViewController.swift
//  Travelbag
//
//  Created by IFCE on 16/10/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import ARSLineProgress
import ImagePicker
import DatePickerDialog

class JoinContinuingViewController: UIViewController, ImagePickerDelegate {
    
    let imagePickerController = ImagePickerController()
    

	
	var ref: DatabaseReference!
	var firebaseUser = Auth.auth().currentUser

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet weak var inputFirstName: UITextField!
	@IBOutlet weak var inputLastName: UITextField!

	var profile = Profile()
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
		
		inputLastName.layer.borderWidth = 1.0
		inputLastName.layer.borderColor = UIColor.white.cgColor
		
		inputFirstName.layer.borderWidth = 1.0
		inputFirstName.layer.borderColor = UIColor.white.cgColor

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
    
        
		
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
	@IBAction func didTapRefresh(_ sender: Any) {
        
        guard let lastName = inputLastName.text else{
            return
        }
        
        guard let firstName = inputFirstName.text else{
            return
        }
        
        if firstName.isEmpty || lastName.isEmpty{
            return
        }
        
        profile.first_name = firstName
        profile.last_name = lastName
        
        if self.profile.profile_holder == nil{
            return
        }
        
         ARSLineProgress.show()
        var nodeId = profile.saveTo(node: "users_profile", with: (firebaseUser?.uid)!)
        
        
        if let image = self.profile.profile_holder{
            image.save(withResouceType: "users_profile", withParentId: nodeId, withName: "profile.jpg", withPathName: "profile_picture", completionHandler: { (error, snap) in
                if error != nil{
                    ARSLineProgress.hide()
                    print(error)
                }
                
                 ARSLineProgress.hide()
                self.presentHome()
            })
        }
        
	}
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        present(imagePickerController, animated: true, completion: nil)

    }
    
    func publishImage(image: UIImage) {
        profileImage.image = image
        
        self.profile.profile_holder = FirebaseImage(image: image)
        
       
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        if let image = images.first{
            self.publishImage(image: image)
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        if let image = images.first{
            self.publishImage(image: image)
            imagePicker.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    

    func presentHome(){
        let storyboard = UIStoryboard(name: "Menu", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Menu") as UIViewController
        
        self.present(controller, animated: true, completion: nil)
    }

}
