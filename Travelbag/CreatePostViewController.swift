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


class CreatePostViewController: UITableViewController, ImagePickerDelegate, CLLocationManagerDelegate, InterestOptionsDelegate {
 
    let imagePickerController = ImagePickerController()
    var post =  Post()
   
    @IBOutlet var postImagePreview: UIImageView!

    
    @IBOutlet var pickedDate: UILabel!
    
    @IBOutlet var pickedInterest: UILabel!
    
    @IBOutlet var pickedLocation: UILabel!
    
    var locationManager = CLLocationManager()
    
    var currentLocation : CLLocation!
    var currentPlacemark : CLPlacemark!
    


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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            
        case 3:
            pickLocation()
        case 4:
            pickDate()
        case 5:
            performSegue(withIdentifier: "pickInterestSegue", sender: self)
        case 6:
            present(imagePickerController, animated: true, completion: nil)
            
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
                formatter.dateFormat = "dd/MM/yyyy"
                self.pickedDate.text = formatter.string(from: dt)
                
                self.post.date = date?.timeString(ofStyle : .short)
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
    
    func didSelectInterestOption(option: InterestOptions) {
        self.pickedInterest.text = option.rawValue
        
        self.post.interest = option.rawValue
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
        
    }
    
    
    func pickInterest(completionHandler: @escaping (InterestOptions) -> Void) {
        performSegue(withIdentifier: "pickInterestSegue" , sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickInterestSegue"{
            let destination = segue.destination as? INterestOptionsTableViewController
            
            destination?.interestOptionDelegate = self
        }
    }
    
    
    func publishImage(image: UIImage) {
        postImagePreview.image = image
        
        self.post.image = FirebaseImage(image: image)
    }
    
    @IBAction func didTapCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSavePost(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        
        self.post.content = postContent.text
        self.post.uid = Auth.auth().currentUser?.uid
        
        let postid = self.post.saveTo(node: "posts")
        self.post.image?.save(withResouceType: "posts", withParentId: postid, withName: "postimage.jpg", errorHandler: { (error) in
            if error != nil {
                print(error)
            }
        })
        
    }
    
}

enum InterestOptions: String {
    case hosting = "Share hosting"
    case transport = "Share Transport"
    case group = "Share moments"
}
