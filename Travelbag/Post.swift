//
//  Post.swift
//  Travelbag
//
//  Created by IFCE on 18/10/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import Foundation

class Post{
	var date: Double?
	var image: String?
	var lat: Double?
	var long: Double?
	var owner: String?
	var share_gas: Bool?
	var share_group: Bool?
	var share_host: Bool?
	var text: String?
	
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
}
