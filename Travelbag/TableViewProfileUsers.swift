//
//  TableViewProfileUsers.swift
//  Travelbag
//
//  Created by ifce on 25/10/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import ARSLineProgress
import Nuke
import CoreLocation

struct cellDataProfile {
    let cell: Int!
}

class TableViewProfileUsers: UITableViewController, CustomProfileDelegate {
    
    func didTapChat() {
        let storyboard = UIStoryboard(name: "Menu", bundle: nil)
        let chatViewController = storyboard.instantiateViewController(withIdentifier: "chatNC") as! UINavigationController
        
        let finalViewController = chatViewController.viewControllers.first as? ChatViewController
        
        var entry = ChatEntry()
        guard let otherUserUid =  profile?.uid else{
            return
        }
        
        if let comparison = Auth.auth().currentUser?.uid.compare(otherUserUid){
            if(comparison == .orderedAscending){
                
                entry.firstUserName = LocalDataProvider().provideUserFirstName()
                entry.firstUserUID = Auth.auth().currentUser?.uid
                entry.firstUserImage = LocalDataProvider().provideUserImage()
                entry.secondUserName = profile?.first_name
                entry.secondUserUID = otherUserUid
                entry.secondUserImage = profile?.profile_picture
                
            }else{
                entry.firstUserName = profile?.first_name
                entry.firstUserUID = otherUserUid
                entry.firstUserImage = profile?.profile_picture
                entry.secondUserName = LocalDataProvider().provideUserFirstName()
                entry.secondUserUID = Auth.auth().currentUser?.uid
                entry.secondUserImage = LocalDataProvider().provideUserImage()
            }
        }
        
        guard let firstUID = entry.firstUserUID, let secondUID = entry.secondUserUID else {
            return
        }
        entry.id = "\(firstUID)\(secondUID)"
        finalViewController?.chatEntry = entry
        self.present(chatViewController, animated: true, completion: nil)
    }
    
    
    var ref: DatabaseReference!
    var uid: String?
    var profile: Profile?
    var posts = [Post]()
    var lastContentOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationItem.backBarButtonItem?.isEnabled = false
        navigationController?.navigationBar.isHidden = true
        self.tableView.isHidden = true
        
        ARSLineProgress.show()
        
        if let uid = uid {
            ref.child("users_profile").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? [String: Any]
                if let val = value{
                    self.profile = Profile.init(with: val)
                    self.profile?.uid = snapshot.key
                    self.showUserInfo()
                }
            }) { (error) in
                print(error)
                ARSLineProgress.hide()
            }
        }
        
        ref.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as! [String: Any]
            
            for child in value {
                
                let childValue = child.value as? [String: Any]
                
                if let cv = childValue {
                    self.posts.append(Post.init(with: cv))
                }
            }
            
            self.posts = self.posts.filter({ (post) -> Bool in
                post.uid == self.self.uid
            })
            
            self.posts.sort{ return $0.0.post_date ?? 0 > $0.1.post_date ?? 0}
            
            self.tableView.reloadData()
            self.tableView.isHidden = false 
        }) { (error) in
            print(error)
            //ARSLineProgress.hide()
        }
    }
    
    func showUserInfo() {
        self.tableView.reloadData()
        ARSLineProgress.hide()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count+1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = Bundle.main.loadNibNamed("TableViewCellProfile", owner: self, options: nil)?.first as! TableViewCellProfile
            
            cell.delegate = self
            
            if let profileImageUrl = profile?.profile_picture{
                let url = URL(string: profileImageUrl)
                if let url = url{
                    Nuke.loadImage(with: url, into: cell.profileImage)
                }
            }
            
            if let bgImageUrl = profile?.cover_photo {
                let url = URL(string: bgImageUrl)
                if let url = url {
                    Nuke.loadImage(with: url, into: cell.backgroundImage)
                }
            }
            
            cell.viewController = self
            
            // Image Profile with radius
            cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.height/2
            cell.profileImage.clipsToBounds = true
            
            // Username
            cell.userName.font = UIFont.boldSystemFont(ofSize: 25.0)
            guard let firstname = profile?.first_name , let lastname = profile?.last_name else {
                return cell
            }
            cell.userName.text = "\(firstname) \(lastname)"
            
            cell.follow.font = UIFont(name: "Raleway-Medium", size: 12)
            cell.follow.text = "Follow"
            cell.chat.font = UIFont(name: "Raleway-Medium", size: 12)
            cell.chat.text = "Message"
            
            cell.places.font = UIFont(name: "Raleway-Medium", size: 12)
            cell.places.text = "Places"
            cell.following.font = UIFont(name: "Raleway-Medium", size: 12)
            cell.following.text = "Following"
            cell.followers.font = UIFont(name: "Raleway-Medium", size: 12)
            cell.followers.text = "Followers"
            
            cell.countPlaces.text = String(posts.count) ?? "0"
            cell.countPlaces.font = UIFont(name: "Raleway-Medium", size: 13)
            cell.countFollowing.text = "678"
            cell.countFollowing.font = UIFont(name: "Raleway-Medium", size: 13)
            cell.countFollowers.text = "764"
            cell.countFollowers.font = UIFont(name: "Raleway-Medium", size: 13)
            
//            UIView.animate(withDuration: 0.5) {
//                cell.topSpaceConstraint.constant -= self.lastContentOffset
//                self.view.layoutIfNeeded()
//            }
            
            return cell
        }
            
            
            
        else {

            
            
            let cell = Bundle.main.loadNibNamed("TableViewCell2", owner: self, options: nil)?.first as! TableViewCell2
            //Image Profile
            
            if let profileImageUrl =  self.posts[indexPath.row - 1].user_image_profile {
                let url = URL(string: profileImageUrl)
                if let url = url{
                    Nuke.loadImage(with: url, into: cell.profileImageView)
                    
                }
            }
            
            // Image Profile with radius
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.height/2
            cell.profileImageView.clipsToBounds = true
            
            // Username
            guard let firstname =  self.posts[indexPath.row - 1].user_first_name, let lastname =  self.posts[indexPath.row - 1].user_last_name else {
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
                    cell.dateLabel.text = "\(dateTravel.dateString(ofStyle: .medium)), at"
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        lastContentOffset = lastContentOffset - scrollView.contentOffset.y
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    func lookUpCurrentLocation(lat: Double, long: Double, completionHandler: @escaping (CLPlacemark?) -> Void ){
        
        let localizacao = CLLocation(latitude: lat as CLLocationDegrees, longitude: long as CLLocationDegrees)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(localizacao, completionHandler: { (placemarks, error) in
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
