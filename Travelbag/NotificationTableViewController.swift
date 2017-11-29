//
//  NotificationTableViewController.swift
//  Travelbag
//
//  Created by ifce on 28/11/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit

struct cellNotification {
    let cell: Int!
    let name: String!
    let time: String!
    let cnotification: String!
    let img: UIImage!
}

class NotificationTableViewController: UITableViewController {

    var arrayNotification = [cellNotification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayNotification = [cellNotification(cell: 0, name: "John Lennon", time: "2 hours ago", cnotification: "He goes to London", img: #imageLiteral(resourceName: "John Lennon.jpg") )]
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayNotification.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if arrayNotification[indexPath.row].cell == 0 {
            
            let cell = Bundle.main.loadNibNamed("CNotification", owner: self, options: nil)?.first as! CNotification
            
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height/2
            cell.imgProfile.clipsToBounds = true
            cell.imgProfile.image = arrayNotification[indexPath.row].img
            cell.cnotification.text = arrayNotification[indexPath.row].cnotification
            cell.name.text = arrayNotification[indexPath.row].name
            cell.time.text = arrayNotification[indexPath.row].time
            
            return cell
            
        } else {
            let cell = Bundle.main.loadNibNamed("CNotification", owner: self, options: nil)?.first as! CNotification
            
            cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height/2
            cell.imgProfile.clipsToBounds = true
            cell.imgProfile.image = arrayNotification[indexPath.row].img
            cell.cnotification.text = arrayNotification[indexPath.row].cnotification
            cell.name.text = arrayNotification[indexPath.row].name
            cell.time.text = arrayNotification[indexPath.row].time
            
            return cell
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 66
        }
        else {
            return 66
        }
    }
    
    
}
