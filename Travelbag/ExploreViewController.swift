//
//  ExploreViewController.swift
//  Travelbag
//
//  Created by IFCE on 07/11/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit
import MapKit

class ExploreViewController: UIViewController, MKMapViewDelegate {
	
	@IBOutlet weak var mapView: MKMapView!
	var postModel : PostModel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		postModel = PostModel.shared
		
		self.mapView.mapType = MKMapType.standard

		let tdLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(-3.747117, -38.533528)
		self.mapView.region = MKCoordinateRegionMakeWithDistance(tdLocation, 2000, 2000)

		let ifceAnnotation:MKPointAnnotation = MKPointAnnotation()

		ifceAnnotation.coordinate = CLLocationCoordinate2DMake(-3.747117, -38.533528)
		ifceAnnotation.title = "Aqui é o IFCE"
		self.mapView.addAnnotation(ifceAnnotation)

//         Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
