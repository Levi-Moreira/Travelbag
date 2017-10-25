//
//  Post.swift
//  Travelbag
//
//  Created by ifce on 18/10/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase




class Post: FirebaseBaseModel{
    var latitude: Double?
    var longitude: Double?
    var date: String?
    var interest: String?
    var image: FirebaseImage?
    var uid : String?
    var content: String?
    var share_gas: Bool = false
    var share_group: Bool = false
    var share_host: Bool = false
    
    override func toDic() -> [String : Any]{
        var dic = [String:Any]()
        dic["latitude"] = self.latitude
        dic["longitude"] = self.longitude
        dic["date"] = ServerValue.timestamp()
        dic["owner"] = self.uid
        dic["text"] = self.content
        dic["share_gas"] = self.share_gas
        dic["share_group"] = self.share_group
        dic["share_host"] = self.share_host
        dic["image"] = ""
        return dic
    }
}
