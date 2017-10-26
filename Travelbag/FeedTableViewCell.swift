//
//  FeedTableViewCell.swift
//  Travelbag
//
//  Created by IFCE on 18/10/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
	@IBOutlet weak var profilePhoto: UIImageView!
	@IBOutlet weak var nameUser: UILabel!
	@IBOutlet weak var locationUser: UILabel!
	@IBOutlet weak var timeAgo: UILabel!
	@IBOutlet weak var textPost: UILabel!
	@IBOutlet weak var imagePost: UIImageView!
	@IBOutlet weak var constraintHeight: NSLayoutConstraint!
	
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
