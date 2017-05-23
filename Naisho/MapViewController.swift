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

class MapViewController: BasicViewController {
    
    @IBOutlet weak var mapView: MGLMapView!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(MLManager.sharedInstance.getLocalArray())
        
        
        // set the center to the new location
        if let lat = UserDefaults.standard.string(forKey:"lat"){
            if let lon = UserDefaults.standard.string(forKey:"lon"){
                var loc = CLLocationCoordinate2D();
                loc.latitude = Double(lat)!;
                loc.longitude = Double(lon)!;
                mapView.setCenter(loc, zoomLevel: 12, direction: 0, animated: false)
            }
        }
        
        // if the database if refreshed
        if(UserDefaults.standard.bool(forKey: "refreshed")){
            
            // remove annotations
            if self.mapView.annotations?.isEmpty == false{
                for a in self.mapView.annotations!{
                    self.mapView.removeAnnotation(a)
                }
            }
        
            // update the map
            print("DEBUG: "+String(RealmManager.sharedInstance.getTotalNumber()) + " items in Realm DB.")
            for b in RealmManager.sharedInstance.getAllBusinesses(){
                mapView.addAnnotation(MapBoxManager.sharedInstance.getPin(title: b.name, location:  CLLocationCoordinate2D(latitude: b.lat,longitude: b.lon), subtitile: b.name));
            }
            
            // set the refreshed to be false
            UserDefaults.standard.set(false, forKey: "refreshed")
            UserDefaults.standard.synchronize()
            
        }
        
        print("DEBUG: MapView ViewWillAppear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the delegate
        mapView.delegate = MapBoxManager.sharedInstance;
        mapView.showsUserLocation = true;
    
        
        // Optionally set a starting point.
        if let lat = UserDefaults.standard.string(forKey:"lat"){
            if let lon = UserDefaults.standard.string(forKey:"lon"){
                var loc = CLLocationCoordinate2D();
                loc.latitude = Double(lat)!;
                loc.longitude = Double(lon)!;
                mapView.setCenter(loc, zoomLevel: 7, direction: 0, animated: false)
            }
        }
        
        
        // add pins
        for b in RealmManager.sharedInstance.getAllBusinesses(){
            mapView.addAnnotation(MapBoxManager.sharedInstance.getPin(title: b.name, location: CLLocationCoordinate2D(latitude: b.lat,longitude: b.lon), subtitile: b.name));
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
