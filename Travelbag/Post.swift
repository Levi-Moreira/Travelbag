//
//  Post.swift
//  Travelbag
//


import Foundation

import UIKit
import FirebaseDatabase



class Post: FirebaseBaseModel{
    var latitude: Double?
    var longitude: Double?
    var date: String?
    var interest: String?
    var image_holder: FirebaseImage?
    var image: String?
    var user : Profile?
    var content: String?
    var share_gas: Bool? = false
    var share_group: Bool? = false
    var share_host: Bool? = false

    init(with json: [String : Any]) {
        self.date = json["date"] as? String
        self.image = json["image"] as? String
        self.latitude = json["latitude"] as? Double
        self.longitude = json["longitude"] as? Double
        
        if let userJson = json["owner"] as? [String : Any]{
            self.user = Profile(with: (userJson))
        }
        
        self.share_gas = json["share_gas"] as? Bool
        self.share_host = json["share_host"] as? Bool
        self.share_group = json["share_host"] as? Bool
        self.content = json["text"] as? String
    }
    
    override init() {
        
    }
    override func toDic() -> [String : Any]{
        var dic = [String:Any]()
        dic["latitude"] = self.latitude
        dic["longitude"] = self.longitude
        dic["date"] = self.date
        dic["owner"] = self.user?.toDic()
        dic["text"] = self.content
        dic["share_gas"] = self.share_gas
        dic["share_group"] = self.share_group
        dic["share_host"] = self.share_host
        dic["image"] = ""
        return dic
    }

}
