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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.navigationController?.popViewController(animated: true)
            interestOptionDelegate?.didSelectInterestOption(option: .hosting)
        case 1:
self.navigationController?.popViewController(animated: true)
interestOptionDelegate?.didSelectInterestOption(option: .transport)
        case 2:

       self.navigationController?.popViewController(animated: true)
       interestOptionDelegate?.didSelectInterestOption(option: .group)
        default:
            return
        }
    }

}

protocol InterestOptionsDelegate{
    func didSelectInterestOption(option: InterestOptions)
}
