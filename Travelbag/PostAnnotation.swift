//
//  PostAnnotation.swift
//  Travelbag
//
//  Created by IFCE on 09/11/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit
import MapKit

class PostAnnotation: NSObject , MKAnnotation {

	var coordinate: CLLocationCoordinate2D
	var text: String!
	var userName: String!
	var imagePost: String?
	var user_image_profile: String?
	var share_gas: Bool!
	var share_group: Bool!
	var share_host: Bool!
	
	init(coordinate: CLLocationCoordinate2D) {
		self.coordinate = coordinate
	}
}
