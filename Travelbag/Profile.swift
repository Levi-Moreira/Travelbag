//
//  User.swift
//  Travelbag
//
//  Created by ifce on 30/10/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import Foundation
class Profile: FirebaseBaseModel{
    
    var first_name : String?
    var last_name: String?
    var latitude: Double?
    var longitude: Double?
    var dob: String?
    var profile_holder: FirebaseImage?
    var profile_picture: String?
    var cover_photo_holder: FirebaseImage?
    var cover_photo: String?
    var uid: String?
    
    override init(){
        
    }
    
    init(with json: [String : Any]) {
        self.first_name = json["first_name"] as? String
        self.last_name = json["last_name"] as? String
        self.latitude = json["latitude"] as? Double
        self.longitude = json["longitude"] as? Double
        self.dob = json["dob"] as? String
        self.profile_picture = json["profile_picture"] as? String
        self.cover_photo = json["cover_photo"] as? String
        self.uid = json["uid"] as? String
    }
    
    override func toDic() -> [String : Any] {
        var dic = [String:Any]()
        dic["first_name"] = self.first_name
        dic["last_name"] = self.last_name
        dic["latitude"] = self.latitude
        dic["longitude"] = self.longitude
        dic["profile_picture"] = ""
        dic["cover_photo"] = ""
        dic["dob"] = self.dob
        dic["uid"] = self.uid
        
        return dic
    }
    
    
}
