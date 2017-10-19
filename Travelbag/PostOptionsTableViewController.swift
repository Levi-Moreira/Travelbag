//
//  PostOptionsTableViewController.swift
//  Travelbag
//
//  Created by ifce on 19/10/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import UIKit
import ImagePicker
import DatePickerDialog
import CoreLocation



class PostOptionsTableViewController: UITableViewController, ImagePickerDelegate, CLLocationManagerDelegate {
    var optionsDelegate : PostOptionsDelegate?
    
    @IBOutlet var pickedDate: UILabel!
    
    @IBOutlet var pickedInterest: UILabel!
    
    @IBOutlet var pickedLocation: UILabel!
    
    var locationManager = CLLocationManager()
    
    var currentLocation : CLLocation!
    
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        if let image = images.first{
            optionsDelegate?.publishImage(image: image)
            imagePicker.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        return
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        return
    }
    

    let imagePickerController = ImagePickerController()
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
            
        case 1:
            pickDate()
        case 2:
            optionsDelegate?.pickInterest(completionHandler: { (option) in
                self.pickedInterest.text = option.rawValue
            })
        case 3:
            present(imagePickerController, animated: true, completion: nil)
        
        default:
            return
        }
    }
    
    func pickDate(){
      
            DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
                (date) -> Void in
                if let dt = date {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd/MM/yyyy"
                    self.pickedDate.text = formatter.string(from: dt)
                }
            }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations[0]
        
        getUserLocation(latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude) { (city) in
            self.pickedLocation.text = city
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func getUserLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completionHandler: @escaping (_ locationCity: String)-> Void){
        let geocoder = CLGeocoder()
        
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(location) { (placemark, error) in
            if (error != nil) {
                completionHandler("")
            }
            
            if((placemark?.count)! > 0){
                completionHandler((placemark?.first?.locality)!)
            }else{
                completionHandler("")
            }
        }
    }
}

protocol PostOptionsDelegate {
    func publishImage(image: UIImage)
    func pickInterest(completionHandler : @escaping(_ option: InterestOptions)->Void)
}

enum InterestOptions: String {
    case hosting = "Share hosting"
    case transport = "Share Transport"
    case group = "Share moments"
}
