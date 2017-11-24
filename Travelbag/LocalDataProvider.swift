//
//  LocalDataProvider.swift
//  Travelbag
//
//  Created by ifce on 23/11/17.
//  Copyright © 2017 ifce. All rights reserved.
//

import Foundation

class LocalDataProvider{
    let defaults : UserDefaults = UserDefaults.standard
    
    init(){
        
    }
     func provideUserFirstName() -> String{
        return self.defaults.string(forKey: "firstName") ?? "User"
        
    }
    
     func provideUserLastName() -> String{
        return self.defaults.string(forKey: "lastName") ?? "One"
    }
    
     func provideUserImage() -> String{
        return self.defaults.string(forKey: "imageProfile") ?? ""
    }
}
