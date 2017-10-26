//
//  PostOptionsTableViewCell.swift
//  Travelbag
//
//  Created by ifce on 18/10/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit

class PostOptionsTableViewCell: UITableViewCell {

    @IBOutlet var optionIcon: UIImageView!
    
    @IBOutlet var optionText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
