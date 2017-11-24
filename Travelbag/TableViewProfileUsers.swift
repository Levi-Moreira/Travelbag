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

class TableViewProfileUsers: UITableViewController {
    
    var ref: DatabaseReference!
    var uid: String?
    var profile: Profile?
    var posts = [Post]()
    
    var arrayOfCellData = [cellDataProfile]()
    
    var lastContentOffset: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        arrayOfCellData = [cellDataProfile(cell: 1),
                           cellDataProfile(cell: 2),
                           cellDataProfile(cell: 2)
        ]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        
        ARSLineProgress.show()
        
        
        
        if let uid = uid {
            ref.child("users_profile").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? [String: Any]
                if let val = value{
                    self.profile = Profile.init(with: val)
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
        }) { (error) in
            print(error)
            ARSLineProgress.hide()
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
            //cell.controller = self
            if let profileImageUrl = profile?.profile_picture{
                let url = URL(string: profileImageUrl)
                if let url = url{
                    Nuke.loadImage(with: url, into: cell.profileImage)
                }
            }
            
            if let bgImageUrl = profile?.cover_photo{
                let url = URL(string: bgImageUrl)
                if let url = url{
                    Nuke.loadImage(with: url, into: cell.backgroundImage)
                }
            }
            
            // Image Profile with radius
            cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.height/2
            cell.profileImage.clipsToBounds = true
            
            // Username
            cell.userName.font = UIFont.boldSystemFont(ofSize: 25.0)
            guard let firstname = profile?.first_name , let lastname = profile?.last_name else {
                return cell
            }
            cell.userName.text = "\(firstname) \(lastname)"
            
            // Status user
            cell.statusUser.font = UIFont.boldSystemFont(ofSize: 15.0)
            cell.statusUser.text = "Imagine all the people living life in peace"
            
            cell.following.font = UIFont.boldSystemFont(ofSize: 12.0)
            cell.following.text = "Following"
            cell.chat.font = UIFont.boldSystemFont(ofSize: 12.0)
            cell.chat.text = "Message"
            
            cell.places.font = UIFont.boldSystemFont(ofSize: 12.0)
            cell.places.text = "Places"
            cell.following.font = UIFont.boldSystemFont(ofSize: 12.0)
            cell.following.text = "Following"
            cell.followers.font = UIFont.boldSystemFont(ofSize: 12.0)
            cell.followers.text = "Followers"
            
            cell.countPlaces.text = String(posts.count) ?? "0"
            cell.countPlaces.font = UIFont.systemFont(ofSize: 13.0)
            cell.countFollowing.text = "678"
            cell.countFollowing.font = UIFont.systemFont(ofSize: 13.0)
            cell.countFollowers.text = "764"
            cell.countFollowers.font = UIFont.systemFont(ofSize: 13.0)
            
//            UIView.animate(withDuration: 0.5) {
//                cell.topSpaceConstraint.constant -= self.lastContentOffset
//                self.view.layoutIfNeeded()
//            }
            
            return cell
        }
            
            
            
            
        else {
            let cell = Bundle.main.loadNibNamed("TableViewCell2", owner: self, options: nil)?.first as! TableViewCell2
            
            if let profileImageUrl = profile?.profile_picture{
                let url = URL(string: profileImageUrl)
                if let url = url{
                    Nuke.loadImage(with: url, into: cell.profileImageView)
                }
            }
            
            // Image Profile with radius
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.height/2
            cell.profileImageView.clipsToBounds = true
            
            // Username
            guard let firstname = profile?.first_name , let lastname = profile?.last_name else {
                return cell
            }
            cell.nameProfileLabel.text = "\(firstname) \(lastname)"
            
            cell.textPostLabel.text = posts[indexPath.row - 1].content
            
            
            if posts[indexPath.row - 1].image == nil {
                //cell.imageConstraintHeight.constant = 0
            } else {
                if posts[indexPath.row - 1].image!.isEmpty {
                   // cell.imageConstraintHeight.constant = 0
                } else {
                    if let postImage = posts[indexPath.row - 1].image{
                        let url = URL(string: postImage)
                        if let url = url{
                            Nuke.loadImage(with: url, into: cell.imagePost)
                          //  cell.imageConstraintHeight.constant = 133
                        }
                    }
                }
            }
            
            lookUpCurrentLocation(lat: self.posts[indexPath.row - 1].latitude!, long: self.posts[indexPath.row - 1].longitude!) { (placemark) in
                cell.locationLabel.text = placemark?.locality ?? ""
            }
            
//            if let timeGet = self.posts[indexPath.row - 1].post_date {
//                cell.timeLabel.text = self.posts[indexPath.row - 1].timeToNow
//            }else{
//                cell.timeLabel.text = "cheguei"
//            }
            
            
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
