//
//  FirebaseModel.swift
//  Travelbag
//
//  Created by ifce on 24/10/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import Foundation
import FirebaseDatabase

class FirebaseBaseModel: FirebaseModel{
    var databaseRef: DatabaseReference!
    func toDic() -> [String : Any] {
        return [String:Any]()
    }
    
    
    init(){
         databaseRef = Database.database().reference()
    }
    
    func saveTo(node: String) -> String{
        let node = self.databaseRef.child(node).childByAutoId()
        node.setValue(self.toDic())
    
        return node.key
    }
    

    func saveTo(node: String, with uid: String) -> String{
        
        let node = self.databaseRef.child(node).child(uid)
        node.setValue(self.toDic())
        
        return node.key
    }
}

protocol FirebaseModel{
    func toDic() -> [String : Any]
}
