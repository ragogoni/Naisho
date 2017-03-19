//
//  LocationManager.swift
//  Naisho
//
//  Created by cao on 2017/03/13.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import Foundation
import SwiftLocation
import CoreLocation


class LocationManager:NSObject{
    
    static var sharedInstance: LocationManager = {
        return LocationManager();
    }()
    
    private override init(){
        super.init()
    }
    
    /*
     update user's location only once and save lat and lon in UserDefaults.
     
     */
    public func updateUserLocationInUserDefaultsOnce(){
        // Request Location record it to userdefaults only when there is a significant change
        Location.getLocation(accuracy: .city, frequency: .oneShot, success: { (_, location) in
            UserDefaults.standard.setValue(String(describing:location.coordinate.longitude), forKeyPath: "lon");
            UserDefaults.standard.setValue(String(describing:location.coordinate.latitude), forKeyPath: "lat");
        }) { (request, last, error) in
            request.cancel() // stop continous location monitoring on error
        }
    }
    
}
