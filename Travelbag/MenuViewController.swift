//
//  MenuViewController.swift
//  Travelbag
//
//  Created by IFCE on 06/10/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

	@IBOutlet weak var profileImageView: UIImageView!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

		let radius = self.profileImageView.frame.width / 2
		self.profileImageView.layer.cornerRadius = radius
		self.profileImageView.layer.masksToBounds = true
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
