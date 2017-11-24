//
//  ExploreViewController.swift
//  Travelbag
//
//  Created by IFCE on 07/11/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit
import MapKit

class ExploreViewController: UIViewController {
	
	@IBOutlet weak var mapView: MKMapView!
	var postModel : PostModel!
	var centerUserPosition: Bool = true
	var pinoTest = CustomPointAnnotation()
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		postModel = PostModel.shared
		
		self.mapView.mapType = .standard
		self.mapView.showsUserLocation = true
		if postModel.posts.isEmpty {
			postModel.getPosts(completion: { (postsResult) in
				self.postModel.posts = postsResult })
			
			addPinToMapView()
		} else{
			addPinToMapView()
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func addPin(post: Post){
		let location = CLLocationCoordinate2D(latitude: post.latitude!, longitude: post.longitude!)
		let point = PostAnnotation(coordinate: location)
		point.imagePost = post.image
		point.share_gas = post.share_gas
		point.share_host = post.share_host
		point.share_group = post.share_host
		point.text = post.content
		point.userName = "\(post.user_first_name) \(post.user_last_name)"
		self.mapView.addAnnotation(point)
	}

	func addPinToMapView(){
		for placeUser in self.postModel.posts {
			addPin(post: placeUser)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		postModel.getPosts { (postResult) in
			self.postModel.posts = postResult
		}
		
		addPinToMapView()
	
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

extension ExploreViewController: MKMapViewDelegate {
	
	class CustomPointAnnotation: MKPointAnnotation {
		var imageName: String!
	}
	
	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
		if centerUserPosition{
			let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 10000, 10000)
			self.mapView.setRegion(region, animated: true)
			self.centerUserPosition = false
		}
	}
    
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		
		
		if annotation is MKUserLocation
		{
			return nil
		}
		var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
		if annotationView == nil{
			annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
			annotationView?.canShowCallout = false
		}else{
			annotationView?.annotation = annotation
		}
		annotationView?.image = #imageLiteral(resourceName: "icons8-Marker Filled-100")
		return annotationView
	}
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		// 1
		if view.annotation is MKUserLocation
		{
			// Don't proceed with custom callout
			return
		}
		// 2
		let postAnnotation = view.annotation as! PostAnnotation
		let views = Bundle.main.loadNibNamed("CustomCalloutView", owner: nil, options: nil)
		let calloutView = views?[0] as! CustomCalloutView
		calloutView.nameUser.text = postAnnotation.userName
		calloutView.text.text = postAnnotation.text
		if(postAnnotation.share_gas){
			calloutView.share1.image = #imageLiteral(resourceName: "icons8-Home Page Filled_100")
		}else{
			calloutView.share1.isHidden = true
		}

		if(postAnnotation.share_group){
			calloutView.share2.image = #imageLiteral(resourceName: "icons8-Home Page Filled_100")
		}else{
			calloutView.share2.isHidden = true
		}

		if(postAnnotation.share_host){
			calloutView.share3.image = #imageLiteral(resourceName: "icons8-Home Page Filled_100")
		}else{
			calloutView.share3.isHidden = true
		}
		if let urlString = postAnnotation.imagePost{
			if let url = URL(string:urlString ){
//				calloutView.imagePost.frame.size = CGSize.zero
				calloutView.imagePost.isHidden = true
//				calloutView.layoutIfNeeded()
//				calloutView.layoutSubviews()
				if let data = try? Data(contentsOf: url){
					let imagepost = UIImage(data: data)
					calloutView.imagePost.image = imagepost
				}
			} else{
				calloutView.imagePost.isHidden = true
			}
		}
		
		
		// 3
		calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
		view.addSubview(calloutView)
		mapView.setCenter((view.annotation?.coordinate)!, animated: true)
	}
	
	func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
		if view.isKind(of: AnnotationView.self)
		{
			for subview in view.subviews
			{
				subview.removeFromSuperview()
			}
		}
	}
//		if !(annotation is MKPointAnnotation) {
//			print("NOT REGISTERED AS MKPOINTANNOTATION")
//			return nil
//		}
//
//		var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "postIdentitfier")
//		if annotationView == nil {
//			annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "postIdentitfier")
//			annotationView!.canShowCallout = true
//		}
//
//		else {
//			annotationView!.annotation = annotation
//		}
//
////		let cpa = annotation as! CustomPointAnnotation
//		annotationView!.image = #imageLiteral(resourceName: "icons8-Marker Filled-100")
//
//		return annotationView
		
//		// 2
//		guard let annotation = annotation as? PostAnnotation else { return nil }
//		// 3
//		let identifier = MKMapViewDefaultAnnotationViewReuseIdentifier
//		var view: MKMarkerAnnotationView
//		// 4
//		if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//			as? MKMarkerAnnotationView {
//			dequeuedView.annotation = annotation
//			view = dequeuedView
//		} else {
//			// 5
//			view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
////			view.image = #imageLiteral(resourceName: "login-background")
//			view.canShowCallout = true
//			view.calloutOffset = CGPoint(x: -5, y: 5)
//			view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//		}
//		return view
//	}
}
