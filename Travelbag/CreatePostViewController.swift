//
//  CreatePostViewController.swift
//  Travelbag
//
//  Created by ifce on 18/10/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit


class CreatePostViewController: UIViewController, PostOptionsDelegate {
    
    func pickInterest(completionHandler: @escaping (InterestOptions) -> Void) {
        performSegue(withIdentifier: "pickInterestSegue" , sender: self)
    }
    
 
    @IBOutlet var postImagePreview: UIImageView!
    
    func publishImage(image: UIImage) {
        postImagePreview.image = image
    }
    

    var optionsViewController : PostOptionsTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optionsViewController?.optionsDelegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postOptionsSegue"{
            optionsViewController = segue.destination as? PostOptionsTableViewController
        }
    }
}
