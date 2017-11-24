//
//  ExploreViewController.swift
//  Travelbag
//
//  Created by IFCE on 07/11/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit
import MapKit
import Nuke
import FirebaseAuth

protocol HandleMapSearch {
	
	func zoomInMap(placemark:MKPlacemark)
}


class ExploreViewController: UIViewController {
	
	@IBOutlet weak var mapView: MKMapView!
	var postModel : PostModel!
	var centerUserPosition: Bool = true
	var pinoTest = CustomPointAnnotation()
	let locationManager = CLLocationManager()
	var resultSearchController:UISearchController? = nil
	
	@IBOutlet weak var viewSearch: UIView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestLocation()
		
		let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
		resultSearchController = UISearchController(searchResultsController: locationSearchTable)
		resultSearchController?.searchResultsUpdater = locationSearchTable
		
		let searchBar = resultSearchController!.searchBar
		searchBar.sizeToFit()
		searchBar.placeholder = "Search for places"
		viewSearch.addSubview(resultSearchController!.searchBar)
		resultSearchController?.hidesNavigationBarDuringPresentation = false
		resultSearchController?.dimsBackgroundDuringPresentation = true
		definesPresentationContext = true
		
		locationSearchTable.mapView = mapView
		locationSearchTable.handleMapSearchDelegate = self

		
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


//         Do any additional setup after loading the view.
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
		point.share_group = post.share_group
		point.text = post.content
		point.userName = "\(post.user_first_name!) \(post.user_last_name!)"
		point.user_image_profile = post.user_image_profile
		point.uid = post.uid
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
	
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		
		let postAnnotation = view.annotation as! PostAnnotation
		
		let uid = postAnnotation.uid
		if uid == Auth.auth().currentUser?.uid {
			tabBarController?.selectedIndex = 2
			
		} else {
			let storyboard = UIStoryboard(name: "Menu", bundle: nil)
			let controller = storyboard.instantiateViewController(withIdentifier: "storyboardProfile") as!  TableViewProfileUsers
			
			controller.uid = uid
			//self.present(controller, animated: true, completion: nil)
			self.navigationController?.pushViewController(controller, animated: true)
		}
		
	}
	func goToProfile(sender: UITapGestureRecognizer){
		guard let callOutView = sender.view as? CustomCalloutView else{
			return
		}
		
		let uid = callOutView.uid
		if uid == Auth.auth().currentUser?.uid {
			tabBarController?.selectedIndex = 2
			
		} else {
			let storyboard = UIStoryboard(name: "Menu", bundle: nil)
			let controller = storyboard.instantiateViewController(withIdentifier: "storyboardProfile") as!  TableViewProfileUsers
			
			controller.uid = uid
			//self.present(controller, animated: true, completion: nil)
			self.navigationController?.pushViewController(controller, animated: true)
		}
		
		
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
		
//		let button1 = UIButton(frame: calloutView.nameUser.frame)
//		button1.addTarget(self, action: #selector(ExploreViewController.goToProfile(sender:)), for: .touchUpInside)
//		calloutView.addSubview(button1)
		
		calloutView.nameUser.text = postAnnotation.userName
		calloutView.text.text = postAnnotation.text
		calloutView.uid = postAnnotation.uid
		if(postAnnotation.share_gas){
			calloutView.categoryImageArray.append(#imageLiteral(resourceName: "icons8-People in Car Filled_100"))
		}

		if(postAnnotation.share_group){
			calloutView.categoryImageArray.append(#imageLiteral(resourceName: "icons8-User Groups Filled_100"))
		}

		if(postAnnotation.share_host){
			calloutView.categoryImageArray.append(#imageLiteral(resourceName: "icons8-Home Page Filled_100"))
		}
		
		if let urlString = postAnnotation.imagePost{
			if let url = URL(string:urlString ){
//				calloutView.imagePost.frame.size = CGSize.zero
//				calloutView.imagePost.isHidden = true
//				calloutView.layoutIfNeeded()
//				calloutView.layoutSubviews()
				if let data = try? Data(contentsOf: url){
					let imagepost = UIImage(data: data)
					calloutView.imagePost.image = imagepost
					calloutView.imagePost.layer.masksToBounds = true
					calloutView.imagePost.layer.cornerRadius = 62
				}
			} else{
				if let url = postAnnotation.user_image_profile {
					if url.isValidHttpsUrl {
						Nuke.loadImage(with: URL(string: url)!, into: calloutView.imagePost)
						calloutView.imagePost.layer.masksToBounds = true
						calloutView.imagePost.layer.cornerRadius = 62
					}
				}
			}
		}
		
		
		
		
		// 3
		calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
		view.addSubview(calloutView)
		mapView.setCenter((view.annotation?.coordinate)!, animated: true)
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(ExploreViewController.goToProfile(sender:)))
		calloutView.addGestureRecognizer(tap)
		
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
	
	

}

extension ExploreViewController : CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {
			print("location:: \(location)")
		}
	}
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("error:: \(error)")
	}
}

extension ExploreViewController: HandleMapSearch{
	func zoomInMap(placemark: MKPlacemark) {
//		let span = MKCoordinateSpanMake(1000, 1000)
		let region = MKCoordinateRegionMakeWithDistance(placemark.coordinate, 100000, 100000)
		mapView.setRegion(region, animated: true)
	}
	
	
}
