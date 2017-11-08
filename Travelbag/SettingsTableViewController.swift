//
//  SettingsTableViewController.swift
//  Travelbag
//
//  Created by IFCE on 26/10/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit
import FirebaseAuth


class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var pushNotificationsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
                if indexPath.row == 0{
            performSegue(withIdentifier: "editProfileSegue", sender: self)
            }
                if indexPath.row == 1{
            performSegue(withIdentifier: "editEmailSegue", sender: self)
            }
                if indexPath.row == 2{
           performSegue(withIdentifier: "editPasswordSegue", sender: self)
            }
            
        case 2:
            if indexPath.row == 0 {
                flagSettingsAbout.shared.termsIsTrue = false
                performSegue(withIdentifier: "aboutSegue", sender: self)

            }
            if indexPath.row == 1 {
                flagSettingsAbout.shared.termsIsTrue = true
                performSegue(withIdentifier: "aboutSegue", sender: self)
            }
        case 3:
            
            didTapLogOut()
            
        default:
        return
    }
    
}
    
    @IBAction func didTapChangePushNotificatios(_ sender: Any) {
        
        
        
    }
    
    func didTapLogOut(){
        
        
        let alertController = UIAlertController(title: "Log Out?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let okayAction = UIAlertAction(title: "Yes, I'm sure.", style: UIAlertActionStyle.default, handler: {
            alert -> Void in

            self.logOut()
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        
        alertController.addAction(okayAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    
        
    }

    func logOut(){
      
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing  out: %@", signOutError)
        }
        
        self.presentLogin()
        
    }
    
    func presentLogin(){
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Login") as UIViewController
        
        self.dismiss(animated: true, completion: nil)
        
    }
    

    
}
class flagSettingsAbout {
    static let shared = flagSettingsAbout()
    var termsIsTrue: Bool!
}
    

