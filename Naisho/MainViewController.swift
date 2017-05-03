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
import KCFloatingActionButton

class MainViewController: BasicViewController {
    
    @IBOutlet weak var mapView: MGLMapView!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var loc = CLLocationCoordinate2D();
        loc.latitude = Double(UserDefaults.standard.string(forKey:"lat")!)!;
        loc.longitude = Double(UserDefaults.standard.string(forKey:"lon")!)!;
        
        // Start Searching
        FourSquareManager.sharedInstance.search(ll: loc, limit: 20,category: nil, radius: "3000",mapview: nil)
        
        // Add floating action Button
        let fab = KCFloatingActionButton()
        fab.buttonColor = UIColor.white
        fab.addItem("Settings", icon: UIImage(named: "settings")!)
        
        fab.addItem("Stars", icon: UIImage(named: "star")!, handler: { item in
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "Data") as! SimpleTableViewController
            self.present(nextView, animated: false, completion: nil)
            fab.close()
        })
        
        self.view.addSubview(fab)
        
        // set the delegate
        mapView.delegate = MapBoxManager.sharedInstance;
    
        
        // Optionally set a starting point.
        mapView.setCenter(loc, zoomLevel: 7, direction: 0, animated: false)
        mapView.showsUserLocation = true;
        
        // add pins
        for b in RealmManager.sharedInstance.getAllBusinesses(){
            mapView.addAnnotation(MapBoxManager.sharedInstance.getPin(title: b.name, location: CLLocationCoordinate2D(latitude: b.lat,longitude: b.lon), subtitile: b.name));
        }
        
    }

    func refresh()
    {
        for b in RealmManager.sharedInstance.getAllBusinesses(){
            mapView.addAnnotation(MapBoxManager.sharedInstance.getPin(title: b.name, location: CLLocationCoordinate2D(latitude: b.lat,longitude: b.lon), subtitile: b.name));
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
