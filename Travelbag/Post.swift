//
//  Post.swift
//  Travelbag
//

import Foundation
import UIKit
import FirebaseDatabase


import Foundation

import UIKit
import FirebaseDatabase

var ref: DatabaseReference  {
	return Database.database().reference()
}

class Post: FirebaseBaseModel{
    var latitude: Double?
    var longitude: Double?
    var date: Double?
    var interest: String?
    var image_holder: FirebaseImage?
    var image: String?
    var content: String?
    var owner: String?
    var share_gas: Bool = false
    var share_group: Bool = false
    var share_host: Bool = false
    var user_first_name: String?
	var user_last_name: String?
    var post_date: Double?
    var uid: String?
	var user_image_profile: String?
    
    init(with json: [String : Any]) {
        self.date = json["date"] as? Double
        self.image = json["image"] as? String
        self.uid = json["uid"] as? String
        self.latitude = json["latitude"] as? Double
        self.longitude = json["longitude"] as? Double
        self.share_gas = json["share_gas"] as! Bool
        self.share_host = json["share_host"] as! Bool
        self.share_group = json["share_group"] as! Bool
        self.content = json["text"] as? String
        self.post_date = json["post_date"] as? Double
        self.user_first_name = json["user_first_name"] as? String
		self.user_last_name = json["user_last_name"] as? String
		self.user_image_profile = json["user_image_profile"] as? String
        
    }
    override init() {}
    
    @discardableResult func saveTo() -> String {
        let key = self.databaseRef.child("posts").childByAutoId().key
        databaseRef.child("posts").child(key).setValue(toDic())
        return key
    }

    
    override func toDic() -> [String : Any]{
        var dic = [String:Any]()
        dic["latitude"] = self.latitude
        dic["longitude"] = self.longitude
        dic["date"] = self.date
        dic["uid"] = self.uid
        dic["text"] = self.content
        dic["share_gas"] = self.share_gas
        dic["share_group"] = self.share_group
        dic["share_host"] = self.share_host
        dic["user_first_name"] = self.user_first_name
		dic["user_last_name"] = self.user_last_name
        dic["image"] = ""
        dic["post_date"] = ServerValue.timestamp()
		dic["user_image_profile"] = self.user_image_profile

        return dic
    }
    
}

extension Post {
    var timeToNow : String? {
        guard let timeStamp = self.post_date else { return nil }
        
        guard let createdInterval = TimeInterval(exactly: timeStamp/1000) else {return nil}
        let interval = Date().timeIntervalSince(Date(timeIntervalSince1970: createdInterval)).int
        let minutes = (interval/60)
        
        if minutes > 59{
            let hours = (interval/60)/60
			
			if hours < 24 {
				 return "\(hours) Hours Ago"
			}else{
				let date = Date(timeIntervalSince1970: createdInterval)
				return date.dateString(ofStyle: .medium)
			}
        }
        
        return "\(minutes) Min Ago"
    }
    
}
public struct User {
    
    let uid: String
    var firstName: String?
    var lastName: String?
	var imageUser: String?
	
    
	init(uid: String, firstName: String? = nil, lastName: String? = nil, imageUser: String? = nil) {
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
		self.imageUser = imageUser
    }
    
    func getNameProfile(completion: @escaping (_ name: String) -> Void) {
        let profile = Database.database().reference().child("user_profile").child(self.uid)
        
        profile.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let arrayDataSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            let userReference = arrayDataSnapshot.first
            guard let userName = userReference?.value as? String else {
                print("Empty")
                return
            }
            completion(userName)
        })
    }
}

