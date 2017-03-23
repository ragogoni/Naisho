//
//  MapBoxManager.swift
//  Naisho
//
//  Created by cao on 2017/03/19.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import Foundation
import Mapbox

class MapBoxManager:NSObject,MGLMapViewDelegate{
    
    static var sharedInstance:MapBoxManager = {
        return MapBoxManager();
    }()
    
    private override init(){
    
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        // Wait for the map to load before initiating the first camera movement.
        
        // Create a camera that rotates around the same center point, rotating 180°.
        // `fromDistance:` is meters above mean sea level that an eye would have to be in order to see what the map view is showing.
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: 4500, pitch: 15, heading: 180)
        
        // Animate the camera movement over 5 seconds.
        mapView.setCamera(camera, withDuration: 5, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    }
}
