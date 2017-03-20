//
//  MapBoxManager.swift
//  Naisho
//
//  Created by cao on 2017/03/19.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import Foundation
import Mapbox

class MapBoxManager:NSObject{
    
    static var sharedInstance:MapBoxManager = {
        return MapBoxManager();
    }()
    
    private override init(){
    
    }
}
