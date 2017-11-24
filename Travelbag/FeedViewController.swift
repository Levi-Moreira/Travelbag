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
import Nuke
class FeedViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    var ref:DatabaseReference!
    var databaseHandle:DatabaseHandle?
    var postModel : PostModel!
    var posts = [Post]()
    var userProfile: Profile!
    let defaults = UserDefaults.standard
    let userID = Auth.auth().currentUser?.uid
    
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
        
        getUserProfile()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.tintColor = UIColor.red
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updatePost() {
        postModel.getPosts { (result) in
            self.posts = result
            
//            self.posts.sort(by: { (first, second) -> Bool in
//                return first.post_date ?? 0 > second.post_date ?? 0
//            })
            
            self.posts.sort{ return $0.0.post_date ?? 0 > $0.1.post_date ?? 0}
            
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
            
            if let url = defaults.string(forKey: "imageProfile"){
                if url.isValidHttpsUrl {
                    Nuke.loadImage(with: URL(string: url)!, into: createPost.selfImage)
                }
                
            }
            return (createPost)
        }else{
            let post = self.posts[indexPath.row-1]
            if let firstname = post.user_first_name {
                if let lastname = post.user_last_name {
                cell.nameUser.text = "\(firstname) \(lastname)"
                } }

            
            if let url = post.user_image_profile {
                if url.isValidHttpsUrl {
                    Nuke.loadImage(with: URL(string: url)!, into: cell.profilePhoto)
                }
                
            }
            
            if posts[indexPath.row - 1].image == nil {
                    cell.constraintHeight.constant = 0
                } else {
                    if posts[indexPath.row - 1].image!.isEmpty {
                        cell.constraintHeight.constant = 0
                    } else {
                        if let postImage = posts[indexPath.row - 1].image{
                            let url = URL(string: postImage)
                            if let url = url{
                                Nuke.loadImage(with: url, into: cell.imagePost)
                            cell.constraintHeight.constant = 191
                            }
                        }
                    }
                }
                
            

        
            guard let latitude = post.latitude else{
                return cell
            }
            
            guard let longitude = post.longitude else {
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
            
            
            var interests = [InterestOptions]()
            
            if post.share_gas{
                interests.append(.transport)
            }
            
            if post.share_host{
                interests.append(.hosting)
            }
            
            if post.share_group{
                interests.append(.group)
            }
            
            lookUpCurrentLocation(lat: latitude, long: longitude) { (placemark) in
                cell.locationUser.text = placemark?.locality ?? ""
            }
            cell.textPost.text = post.content
            
            if let timeGet = post.post_date {
                cell.timeAgo.text = post.timeToNow
            } else {
                cell.timeAgo.text = "cheguei"
                switch (interests.count){
                case 1:
                    cell.secondINterestImage.isHidden = true
                    cell.secondInterestText.isHidden = true
                    cell.thirdInterestText.isHidden = true
                    cell.thirdInterestImage.isHidden = true
                    break;
                case 2:
                    cell.thirdInterestText.isHidden = true
                    cell.thirdInterestImage.isHidden = true
                    break;
                case 3:
                    cell.firstInterestImage.isHidden = false
                    cell.firstInterestText.isHidden = false
                    cell.secondINterestImage.isHidden = false
                    cell.secondInterestText.isHidden = false
                    cell.thirdInterestText.isHidden = false
                    cell.thirdInterestImage.isHidden = false
                    break;
                default:
                    return cell
                }
            }
            //            cell.timeAgo.text = self.posts[indexPath.row].date
            return (cell)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0{
            let uid = posts[indexPath.row - 1].uid
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
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as? UINavigationController
        
        if let destionation = dest{
            let dvc = destionation.viewControllers.first as! CreatePostViewController
            
            dvc.delegate = self
            
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
    
    
    func presentLogin() {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginNav") as! UINavigationController
        
        self.present(controller, animated: true, completion: nil)
    }
    
    func getUserProfile(){
        
        if let uid = userID {
            ref.child("users_profile").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? [String: Any]
                if let val = value{
                    self.userProfile = Profile.init(with: val)
                    
                    self.defaults.set(self.userProfile.first_name, forKey: "firstName")
                    self.defaults.set(self.userProfile.last_name, forKey: "lastName")
                    self.defaults.set(self.userProfile.profile_picture, forKey: "imageProfile")
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }) { (error) in
                print(error)
                
            }
        }
        

	}
	
	func getPosts(){
		if postModel.posts.count > 0 {
			posts = postModel.posts
            
            self.posts.sort(by: { (first, second) -> Bool in
                return first.post_date ?? 0 < second.post_date ?? 0
            })
		}else {
			ARSLineProgress.show()
			
            postModel.getPosts(completion: { (postsResult) in
				self.posts = postsResult
                self.posts.sort(by: { (first, second) -> Bool in
                    return first.post_date ?? 0 < second.post_date ?? 0
                })
                
				DispatchQueue.main.async {
					self.tableView.reloadData()
					ARSLineProgress.hide()
                    
				}
			})
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


