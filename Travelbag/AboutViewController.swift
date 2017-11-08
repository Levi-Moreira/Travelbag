//
//  File.swift
//  Travelbag
//
//  Created by IFCE on 01/11/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var aboutText: UITextView!
    
    override func viewDidAppear(_ animated: Bool) {
        if flagSettingsAbout.shared.termsIsTrue! {
            
        aboutText.text = "Terms"
            self.navigationController?.topViewController?.title = "Terms"
            
        } else {
            
        aboutText.text = "Privacy Policy"
            self.navigationController?.topViewController?.title = "Privacy"

            
        }
    }
    
}
