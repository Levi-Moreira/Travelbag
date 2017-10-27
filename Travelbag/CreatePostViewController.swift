//
//  CreatePostViewController.swift
//  Travelbag
//
//  Created by ifce on 18/10/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit
import ImagePicker
import DatePickerDialog
import CoreLocation
import LocationPicker
import SwifterSwift
import FirebaseAuth
import FirebaseDatabase
import ARSLineProgress


class CreatePostViewController: UITableViewController, ImagePickerDelegate, CLLocationManagerDelegate, InterestOptionsDelegate {
 
    let imagePickerController = ImagePickerController()
    var post =  Post()
   
    @IBOutlet var postImagePreview: UIImageView!

    
    @IBOutlet var pickedDate: UILabel!
    
    @IBOutlet var pickedInterest: UILabel!
    
    @IBOutlet var pickedLocation: UILabel!
    
    @IBOutlet var imageCell: UITableViewCell!
    
    var locationManager = CLLocationManager()
    
    var currentLocation : CLLocation!
    var currentPlacemark : CLPlacemark!
    
    var noImage = true
    


    @IBOutlet var postContent: UITextField!
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
       
      
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if indexPath.row == 1 && noImage{
            return 0
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            
        case 2:
            pickLocation()
        case 3:
            pickDate()
        case 4:
            performSegue(withIdentifier: "pickInterestSegue", sender: self)

        default:
            return
        }
    }
    
    func pickLocation(){
        // you can optionally set initial location
    let locationPicker = LocationPickerViewController()
        
        let initialLocation = Location(name: "You're here", location: currentLocation, placemark: currentPlacemark)
        locationPicker.location = initialLocation
        
        // button placed on right bottom corner
        locationPicker.showCurrentLocationButton = true // default: true
        
        // default: navigation bar's `barTintColor` or `.whiteColor()`
        locationPicker.currentLocationButtonBackground = .blue
        
        // ignored if initial location is given, shows that location instead
        locationPicker.showCurrentLocationInitially = true // default: true
        
        locationPicker.mapType = .standard // default: .Hybrid
        
        // for searching, see `MKLocalSearchRequest`'s `region` property
        locationPicker.useCurrentLocationAsHint = true // default: false
        
        locationPicker.searchBarPlaceholder = "Search places" // default: "Search or enter an address"
        
        locationPicker.searchHistoryLabel = "Previously searched" // default: "Search History"
        
        // optional region distance to be used for creation region when user selects place from search results
        locationPicker.resultRegionDistance = 500 // default: 600
        
        locationPicker.completion = { location in
            self.currentPlacemark = location?.placemark
            self.currentLocation = location?.location
            self.showLocation()
            
        }
        
        navigationController?.pushViewController(locationPicker, animated: true)
    }
    
    func showLocation(){
        self.pickedLocation.text = self.currentPlacemark.locality
        
        self.post.latitude = self.currentLocation.coordinate.latitude
        self.post.longitude = self.currentLocation.coordinate.longitude
        
        
    }
    
    func pickDate(){
        
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                let formatterLocal = DateFormatter()
                formatterLocal.dateFormat = "MM-dd-yyyy"
                
                
                self.pickedDate.text = formatterLocal.string(from: dt)
                
                self.post.date = formatter.string(from: dt)
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations[0]
        
        getUserLocation(latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude) { (city) in
            self.currentPlacemark = city
            self.showLocation()
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func getUserLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completionHandler: @escaping (_ placemark: CLPlacemark?)-> Void){
        let geocoder = CLGeocoder()
        
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(location) { (placemark, error) in
            if (error != nil) {
                completionHandler(nil)
            }
            
            if((placemark?.count)! > 0){
                completionHandler((placemark?.first)!)
            }else{
                completionHandler(nil)
            }
        }
    }
    
    func didSelectInterestOption(options: [InterestOptions]) {
        self.pickedInterest.text = options.first?.rawValue
        self.post.interest = options.first?.rawValue
        for option in options {
            if option == .group{
                 self.post.share_group = true
            }
            
            if option == .hosting{
                self.post.share_host = true
            }
            
            if option == .transport{
                self.post.share_gas = true
            }
        }
       
    }
    
    @IBAction func didTabCamera(_ sender: UIButton) {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        if let image = images.first{
            self.publishImage(image: image)
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        if let image = images.first{
            self.publishImage(image: image)
            imagePicker.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    func pickInterest(completionHandler: @escaping (InterestOptions) -> Void) {
        performSegue(withIdentifier: "pickInterestSegue" , sender: self)
        
        self.post.share_gas = false
        self.post.share_host = false
        self.post.share_group = false
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickInterestSegue"{
            let destination = segue.destination as? INterestOptionsTableViewController
            
            destination?.interestOptionDelegate = self
        }
    }
    
    
    func publishImage(image: UIImage) {
        postImagePreview.image = image
        
        self.post.image_holder = FirebaseImage(image: image)
        
        self.noImage = false
        self.tableView.reloadData()
    }
    
    @IBAction func didTapCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showMissingDateDialog(){
        let alertController = UIAlertController(title: "Attention", message: "Please, pick a date for your post.", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showMissingInterestDialog(){
        let alertController = UIAlertController(title: "Attention", message: "Please, pick at least one interest.", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showMissingTextDialog(){
        let alertController = UIAlertController(title: "Attention", message: "Please, add a text to your post.", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func didTapSavePost(_ sender: UIBarButtonItem) {
        self.post.content = postContent.text
        
        if (self.post.content?.isEmpty)!{
            showMissingTextDialog()
            return
        }
        if self.post.date == nil{
            showMissingDateDialog()
            return
        }
        
        if self.post.interest == nil{
            showMissingInterestDialog()
            return
        }
        
        ARSLineProgress.show()
        
        
        self.post.uid = Auth.auth().currentUser?.uid
        
        let postid = self.post.saveTo(node: "posts")
        
        guard let image = self.post.image_holder else{
            ARSLineProgress.hide()
            self.dismiss(animated: true, completion: nil)
            return
        }
        image.save(withResouceType: "posts", withParentId: postid, withName: "postimage.jpg", completionHandler: { (error, snapshot) in
            if error != nil {
                print(error)
                ARSLineProgress.hide()
                ARSLineProgress.showFail()
                return
            }
            ARSLineProgress.hide()
            self.dismiss(animated: true, completion: nil)
           
        })
      
    }
    
}

enum InterestOptions: String {
    case hosting = "Share hosting"
    case transport = "Share Transport"
    case group = "Share moments"
}
