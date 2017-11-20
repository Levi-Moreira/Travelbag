//
//  PostModel.swift
//  Travelbag
//
//  Created by IFCE on 07/11/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit
import Firebase

class PostModel: NSObject {
	var posts = [Post]()
	static let shared = PostModel()
	
	private override init() {
		posts = [Post]()
	}
	
	func getPosts(completion :@escaping ([Post]) ->()){
		ref.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
			self.posts.removeAll()
			
			guard let arrayDataSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
				return
			}
			for snap in arrayDataSnapshot {
				guard let json = snap.value as? [String: Any] else {
					return
				}
				self.posts.append(Post(with: json))
				completion(self.posts)
			}
		})
	}
}
