//
//  ProfileSettingsTableViewController.swift
//  Travelbag
//
//  Created by IFCE on 26/10/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Nuke
import ImagePicker
import ARSLineProgress

class ProfileSettingsTableViewController: UITableViewController, ImagePickerDelegate {
    
    var profileIsTrue: Bool!
    
    var profile: Profile?

    
    var ref: DatabaseReference!
    var user = Auth.auth().currentUser
    
    let imagePickerController = ImagePickerController()
    
    @IBOutlet weak var saveSettingsButton: UIBarButtonItem!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var inputFirstName: UITextField!
    @IBOutlet weak var inputLastName: UITextField!
    @IBOutlet weak var inputGender: UITextField!
    @IBOutlet weak var inputBio: UITextField!
    
    
    @IBAction func didTapChangeProfilePhoto(_ sender: Any) {
        self.profileIsTrue = true
        present(imagePickerController, animated: true, completion: nil)
        
    }
    @IBAction func didTapChangeCoverPhoto(_ sender: Any) {
        self.profileIsTrue = false
        present(imagePickerController, animated: true, completion: nil)
    
    }
    
    @IBAction func didTapSaveProfileSettings(_ sender: Any) {
        
        if inputFirstName.isEmpty {
            presentErrorDialog(message: "Add first name")
        } else {
        self.ref.child("users_profile").child("\(user!.uid)/first_name").setValue(inputFirstName.text)
        }
        if inputLastName.isEmpty {
            presentErrorDialog(message: "Add last name")
        } else {
        self.ref.child("users_profile").child("\(user!.uid)/last_name").setValue(inputLastName.text)
        }
        if inputGender.isEmpty {
            presentErrorDialog(message: "Add Gender")
        }else {
        self.ref.child("users_profile").child("\(user!.uid)/gender").setValue(inputGender.text)
        }

        self.ref.child("users_profile").child("\(user!.uid)/bio").setValue(inputBio.text)
     
        if let image = self.profile?.profile_holder {
            image.save(withResouceType: "users_profile", withParentId: (user?.uid)!, withName: "profile.jpg", withPathName: "profile_picture", completionHandler: ({ (erro, snapshot) in
                if erro != nil{
                    self.presentErrorDialog(message: (erro?.localizedDescription)! )
                }
            }))
        }
        
        
        if let image = self.profile?.cover_photo_holder{
            image.save(withResouceType: "users_profile", withParentId: (user?.uid)!, withName: "cover.jpg", withPathName: "cover_photo", completionHandler: ({ (erro, snapshot) in
                if erro != nil{
                    self.presentErrorDialog(message: (erro?.localizedDescription)! )
                }
            }))
        }

        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ARSLineProgress.show()
        
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        
        saveSettingsButton.isEnabled = false
        
        ref = Database.database().reference()
        getProfile() {(profile) in
            self.inputFirstName.text = profile?.first_name ?? ""
            self.inputLastName.text = profile?.last_name ?? ""
            self.inputGender.text = profile?.gender ?? ""
            self.inputBio.text = profile?.bio ?? ""
 
            
            if let url = profile?.profile_picture {
                if url.isValidHttpsUrl {
                    Nuke.loadImage(with: URL(string: url)!, into: self.profileImage)
                }
            }
            
            if let url = profile?.cover_photo {
                if url.isValidHttpsUrl{
                    //Nuke.loadImage(with: URL(string: url)!, into: self.coverImage)
                    if let data = try? Data(contentsOf: URL(string: url)!)
                    {
                        self.coverImage.image = UIImage(data: data)
                        
                    }
                
                }
                
            }
         
            self.saveSettingsButton.isEnabled = true
            ARSLineProgress.hide()
            
            self.tableView.reloadData()
            
        }
 
   
    }


    func getProfile(completionHandler: @escaping (Profile?) -> Void) {
        
        ref.child("users_profile").child(user!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let json = snapshot.value as? [String : AnyObject] ?? [:]
            self.profile = Profile(with: json)

            completionHandler(self.profile)
            
        }) { (error) in
            print(error.localizedDescription)
        }
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
    
    func publishImage(image: UIImage) {
        if profileIsTrue {
            profileImage.image = image
            
            self.profile?.profile_holder = FirebaseImage(image: image)
            
            self.tableView.reloadData()
        } else {
            coverImage.image = image
            
            self.profile?.cover_photo_holder = FirebaseImage(image: image)
            
            self.tableView.reloadData()
            
        }
    }
    
    func presentErrorDialog(message: String){
        
        let alertController = UIAlertController(title: "Attention", message: message, preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
}
