//
//  Post.swift
//  Travelbag
//
//  Created by ifce on 18/10/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import Foundation
import UIKit




class Post: FirebaseBaseModel{
    var latitude: Double?
    var longitude: Double?
    var date: String?
    var interest: String?
    var image: FirebaseImage?
    var uid : String?
    var content: String?
    
    
    override func toDic() -> [String : Any]{
        var dic = [String:Any]()
        dic["latitude"] = self.latitude
        dic["longitude"] = self.longitude
        dic["date"] = self.date
        dic["interest"] = self.interest
        dic["uid"] = self.uid
        dic["content"] = self.content
        return dic
    }
}
