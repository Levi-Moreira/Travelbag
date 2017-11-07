//
//  UserManager.swift
//  Travelbag
//
//  Created by IFCE on 31/10/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import Foundation
import Firebase

public class UserManager {
    static let shared = UserManager()
    var user: User?
    
    static func getUser(completion: @escaping (_ user: User) -> Void) {
        if let uid = Auth.auth().currentUser?.uid {
            Database.database().reference().child("users_profile").child(uid).observeSingleEvent(of: .value, with: { snapshot in
                guard let json = snapshot.value as? NSDictionary else { return }
                guard let firstName = json["first_name"] as? String else {
                    return print("Nome n existe")
                }
                guard let lastName = json["last_name"] as? String else {
                    return print("Ultimo nome n existe")
                }
                let user = User(uid: uid, firstName: firstName, lastName: lastName)
                completion(user)
            })
        }
    }
}

