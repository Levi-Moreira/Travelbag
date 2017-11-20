//
//  ChatListTableViewCell.swift
//  Travelbag
//
//  Created by IFCE on 13/11/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit

class ChatListTableViewCell: UITableViewCell {

    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var lastMessageUser: UILabel!
    @IBOutlet weak var lastMessageDateUser: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
