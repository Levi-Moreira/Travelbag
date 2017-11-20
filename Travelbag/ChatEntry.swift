//
//  ChatEntry.swift
//  Travelbag
//
//  Created by ifce on 13/11/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import Foundation


class ChatEntry: FirebaseBaseModel{
    
    
    override func toDic() -> [String : Any] {
        var dic = [String:Any]()
        dic["first_user_uid"] = self.firstUserUID
        dic["second_user_uid"] = self.secondUserUID
        dic["first_user_name"] = self.firstUserName
        dic["second_user_name"] = self.secondUserName
        dic["last_message"] = self.lastMessage
        dic["last_message_date"] = self.lastMessageDate
        dic["first_user_image"] = self.firstUserImage
        dic["second_user_image"] = self.secondUserImage
        return dic
    }
    
    override init() {
        
    }
    
    init(with json: [String : Any]) {
        self.firstUserUID = json["first_user_uid"] as? String
        self.secondUserUID = json["second_user_uid"] as? String
        self.firstUserName = json["first_user_name"] as? String
        self.secondUserName = json["second_user_name"] as? String
        self.lastMessage = json["last_message"] as? String
        self.lastMessageDate = json["last_message_date"] as? String
        self.firstUserImage = json["first_user_image"] as? String
        self.secondUserImage = json["second_user_image"] as? String
        
    }
    
    
    var firstUserUID: String?
    var secondUserUID: String?
    
    var firstUserName: String?
    var secondUserName: String?
    
    var lastMessage: String?
    
    var lastMessageDate: String?
    
    var firstUserImage: String?
    var secondUserImage: String?

}
