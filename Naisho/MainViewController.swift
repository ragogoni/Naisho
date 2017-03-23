//
//  MainViewController.swift
//  Naisho
//
//  Created by cao on 2017/03/13.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import UIKit
import Mapbox
import SwiftLocation

class MainViewController: BasicViewController {
    
    @IBOutlet weak var mapView: MGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the delegate
        mapView.delegate = MapBoxManager.sharedInstance;
        
        // define center
        let center = CLLocationCoordinate2D(latitude: UserDefaults.standard.double(forKey: "lat"), longitude: UserDefaults.standard.double(forKey: "lon"))
        
        // Optionally set a starting point.
        mapView.setCenter(center, zoomLevel: 7, direction: 0, animated: false)
        
        
        for b in RealmManager.sharedInstance.getAllBusinesses(){
            print("yo")
            mapView.addAnnotation(MapBoxManager.sharedInstance.getPin(title: b.name, location: CLLocationCoordinate2D(latitude: b.lat,longitude: b.lon), subtitile: b.name));
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
