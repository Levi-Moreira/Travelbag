//
//  PersonProfileViewController.swift
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

struct cellData {
    let cell: Int!
}

class TableViewPersonProfileController: UITableViewController {
    
    var ref: DatabaseReference!
    
    var profile: Profile?
    var posts = [Post]()
    
    var arrayOfCellData = [cellData]()
    
    var lastContentOffset: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
    
        arrayOfCellData = [cellData(cell: 1),
                           cellData(cell: 2),
                           cellData(cell: 2)
        ]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        
        ARSLineProgress.show()

        let userID = Auth.auth().currentUser?.uid
            posts.removeAll()
    
        if let uid = userID {
            ref.child("users_profile").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? [String: Any]
                if let val = value{
                    self.profile = Profile.init(with: val)
                    self.showUserInfo()
                }
            }) { (error) in
                print(error)
//                ARSLineProgress.hide()
                
            }
        }
        
        ref.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if let value = snapshot.value as? [String: Any]{
            
            for child in value {
                    
                    let childValue = child.value as? [String: Any]
                    
                    if let cv = childValue {
                       self.posts.append(Post.init(with: cv))
                    }
                }
            }
            
            self.posts = self.posts.filter({ (post) -> Bool in
                post.uid == Auth.auth().currentUser?.uid
            })
            
            self.posts.sort{ return $0.0.post_date ?? 0 > $0.1.post_date ?? 0}
            
                self.tableView.reloadData()
        }) { (error) in
            print(error)
//            ARSLineProgress.hide()
            
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
            let cell = Bundle.main.loadNibNamed("TableViewCell1", owner: self, options: nil)?.first as! TableViewCell1
            cell.controller = self
            if let profileImageUrl = profile?.profile_picture{
                let url = URL(string: profileImageUrl)
                if let url = url{
                    Nuke.loadImage(with: url, into: cell.profileImageView)
                }
            }
            
            if let bgImageUrl = profile?.cover_photo{
                let url = URL(string: bgImageUrl)
                if let url = url{
                    Nuke.loadImage(with: url, into: cell.backgroundImageView)
                }
            }
            
            // Image Profile with radius
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.height/2
            cell.profileImageView.clipsToBounds = true
            
            // Username
            cell.userNameLabel.font = UIFont.boldSystemFont(ofSize: 25.0)
            guard let firstname = profile?.first_name , let lastname = profile?.last_name else {
                return cell
            }
            cell.userNameLabel.text = "\(firstname) \(lastname)"
            
            // Status user
            cell.statusUserLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
            cell.statusUserLabel.text = profile?.bio 
            
           // cell.followingLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
           // cell.followingLabel.text = "Following"
            cell.settingsLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
            cell.settingsLabel.text = "Settings"
            
            cell.lbPlaces.font = UIFont.boldSystemFont(ofSize: 12.0)
            cell.lbPlaces.text = "Places"
            cell.lbFollowing.font = UIFont.boldSystemFont(ofSize: 12.0)
            cell.lbFollowing.text = "Following"
            cell.lbFollowers.font = UIFont.boldSystemFont(ofSize: 12.0)
            cell.lbFollowers.text = "Followers"
            
            cell.lbCountPlaces.text = String(posts.count)
            cell.lbCountPlaces.font = UIFont.systemFont(ofSize: 13.0)
            cell.lbCountFollowing.text = "678"
            cell.lbCountFollowing.font = UIFont.systemFont(ofSize: 13.0)
            cell.lbCountFollowers.text = "764"
            cell.lbCountFollowers.font = UIFont.systemFont(ofSize: 13.0)
            
            UIView.animate(withDuration: 0.5) {
                cell.topSpaceConstraint.constant -= self.lastContentOffset
                self.view.layoutIfNeeded()
            }
            
            return cell
        }
        else {
            
            let dateNow = Date()
            
            
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
            
            //Post Date
            cell.postDateLabel.text = self.posts[indexPath.row - 1].timeToNow
            
            
            //Post Text
            cell.textPostLabel.text = self.posts[indexPath.row - 1].content
            
            //Post Image
            if let imagePost = self.posts[indexPath.row - 1].image {
                let url = URL(string: imagePost)
                if let url = url{
                    Nuke.loadImage(with: url, into: cell.imagePost)
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
                cell.locationLabel.text = placemark?.locality ?? ""
            }
            
            //Post Verbal Time
        
    
            //Post Interval Date
        
                
                
            //Post Interesses Collection
                
        
            
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
