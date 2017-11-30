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


class ExploreViewController: BaseViewController {
	
	@IBOutlet weak var mapView: MKMapView!
	var postModel : PostModel!
	var centerUserPosition: Bool = true
	var pinoTest = CustomPointAnnotation()
	let locationManager = CLLocationManager()
	var resultSearchController:UISearchController? = nil
	var annotationRef = [MKAnnotation]()
	
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
		if(post.share_gas){
			point.type = PostType.t
		}
		if(post.share_group){
			point.type = PostType.g
		}
		if(post.share_host){
			point.type = PostType.f
		}
		if(post.share_group && post.share_host){
			point.type = PostType.fg
		}
		if(post.share_group && post.share_gas){
			point.type = PostType.tg
		}
		if(post.share_gas && post.share_host){
			point.type = PostType.ft
		}
		if(post.share_group && post.share_host && post.share_host){
			point.type = PostType.fgt
		}
		
		self.mapView.addAnnotation(point)
		self.annotationRef.append(point)
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
	override func viewDidDisappear(_ animated: Bool) {
		self.mapView.removeAnnotations(self.annotationRef)
		self.annotationRef.removeAll()
		print("Estou aqui")
	}
	
	
	func lookUpCurrentLocation(lat: Double, long: Double, completionHandler: @escaping (CLPlacemark?) -> Void ){
		
		let localizacao = CLLocation(latitude: lat as CLLocationDegrees, longitude: long as CLLocationDegrees)
		
		let geocoder = CLGeocoder()
		
		geocoder.reverseGeocodeLocation(localizacao,
										completionHandler: { (placemarks, error) in
											if error == nil {
												let firstLocation = placemarks?[0]
												completionHandler(firstLocation)
											}
											else {
												// An error occurred during geocoding.
												completionHandler(nil)
											}
		})
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
			let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 15000, 15000)
			self.mapView.setRegion(region, animated: true)
			self.centerUserPosition = false
		}
	}
    
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard let postAnnotation = annotation as? PostAnnotation else { return nil}
		
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
		annotationView?.image = postAnnotation.type?.returnImage()
		return annotationView
	}
	
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		
		let postAnnotation = view.annotation as! PostAnnotation
		
		let uid = postAnnotation.uid
		if uid == Auth.auth().currentUser?.uid {
			tabBarController?.selectedIndex = 2
			
		} else {
			let storyboard = UIStoryboard(name: "Menu", bundle: nil)
			let controller = storyboard.instantiateViewController(withIdentifier: "storyboardProfile") as! TableViewProfileUsers
			
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
		
		lookUpCurrentLocation(lat: postAnnotation.coordinate.latitude, long: postAnnotation.coordinate.longitude) { (placemark) in
					let location = "\(placemark?.locality ?? "") - \(placemark?.administrativeArea ?? "")"
			
			if location.length <= 21{
				calloutView.viewHeight.constant -= 50
			}
			calloutView.location.text = location
		}
//		if postAnnotation.user
		
		calloutView.nameUser.text = postAnnotation.userName
		calloutView.uid = postAnnotation.uid
		if(postAnnotation.share_gas){
			calloutView.categoryImageArray.append(#imageLiteral(resourceName: "transport"))
		}

		if(postAnnotation.share_group){
			calloutView.categoryImageArray.append(#imageLiteral(resourceName: "group"))
		}

		if(postAnnotation.share_host){
			calloutView.categoryImageArray.append(#imageLiteral(resourceName: "food"))
		}
		
		if let url = postAnnotation.user_image_profile {
			if url.isValidHttpsUrl {
				Nuke.loadImage(with: URL(string: url)!, into: calloutView.imagePost)
				calloutView.imagePost.layer.masksToBounds = true
				calloutView.imagePost.layer.cornerRadius = 25
			}
		}
		
		
		
		
		// 3
		calloutView.viewHeight.constant = 150
		calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
		view.addSubview(calloutView)
		let coordinateCenter = CLLocationCoordinate2D(latitude: (view.annotation?.coordinate.latitude)! + 0.07, longitude: (view.annotation?.coordinate.longitude)!)
		mapView.setCenter(coordinateCenter, animated: true)
		
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
		let region = MKCoordinateRegionMakeWithDistance(placemark.coordinate, 50000, 50000)
		mapView.setRegion(region, animated: true)
	}
	
	
}



