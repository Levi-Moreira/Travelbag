//
//  PostAnnotation.swift
//  Travelbag
//
//  Created by IFCE on 09/11/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit
import MapKit

enum PostType {
	case f
	case g
	case t
	case fg
	case ft
	case tg
	case fgt
	func returnImage() -> UIImage {
		switch self {
		case .f:
			return #imageLiteral(resourceName: "pY")
		case .g:
			return #imageLiteral(resourceName: "pP")
		case .t:
			return #imageLiteral(resourceName: "pO")
		case .ft:
			return #imageLiteral(resourceName: "pYO")
		case .fg:
			return #imageLiteral(resourceName: "pYP")
		case .tg:
			return #imageLiteral(resourceName: "pPO")
		case .fgt:
			return #imageLiteral(resourceName: "pYOP")
		}
		
		
	}
}


class PostAnnotation: NSObject , MKAnnotation {

	var coordinate: CLLocationCoordinate2D
	var text: String!
	var userName: String!
	var imagePost: String?
	var type: PostType?
	var user_image_profile: String?
	var share_gas: Bool!
	var share_group: Bool!
	var share_host: Bool!
	var uid: String!

	
	init(coordinate: CLLocationCoordinate2D) {
		self.coordinate = coordinate
	}
	
	
}
