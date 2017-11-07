//
//  TableViewCell1.swift
//  Travelbag
//
//  Created by ifce on 27/10/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit

class TableViewCell1: UITableViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var statusUserLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var lbFollowers: UILabel!
    @IBOutlet weak var lbFollowing: UILabel!
    @IBOutlet weak var lbPlaces: UILabel!
    @IBOutlet weak var lbCountPlaces: UILabel!
    @IBOutlet weak var lbCountFollowing: UILabel!
    @IBOutlet weak var lbCountFollowers: UILabel!
    
    @IBOutlet weak var topSpaceConstraint: NSLayoutConstraint!
    
}
