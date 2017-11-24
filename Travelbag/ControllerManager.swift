//
//  ControllerManager.swift
//  Travelbag
//
//  Created by ifce on 23/11/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import Foundation
import UIKit

struct ControllerManager {
    
    static let sharedInstance = ControllerManager()
    static var values: [String : Any]?
    
    func setupRootViewController(withIdentifier identifier: String, storyboardIdentifier: String, typeTransition: UIViewAnimationOptions, values: [String : Any]? = nil) {
        ControllerManager.values = values
        let viewController = getController(identifier, storyboardIdentifier: storyboardIdentifier)
        let appDelegate = getInstanceAppDelegate()
        
        guard let window = appDelegate.window else { print("Window does not exist"); return}
        
        UIView.transition(with: window, duration: 0.5, options: typeTransition, animations: {
            appDelegate.window?.rootViewController = viewController
        }, completion: { completed in
            print(completed)
        })
    }
    
    func getInstanceAppDelegate() -> AppDelegate {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate ?? AppDelegate()
    }
    
    func getController(_ identifier: String, storyboardIdentifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardIdentifier, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        
        return viewController
    }
}

