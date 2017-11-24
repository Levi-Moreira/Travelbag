//
//  INterestOptionsTableViewController.swift
//  Travelbag
//
//  Created by ifce on 23/10/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit

class INterestOptionsTableViewController: UITableViewController {

    var interestOptionDelegate :InterestOptionsDelegate?
    var options = [InterestOptions]()
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            if(options.contains(InterestOptions.hosting)){
                options.removeAll(InterestOptions.hosting)
            }else{
               options.append(InterestOptions.hosting)
            }
        case 1:
            if(options.contains(InterestOptions.transport)){
                options.removeAll(InterestOptions.transport)
            }else{
                options.append(InterestOptions.transport)
            }
        case 2:
            if(options.contains(InterestOptions.group)){
                options.removeAll(InterestOptions.group)
            }else{
                options.append(InterestOptions.group)
            }
        default:
            return
        }
    }
    
    
    @IBAction func didTapSave(_ sender: UIBarButtonItem) {

        if options.count == 0{
            presentErrorDialog()
        }else{
                 self.navigationController?.popViewController(animated: true)
        interestOptionDelegate?.didSelectInterestOption(options: options)
        }
    }
    
    func presentErrorDialog(){
        
            let alertController = UIAlertController(title: "Attention", message: "Please, pick at least one interest", preferredStyle: .alert)
        
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
    }
    
}

protocol InterestOptionsDelegate{
    func didSelectInterestOption(options: [InterestOptions])
}
