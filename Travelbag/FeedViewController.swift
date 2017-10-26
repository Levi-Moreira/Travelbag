//
//  FeedViewController.swift
//  Travelbag
//
//  Created by ifce on 10/11/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CoreLocation
import DatePickerDialog


class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

	
	var ref:DatabaseReference!
	var databaseHandle:DatabaseHandle?
//	var user = Auth.auth().currentUser
	
	var posts = [Post]()
	

	@IBOutlet weak var tableView: UITableView!
	override func viewDidLoad()  {
		super.viewDidLoad()
		ref = Database.database().reference()
		
		getPosts()
		

		tableView.rowHeight = UITableViewAutomaticDimension

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (posts.count)
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as! FeedTableViewCell
		
		cell.nameUser.text = self.posts[indexPath.row].owner
		cell.profilePhoto.image = #imageLiteral(resourceName: "login-background")
		
		if let url = URL(string: self.posts[indexPath.row].image!){
			if let data = try? Data(contentsOf: url){
				let imagepost = UIImage(data: data)
				cell.imagePost.image = imagepost
			}
		}else{
			cell.constraintHeight.constant = 0.0
		}
		lookUpCurrentLocation(lat: self.posts[indexPath.row].lat!, long: self.posts[indexPath.row].long!) { (placemark) in
			cell.locationUser.text = placemark?.locality ?? ""
		}
		
		
		cell.textPost.text = self.posts[indexPath.row].text
		cell.timeAgo.text = "3 min"
		
		
		// Configure the cell...
		
		return (cell)
	}

    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing  out: %@", signOutError)
        }
        
        presentLogin()
    }
    
    func presentLogin(){
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "Login") as UIViewController
            
            self.present(controller, animated: true, completion: nil)
        
    }
	
	func getPosts(){
		ref.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
			guard let arrayDataSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
				return
			}
			for snap in arrayDataSnapshot {
				guard let json = snap.value as? [String: Any] else {
					return
				}
				
				self.posts.append(Post(with: json))
			}
			self.tableView.reloadData()
		}) { (error) in
			print(error.localizedDescription)
		}
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

}
