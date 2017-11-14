//
//  FeedViewController.swift
//  Travelbag
//
//  Created by ifce on 10/11/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit
import FirebaseAuth
import DatePickerDialog
import FirebaseDatabase
import CoreLocation
import ARSLineProgress

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

	
	var ref:DatabaseReference!
	var databaseHandle:DatabaseHandle?
	var postModel : PostModel!
	var posts = [Post]()
	
	let refreshControl = UIRefreshControl()
	@IBOutlet weak var tableView: UITableView!
	override func viewDidLoad()  {
		super.viewDidLoad()
		
		postModel = PostModel.shared
		
		ref = Database.database().reference()
		refreshControl.addTarget(self, action: #selector(updatePost), for: .valueChanged)
		tableView.insertSubview(refreshControl, at: 0)
		

		tableView.rowHeight = UITableViewAutomaticDimension

		updatePost()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func updatePost() {
		postModel.getPosts { (result) in
			self.posts = result
			DispatchQueue.main.async {
				self.tableView.reloadData()
				self.refreshControl.endRefreshing()
			}
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (posts.count) + 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "post", for: indexPath) as! FeedTableViewCell
		let createPost = tableView.dequeueReusableCell(withIdentifier: "createPost", for: indexPath) as! PostCreationTableViewCell
		

		if indexPath.row == 0{
			createPost.selfImage.image = #imageLiteral(resourceName: "login-background")
			return (createPost)
		}else{
			let post = self.posts[indexPath.row-1]
			if let name = post.userName {
				cell.nameUser.text = name
			}
			cell.profilePhoto.image = #imageLiteral(resourceName: "login-background")
			
			if let urlString = self.posts[indexPath.row-1].image{
				if let url = URL(string:urlString ){
					if let data = try? Data(contentsOf: url){
						let imagepost = UIImage(data: data)
						cell.imagePost.image = imagepost
					}
				} else {
					cell.constraintHeight.constant = 0.0
				}
			}
			guard let latitude = self.posts[indexPath.row-1].latitude else{
				return cell
			}
			
			guard let longitude = self.posts[indexPath.row-1].longitude else {
				return cell
			}
			lookUpCurrentLocation(lat: latitude, long: longitude) { (placemark) in
				cell.locationUser.text = placemark?.locality ?? ""
			}
			cell.textPost.text = post.content
			
			if let timeGet = post.post_date{
				cell.timeAgo.text = post.timeToNow
			}else{
				cell.timeAgo.text = "cheguei"
			}
			//			cell.timeAgo.text = self.posts[indexPath.row].date
			return (cell)

		}
		
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
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginNav") as! UINavigationController
            
            self.present(controller, animated: true, completion: nil)
    }
	
	func getPosts(){
		if postModel.posts.count > 0 {
			posts = postModel.posts
		}else {
			ARSLineProgress.show()
			postModel.getPosts(completion: { (postsResult) in
				self.posts = postsResult
				DispatchQueue.main.async {
					self.tableView.reloadData()
					ARSLineProgress.hide()
				}
			})
		}
//		ref.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
//			self.posts.removeAll()
//
//			guard let arrayDataSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
//				return
//			}
//			for snap in arrayDataSnapshot {
//				guard let json = snap.value as? [String: Any] else {
//					return
//				}
//				self.posts.append(Post(with: json))
//			}
//
//			ARSLineProgress.hide()
//			DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
//				self.tableView.reloadData()
//				self.refreshControl.endRefreshing()
//			})
//
//		}) { (error) in
//			print(error.localizedDescription)
//		}
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
