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
class FeedViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource, CreatePostViewControllerDelegate, FeedViewControllerDelegate{
    func didTapName(at indexPath: IndexPath) {
        if indexPath.row != 0 {
            let uid = posts[indexPath.row - 1].uid
            if uid == Auth.auth().currentUser?.uid {
                
                let menuStoryboard = UIStoryboard(name: "Menu", bundle: nil)
                let myProfileController = menuStoryboard.instantiateViewController(withIdentifier: "myProfileStoryboard") as! TableViewPersonProfileController
                myProfileController.uid = uid
                self.navigationController?.pushViewController(myProfileController, animated: true)
                
            } else {
                
                let storyboard = UIStoryboard(name: "Menu", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "storyboardProfile") as!  TableViewProfileUsers
                controller.uid = uid
                
                //self.present(controller, animated: true, completion: nil)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func didTapLocation(at indexPath: IndexPath) {
        if indexPath.row != 0 {
            let storyboard = UIStoryboard(name: "Menu", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "storyboardMap") as!  ExploreViewController
            //controller.place =
            print("tap location")
            
        }
    }
    
    
    
    func didFishedCreate() {
    refreshControl.beginRefreshing()
    updatePost()

    
    }
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        return posts.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let createPost = tableView.dequeueReusableCell(withIdentifier: "createPost", for: indexPath) as! PostCreationTableViewCell
        
        if indexPath.row == 0 {
            
            if let url = defaults.string(forKey: "imageProfile"){
                if url.isValidHttpsUrl {
                    Nuke.loadImage(with: URL(string: url)!, into: createPost.selfImage)
                }
                
            }
            return createPost
        }
            else {
                
                
                
                
                var cell = Bundle.main.loadNibNamed("TableViewCell2", owner: self, options: nil)?.first as! TableViewCell2
                //Image Profile
            
            cell.delegate = self
            cell.indexPath = indexPath
            
                if let profileImageUrl =  self.posts[indexPath.row - 1].user_image_profile {
                    let url = URL(string: profileImageUrl)
                    if let url = url{
                        Nuke.loadImage(with: url, into: cell.profileImageView)
                        
                    }
                }
                
            
            guard let latitude = post.latitude else {
                return cell
            }
            
            guard let longitude = post.longitude else {
                return cell
            }
            
            lookUpCurrentLocation(lat: latitude, long: longitude) { (placemark) in
                cell.locationUser.text = placemark?.locality ?? ""
            }
            cell.textPost.text = post.content
            
            if let timeGet = post.post_date {
                cell.timeAgo.text = post.timeToNow
            } else {
                cell.timeAgo.text = "cheguei"
            }
            
            var interests = [InterestOptions]()
            
            if post.share_gas {
                interests.append(.transport)
            }
            
            if post.share_host {
                interests.append(.hosting)
            }
            
            if post.share_group {
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
                switch (interests.count) {
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
                cell.nameButton.setTitle("\(firstname) \(lastname)", for: UIControlState.normal)
                
                //Post Date
                if let postDate = self.posts[indexPath.row - 1].timeToNow {
                    cell.postDateLabel.text = "Posted \(postDate)"
                }
                
                //Post Text
                cell.textPostLabel.text = self.posts[indexPath.row - 1].content
                
                //Post Image
                if let imagePost = self.posts[indexPath.row - 1].image {
                    let url = URL(string: imagePost)
                    if let url = url{
                        Nuke.loadImage(with: url, into: cell.imagePost)
                        cell.imagePostHeightConstraint.constant = 174
                    }else{
                        
                        cell.imagePostHeightConstraint.constant = 0
                    }
                }
                
                //Post Location
                
                guard let latitude = self.posts[indexPath.row - 1].latitude else{
                    return cell
                }
                
                guard let longitude = self.posts[indexPath.row - 1].longitude else {
                    return cell
                }
                
                lookUpCurrentLocation(lat: latitude, long: longitude) { (placemark) in
                    if let location =  placemark?.locality {
                        cell.locationButton.setTitle(location, for: UIControlState.normal)
                    }
                }
                
                
                
                //Post  Date
                
                if let date = self.posts[indexPath.row - 1].date {
                    let dateTravel = Date.init(timeIntervalSince1970: date)
                    
                    if dateTravel.isInFuture{
                        cell.dateLabel.text = "\(dateTravel.dateString(ofStyle: .long)), at"
                        cell.postIcon.image = #imageLiteral(resourceName: "icons8-airplane-landing-filled-100")
                    }
                    
                    if dateTravel.isInToday {
                        cell.dateLabel.text = "At"
                        cell.postIcon.image = #imageLiteral(resourceName: "icons8-marker-100")
                        
                    }
                    
                    if dateTravel.isInPast {
                        cell.dateLabel.text = "Was in"
                        cell.postIcon.image = #imageLiteral(resourceName: "icons8-marker-100")
                    }
                }
                
                //Post Interesses Collection
            if self.posts[indexPath.row - 1].share_host {
            cell.categoryImageArray.append(#imageLiteral(resourceName: "food"))
            cell.categoryNameArray.append("Meal")
            }
            if self.posts[indexPath.row - 1].share_gas {
                cell.categoryImageArray.append(#imageLiteral(resourceName: "transport"))
                cell.categoryNameArray.append("Transport")
            }
            if self.posts[indexPath.row - 1].share_group {
                cell.categoryImageArray.append(#imageLiteral(resourceName: "group"))
                cell.categoryNameArray.append("Moment")
            }
                return cell
            }
        
    }
    

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as? UINavigationController
        
        if let destionation = dest{
            let dvc = destionation.viewControllers.first as! CreatePostViewController
            
            dvc.delegate = self as? CreatePostViewControllerDelegate
            
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
    
    func getUserProfile() {
        
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
    

    
    func getPosts() {

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



