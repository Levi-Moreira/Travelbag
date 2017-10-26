//
//  Post.swift
//  Travelbag
//
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

	init(with json: [String : Any]) {
		self.date = json["date"] as? Double
		self.image = json["image"] as? String
		self.lat = json["latitude"] as? Double
		self.long = json["longitude"] as? Double
		self.owner = json["owner"] as? String
		self.share_gas = json["share_gas"] as? Bool
		self.share_host = json["share_host"] as? Bool
		self.share_group = json["share_host"] as? Bool
		self.text = json["text"] as? String

		}
    
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
